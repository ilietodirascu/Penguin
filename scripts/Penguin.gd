extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	self.floor_stop_on_slope = false
	self.set_motion_mode(MOTION_MODE_GROUNDED)
	self.floor_max_angle = 0.005 #this one is actually important, I think

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# todo add controls 
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal: Vector2 = collision.get_normal()
		var angle: float = -normal.angle()
		if get_real_velocity().x > 100: #magic
			rotate(sign(angle) * delta)
