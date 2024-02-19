extends RigidBody2D

var glideForce = 10  # Adjust this value to control the strength of the glide force.
# Called when the node enters the scene tree for the first time.

func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	angular_velocity = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#don't like the meta bs
	if get_colliding_bodies().any(func(body) : body.get_meta("Water", false)): # y u no work????????????????????
		reset_properties()
	else:
		modify_in_water()
	
	var direction : Vector2
	# Normalize the direction to ensure consistent movement speed in all directions
	if direction.length_squared() > 0:
		direction = direction.normalized()

	# Apply the glide force based on the arrow keys input
	apply_central_impulse(direction * glideForce)
	
	modify_angular_momentum()
	
func modify_in_water():
	# Adjust properties when in water (e.g., reduce gravity, apply buoyancy)
	var gravity_scale = 0.5  # Adjust this value according to your needs
	var linear_damping = 2.0  # Adjust this value according to your needs

	set_gravity_scale(gravity_scale)
	#set_linear_damping(linear_damping)

func reset_properties():
	print("not in wata(")
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
	
