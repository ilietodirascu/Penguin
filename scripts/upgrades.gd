extends Control

const filename : String = "res://config/progression.cfg"
const marked_texture = preload("res://Assets/menus/marked_box.png")
const unmarked_texture = preload("res://Assets/menus/unmarked_box.png")
var acceleration = 0
var air_resistance = 0
var glider = 0
var rocket = 0
var rocket_fuel = 0
var days = 0
var money = 0

func _ready():
	load_from_file()
	render_buttons($TextureRect/Acceleration,acceleration,10,2,"acceleration")
	render_buttons($"TextureRect/Air Resistance",air_resistance,15,3,"air_resistance")
	render_buttons($"TextureRect/Rocket Fuel",rocket_fuel,20,4,"rocket_fuel")
	handle_days()

func render_buttons(path,param,initial_price,price_scaling,name,total_buttons: int = 10):
	var item_list = path
	
	for i in range(param):
		var btn = CustomButton.new(marked_texture,initial_price,true,name)
		item_list.add_child(btn)
	for i in range(total_buttons - param):
		var btn = CustomButton.new(unmarked_texture,initial_price,false,name)
		item_list.add_child(btn)
	var index = 0
	for child in item_list.get_children():
		child.set_price((index+1) * initial_price * price_scaling)
		index += 1


func handle_days():
	var days_label = $TextureRect/Days
	days_label.text = str(days)
	days_label.add_theme_font_size_override("font_size", 36)

func load_from_file():
	var progression : ConfigFile = ConfigFile.new();
	if progression.load(filename) == OK:
		acceleration = progression.get_value("", "acceleration")
		air_resistance = progression.get_value("", "air_resistance")
		glider = progression.get_value("", "glider")
		rocket = progression.get_value("", "rocket")
		rocket_fuel = progression.get_value("", "rocket_fuel")
		days = progression.get_value("", "days")
		money = progression.get_value("","money")
	else:
		progression.set_value("", "acceleration", 0)
		progression.set_value("", "air_resistance", 0)
		progression.set_value("", "glider", 0)
		progression.set_value("", "rocket", 0)
		progression.set_value("", "rocket_fuel", 0)
		progression.set_value("", "days", 0)
		progression.set_value("","money",0)
		progression.save(filename)


func _on_ready_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn") # Replace with function body.
	




