extends TextureButton

class_name CustomButton
const marked_texture = preload("res://Assets/menus/marked_box.png")

var param_name = ""
var price = 0
var is_marked = false
var value = 0
var shop:Shop = null
func _init(texture: Resource, initial_price: int,is_marked,name,shop,size:Vector2 = Vector2(60,30)):
	self.texture_normal = texture
	self.price = initial_price
	self.set_h_size_flags(SIZE_EXPAND)
	self.set_v_size_flags(SIZE_EXPAND)
	self.set_size(size)
	self.connect("mouse_entered",_on_mouse_entered)
	self.connect("mouse_exited",_on_mouse_exited)
	self.connect("pressed",_on_mouse_pressed)
	self.is_marked = is_marked
	self.value = value
	self.shop = shop
	param_name = name
func _ready():
	pass

func set_price(new_price):
	price = new_price

func set_value(value):
	self.value = value

func _on_mouse_entered():
	if(!is_marked):
		shop.update_upgrade_cost_label(str(count_total_price()))
	
func _on_mouse_exited():
	shop.update_upgrade_cost_label("")

func _on_mouse_pressed():
	print(param_name)
	var total_price = count_total_price()
	if(!is_marked and can_buy(total_price)):
		mark_all_unmarked()
		FileManager.set_money(FileManager.get_money() - total_price)
		FileManager.update_value(param_name,value)
		shop.update_upgrade_cost_label("")
		shop.update_money_label(FileManager.get_money())

func count_total_price() -> int:
	var total_price = price
	if not is_marked:
		var siblings = get_parent().get_children()
		for sibling in siblings:
			if sibling == self:
				break  # Start counting from this button
			if  sibling is CustomButton and not sibling.is_marked:
				total_price += sibling.price
	return total_price

func mark_all_unmarked():
	var siblings = get_parent().get_children()
	for sibling in siblings:
		if sibling is CustomButton and not sibling.is_marked:
			sibling.mark()
		if sibling == self:
			return

func can_buy(total_price) -> bool:
	return total_price <= FileManager.get_money()
	
func mark():
	is_marked = true
	texture_normal = marked_texture
	
