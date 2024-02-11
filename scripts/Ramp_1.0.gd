extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var colission_shape = CollisionPolygon2D.new()
	colission_shape.polygon = polygon
	$StaticBody2D.add_child(colission_shape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ResourceSaver.save(Resource.new(), "res://materials/icy_surface.tres")
