extends RigidBody2D

var glideForce = 1000  # Adjust this value to control the strength of the glide force.
# Called when the node enters the scene tree for the first time.
var lift_strength = 800  # Adjusted for more noticeable lift
var drag_coefficient = 0.1

func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	angular_velocity = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var direction : Vector2
	# Normalize the direction to ensure consistent movement speed in all directions
	if direction.length_squared() > 0:
		direction = direction.normalized()
	
	# Apply the glide force based on the arrow keys input
	apply_central_impulse(direction * glideForce)
	apply_lift()
	apply_drag()
	modify_angular_momentum()
	
	
func modify_in_water():
	# Adjust properties when in water (e.g., reduce gravity, apply buoyancy)
	var gravity_scale = 0.5  # Adjust this value according to your needs
	var linear_damping = 2.0  # Adjust this value according to your needs

	set_gravity_scale(gravity_scale)
	#set_linear_damping(linear_damping)

func reset_properties():
	print("not in wata")
	# Reset properties when not in water
	set_gravity_scale(1.0)
	#set_linear_damping(0.0)
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
	
