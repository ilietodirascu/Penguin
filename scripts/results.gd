extends Node

var distance = 0
var duration = 0
var altitude = 0
var total = 0
# Called when the node enters the scene tree for the first time.

func set_distance(value):
	distance = value

# Setter for duration
func set_duration(value):
	duration = value

# Setter for altitude
func set_altitude(value):
	altitude = value

# Setter for total
func set_total(value):
	total = value
func get_distance():
	return distance

# Getter for duration
func get_duration():
	return duration

# Getter for altitude
func get_altitude():
	return altitude

# Getter for total
func get_total():
	return total
