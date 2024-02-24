extends Area2D

var peng_ref : RigidBody2D 
#:= preload("res://scripts/Penguin.gd")

func _ready():
	peng_ref = get_node("../RigidBody2D")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position.x = peng_ref.global_position.x
