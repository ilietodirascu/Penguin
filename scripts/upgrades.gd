extends Control

const filename : String = "res://config/progression.cfg"

var acceleration = 0
var air_resistance = 0
var glider = 0
var rocket = 0
var rocket_fuel = 0
var days = 0

func _ready():
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

func _process(delta):
	pass
	

