extends ItemList

var max_upgrade
var upgrades

func _ready():
	upgrades = get_node("/root/Upgrades")
	
	var checkbox_empty = preload("res://Assets/ui/checkbox_empty.png")
	var checkbox_checked = preload("res://Assets/ui/checkbox_checked.png")
	
	for i in range(upgrades.acceleration):
		add_item("", checkbox_checked, true)
	
	for i in range(5 - upgrades.acceleration):
		add_item("", checkbox_empty, false)


func _process(delta):
	pass