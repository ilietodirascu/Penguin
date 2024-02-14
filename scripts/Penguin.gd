extends CharacterBody2D

var gravity = Vector2(0, 500)  # Adjust the gravity vector as needed

func _physics_process(delta):
	# Apply gravity
	velocity += gravity * delta

	# Assuming the CharacterBody2D is already set to 'floating' mode
	# which is appropriate for icy conditions without distinct floor/wall/ceiling
	motion_mode = MOTION_MODE_FLOATING

	# The `velocity` property will be automatically used by `move_and_slide`
	move_and_slide()
	
	# After move_and_slide, the `velocity` property is automatically updated
	# by Godot to reflect the new velocity after the physics step.
