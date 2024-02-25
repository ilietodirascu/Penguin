extends Control

const filename : String = "res://config/progression.cfg"

var acceleration = 0
var air_resistance = 0
var glider = 0
var rocket = 0
var rocket_fuel = 0
var days = 0

func _ready():
	render_buttons()

func _process(delta):
	pass
	
func load_from_file():
	var progression : ConfigFile = ConfigFile.new();
	if progression.load(filename) == OK:
		acceleration = progression.get_value("", "acceleration")
		air_resistance = progression.get_value("", "air_resistance")
		glider = progression.get_value("", "glider")
		rocket = progression.get_value("", "rocket")
		rocket_fuel = progression.get_value("", "rocket_fuel")
		days = progression.get_value("", "days")
	else:
		progression.set_value("", "acceleration", 0)
		progression.set_value("", "air_resistance", 0)
		progression.set_value("", "glider", 0)
		progression.set_value("", "rocket", 0)
		progression.set_value("", "rocket_fuel", 0)
		progression.set_value("", "days", 0)
		progression.save(filename)


func _on_ready_button_pressed():
	print(acceleration)
	get_tree().change_scene_to_file("res://scenes/main.tscn") # Replace with function body.
	
func render_buttons():
	var item_list = $TextureRect/Acceleration
	var texture = preload("res://Assets/menus/unmarked_box.png")
	for i in range(10):
		var item = TextureButton.new()
		item.texture_normal = texture
		item.set_h_size_flags(SIZE_EXPAND)
		item.set_v_size_flags(SIZE_EXPAND)
		item.set_size(Vector2(60,30))
		item_list.add_child(item)
	
