extends Area2D

# I hate every second of this, y is body_exited never called??
# I chaged monitoring to true, I tried set_contact_monitor for the penguin
# it detects the colission but simply doesn't call body_exited, am I missing something? is it broken? I don't know
# I give up, cavemen solution it is

var entered: bool = false
var peng_instance: Node2D;

func _ready():
	set_monitoring(true)

func _process(delta):
	var penng : Node2D = get_peng()
	if penng != null:
		peng_instance = penng
		entered = true
	elif entered && peng_instance != null:
		entered = false #todo make it float
		peng_instance.linear_velocity.y = 0.4 * peng_instance.linear_velocity.y
		#peng_instance.apply_force(-peng_instance.linear_velocity * 10, peng_instance.linear_velocity)
		#print(peng_instance.linear_velocity.y)
		
func get_peng() -> Node2D:
	for body in get_overlapping_bodies():
		if(body.get_meta("is_character", false)):
			return body
	return null

	
func body_entered(body: Node2D):
	print("body_entered 00")
	
func body_exited(body: Node2D):
	print("exited 00")
