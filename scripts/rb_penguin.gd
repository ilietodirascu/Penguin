extends RigidBody2D

var glideForce = 1000  # Adjust this value to control the strength of the glide force.
var lift_strength = 800  # Adjusted for more noticeable lift
var drag_coefficient = 0.1
var is_on_ramp = true
var raycast:RayCast2D = null


func _ready():
	raycast = $RayCast2D
	angular_velocity = 0.0
	
func _physics_process(delta):
	var direction : Vector2
	if direction.length_squared() > 0:
		direction = direction.normalized()
	
	raycasting_process(delta)
	
	apply_central_impulse(direction * glideForce)
	
	if(!is_on_ramp):
		apply_lift()
		apply_drag()
		modify_angular_momentum()
	
func modify_angular_momentum():
	if Input.is_action_pressed("ui_right") && angular_velocity < 1:
		angular_velocity += 1
		set_angular_velocity(angular_velocity)
	if Input.is_action_pressed("ui_left") && angular_velocity > -1:
		angular_velocity -= 1
		set_angular_velocity(angular_velocity)
		
func apply_lift():
	var lift_force = Vector2(0, -1) * lift_strength  # lift_strength is a variable you can adjust
	apply_central_force(lift_force)

func apply_drag():
	var velocity = linear_velocity
	var drag_force = velocity.normalized() * -drag_coefficient * velocity.length()  # drag_coefficient is a variable you can adjust
	apply_central_force(drag_force)

	
func raycasting_process(delta):
	var collider = raycast.get_collider()
	if collider:
		var i = raycast.get_collider_shape()
		var hit_node = collider.shape_owner_get_owner(collider.shape_find_owner(i))
		var parent_node = hit_node.get_parent()
		if parent_node && parent_node.is_in_group("ramp"):
			is_on_ramp = true
		else:
			is_on_ramp = false
	else:
		is_on_ramp = false
