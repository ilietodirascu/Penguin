extends Node

const filename : String = "res://config/progression.cfg"

var acceleration = 0
var air_resistance = 0
var glider = 0
var rocket = 0
var rocket_fuel = 0
var days = 0
var money = 0
var config: ConfigFile = null

func _init():
	config = load_from_file()
	
	

func load_from_file() -> ConfigFile:
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
	return progression
		
func update_value(value_name,value):
	config.set_value("",value_name,value)
	config.save(filename)
func get_value(value_name) -> int:
	return config.get_value("",value_name)

func get_acceleration() -> int:
	return get_value("acceleration")
	
func get_air_resistance() -> int:
	return get_value("air_resistance")

func get_glider() -> int:
	return get_value("glider")

func get_rocket() -> int:
	return get_value("rocket")

func get_rocket_fuel() -> int:
	return get_value("rocket_fuel")

func get_days() -> int:
	return get_value("days")

func get_money() -> int:
	return get_value("money")

func set_acceleration(value):
	update_value("acceleration",value)
	
func set_air_resistance(value):
	update_value("air_resistance",value)
	
func set_glider(value):
	update_value("glider",value)
	
func set_rocket(value):
	update_value("rocket",value)
	
func set_rocket_fuel(value):
	update_value("rocket_fuel",value)

func set_days(value):
	update_value("days",value)

func set_money(value):
	update_value("money",value)
