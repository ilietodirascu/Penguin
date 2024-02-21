extends StaticBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ResourceSaver.save(Resource.new(), "res://materials/icy_surface.tres")
