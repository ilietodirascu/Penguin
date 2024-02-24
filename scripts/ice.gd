extends RigidBody2D


var pengu:RigidBody2D = null
func _ready():
	pengu = null;
	
	
func _process(delta):
	if pengu != null && is_velocity_zero(pengu):
		end_run()



func _on_area_2d_body_entered(body):
	if(body.is_in_group("character")):
		pengu = body

func _physics_process(delta):
	if pengu and is_velocity_zero(pengu):
		end_run()

func is_velocity_zero(rigidbody):
	return rigidbody.linear_velocity.length_squared() < 0.01  # Threshold can be adjusted

func end_run():
	get_tree().quit()  # Quit the game
	pass
