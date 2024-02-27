extends TextureButton

class_name CustomButton
const marked_texture = preload("res://Assets/menus/marked_box.png")

var param_name = ""
var price = 0
var cost_label: Label = null
var is_marked = false
func _init(texture: Resource, initial_price: int,isMarked,name,size:Vector2 = Vector2(60,30)):
	self.texture_normal = texture
	self.price = initial_price
	self.set_h_size_flags(SIZE_EXPAND)
	self.set_v_size_flags(SIZE_EXPAND)
	self.set_size(size)
	self.connect("mouse_entered",_on_mouse_entered)
	self.connect("mouse_exited",_on_mouse_exited)
	self.connect("pressed",_on_mouse_pressed)
	is_marked = isMarked
	param_name = name

func _ready():
	var parent_node = get_parent()
	cost_label = parent_node.get_node("../UpgradeCost")

func set_price(new_price):
	price = new_price

func _on_mouse_entered():
	if(!is_marked):
		cost_label.text = str(price)
	
func _on_mouse_exited():
	cost_label.text = ""

func _on_mouse_pressed():
	print(param_name)
	if(!is_marked):
		is_marked = true
		texture_normal = marked_texture
		cost_label.text = ""
	
	
