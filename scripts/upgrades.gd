extends Control
class_name Shop
const marked_texture = preload("res://Assets/menus/marked_box.png")
const unmarked_texture = preload("res://Assets/menus/unmarked_box.png")
var acceleration_container: HBoxContainer = null
var air_resistance_container: HBoxContainer = null
var rocket_fuel_container: HBoxContainer = null
var days_label: Label = null
var money_label: Label = null
var upgrade_cost_label: Label = null
const glider_1_cost = 500
const glider_2_cost = 2500
const glider_3_cost = 10000
const rocket_1_cost = 750
const rocket_2_cost = 5000
const rocket_3_cost = 15000
func _ready():
	acceleration_container = $TextureRect/Acceleration
	air_resistance_container = $"TextureRect/Air Resistance"
	rocket_fuel_container = $"TextureRect/Rocket Fuel"
	days_label = $TextureRect/Days
	money_label = $TextureRect/Money
	upgrade_cost_label = $TextureRect/UpgradeCost
	render_buttons(acceleration_container,FileManager.get_acceleration(),10,2,"acceleration")
	render_buttons(air_resistance_container,FileManager.get_air_resistance(),15,3,"air_resistance")
	render_buttons(rocket_fuel_container,FileManager.get_rocket_fuel(),20,4,"rocket_fuel")
	display_days()
	display_money()

func render_buttons(path,param,initial_price,price_scaling,name,total_buttons: int = 10):
	var item_list = path
	
	for i in range(param):
		var btn = CustomButton.new(marked_texture,initial_price,true,name,self)
		item_list.add_child(btn)
	for i in range(total_buttons - param):
		var btn = CustomButton.new(unmarked_texture,initial_price,false,name,self)
		item_list.add_child(btn)
	var index = 0
	for child in item_list.get_children():
		child.set_price((index+1) * initial_price * price_scaling)
		child.set_value(index + 1)
		index += 1



func play_boom():
	var boom_sfx = $"TextureRect/Boom_sfx"
	boom_sfx.play()

func _on_ready_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn") # Replace with function body.
	FileManager.set_days(FileManager.get_days() + 1)
	
func display_days():
	days_label.text = str(FileManager.get_days())
	days_label.add_theme_font_size_override("font_size", 36)


func display_money():
	money_label.text = str(FileManager.get_money())
	money_label.add_theme_font_size_override("font_size",50)


func update_upgrade_cost_label(value):
	upgrade_cost_label.text = str(value)

func update_money_label(value):
	money_label.text = str(value)

func can_buy(cost) -> bool:
	return FileManager.get_money() >= cost


func _on_glider_1_mouse_entered():
	if(FileManager.get_glider() < 1):
		update_upgrade_cost_label(glider_1_cost)


func _on_glider_1_mouse_exited():
	update_upgrade_cost_label("")

func process_glider_transaction(cost,value):
	if(FileManager.get_glider() >= value || not can_buy(cost)):
		return
	FileManager.set_glider(value)
	update_money_label(FileManager.get_money() - cost)
	FileManager.set_money(FileManager.get_money() - cost)

func process_rocket_transaction(cost,value):
	if(FileManager.get_rocket() >= value || not can_buy(cost)):
		return
	FileManager.set_rocket(value)
	update_money_label(FileManager.get_money() - cost)
	FileManager.set_money(FileManager.get_money() - cost)

func _on_glider_1_pressed():
	process_glider_transaction(glider_1_cost,1)


func _on_glider_2_mouse_entered():
	if(FileManager.get_glider() < 2):
		update_upgrade_cost_label(glider_2_cost)


func _on_glider_2_mouse_exited():
	update_upgrade_cost_label("")


func _on_glider_2_pressed():
	process_glider_transaction(glider_2_cost,2)


func _on_glider_3_mouse_entered():
	if(FileManager.get_glider() < 3):
		update_upgrade_cost_label(glider_3_cost)


func _on_glider_3_mouse_exited():
	update_upgrade_cost_label("")


func _on_glider_3_pressed():
	process_glider_transaction(glider_3_cost,3)


func _on_rocket_1_mouse_entered():
	if(FileManager.get_rocket() < 1):
		update_upgrade_cost_label(rocket_1_cost)


func _on_rocket_1_mouse_exited():
	update_upgrade_cost_label("")


func _on_rocket_1_pressed():
	process_rocket_transaction(rocket_1_cost,1)


func _on_rocket_2_pressed():
	process_rocket_transaction(rocket_2_cost,2)


func _on_rocket_2_mouse_entered():
	if(FileManager.get_rocket() < 2):
		update_upgrade_cost_label(rocket_2_cost)


func _on_rocket_2_mouse_exited():
	update_upgrade_cost_label("")


func _on_rocket_3_pressed():
	process_rocket_transaction(rocket_3_cost,3)


func _on_rocket_3_mouse_entered():
	if(FileManager.get_rocket() < 3):
		update_upgrade_cost_label(rocket_3_cost)


func _on_rocket_3_mouse_exited():
	update_upgrade_cost_label("")
