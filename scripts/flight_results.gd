extends Node

var next_scene_path = "res://scenes/shop.tscn"

func _ready():
	$TextureRect/Distance.text = str(Results.get_distance())
	$TextureRect/Altitude.text = str(Results.get_altitude())
	$TextureRect/Duration.text = str(Results.get_duration())
	$TextureRect/Total.text = str(Results.get_total())

func _input(event):
	if event is InputEventKey and event.pressed:
		change_scene()

func change_scene():
	if self.is_inside_tree():
		get_tree().change_scene_to_file(next_scene_path)
		
