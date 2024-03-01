extends HBoxContainer

var max_upgrade
var upgrades

func _ready():
	upgrades = get_node("/root/shop")
	upgrades.load_from_file()
	
	var checkbox_empty = preload("res://Assets/ui/checkbox_empty.png")
	var checkbox_checked = preload("res://Assets/ui/checkbox_checked.png")
	
	
	
	print(upgrades.acceleration)
	for i in range(upgrades.acceleration):
		add_spacer(true)
	
	for i in range(5 - upgrades.acceleration):
		add_spacer(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
