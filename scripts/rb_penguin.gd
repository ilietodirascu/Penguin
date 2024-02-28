extends RigidBody2D

var glideForce = 1  # Adjust for the desired forward glide
var lift_strength = 800 
var drag_coefficient = 0.1  
var raycast:RayCast2D = null
var direction : Vector2
var gravity_vector = Vector2(0,1)
const ramp_gravity_scale = 2.0
var boost_strength = 300 

var is_on_ramp = true
var touch_water : bool = false


func _ready():
	reset_gravity()
	contact_monitor = true
	raycast = $RayCast2D
	max_contacts_reported = 2
	angular_velocity = 0.0
	direction = Vector2(1,1)

func _physics_process(delta):
	if direction.length_squared() > 0:
		direction = direction.normalized() 
	
	raycasting_process(delta)

	if is_on_ramp:
		set_gravity_scale(ramp_gravity_scale)
	else:
		reset_gravity()
	
	apply_central_impulse(direction * glideForce) 
	if !is_on_ramp && !touch_water:
		apply_lift()
		apply_drag()
		modify_angular_momentum()
		apply_boost()

func modify_in_water():
   # Adjust properties when in water (e.g., reduce gravity, apply buoyancy)
	var gravity_scale = 0.5
	var linear_damping = 2.0
	set_gravity_scale(gravity_scale)

func reset_gravity():
	set_gravity_scale(1.0)

func modify_angular_momentum():
	if Input.is_action_pressed("ui_right") && angular_velocity < 1:
		angular_velocity += 0.5
		set_angular_velocity(angular_velocity)
	if Input.is_action_pressed("ui_left") && angular_velocity > -1:
		angular_velocity -= 0.5
		set_angular_velocity(angular_velocity)

func apply_gradual_counter_torque(torque: float, limit: float): 
	var difference = rotation - deg_to_rad(limit)
	var ratio = clamp(difference / deg_to_rad(10), 0, 1)  # Gradual force within 10 degrees
	apply_torque(torque * ratio)
		
func apply_boost():
	if Input.is_action_pressed("apply_boost"):
		var boost_direction = Vector2(1, 0).rotated(rotation)  # Align with penguin's forward direction
		apply_central_force(boost_direction * boost_strength) 

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

func _on_wota_2_body_exited(body):
	linear_velocity.y = 0.4 * linear_velocity.y
	if linear_velocity.y > -80 && touch_water && self.is_inside_tree():
		get_tree().change_scene_to_file("res://scenes/shop.tscn")

func _on_wota_2_body_entered(body):
	if body.is_in_group("character"):
		touch_water = true


		
