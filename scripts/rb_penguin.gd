extends RigidBody2D

var glideForce = 1000  # Adjust this value to control the strength of the glide force.
var lift_strength = 800  # Adjusted for more noticeable lift
var drag_coefficient = 0.1

func _ready():
	angular_velocity = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#apply_lift() # this makes it run in 10 frames, tf?
	#apply_drag()
		
	modify_angular_momentum()
	apply_central_impulse(Vector2.ZERO * glideForce)
	
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
	
