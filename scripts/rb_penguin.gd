extends RigidBody2D

var glideForce = 10  # Adjust this value to control the strength of the glide force.

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_colliding_bodies().find(func(body) : body.get_meta("Water", false)))
	#don't like the meta bs
	if get_colliding_bodies().any(func(body) : body.get_meta("Water", false)): # y u no work????????????????????
		reset_properties()
	else:
		modify_in_water()
	
	var direction : Vector2
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize the direction to ensure consistent movement speed in all directions
	if direction.length_squared() > 0:
		direction = direction.normalized()

	# Apply the glide force based on the arrow keys input
	apply_central_impulse(direction * glideForce)
	
func modify_in_water():
	print("in wata)")
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
