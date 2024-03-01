extends Node2D

var peng_ref : RigidBody2D 

var speed : float
var distance : float
var altitude : float
# Called when the node enters the scene tree for the first time.
func _ready():
	peng_ref = get_node("../../RigidBody2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
