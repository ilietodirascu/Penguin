extends RigidBody2D

const glider_1_texture = preload("res://Assets/gliders/glider_1.png")
const glider_2_texture = preload("res://Assets/gliders/glider_2.png")
const glider_3_texture = preload("res://Assets/gliders/glider_3.png")
const rocket_1_texture = preload("res://Assets/rockets/rocket_1.png")
const rocket_2_texture = preload("res://Assets/rockets/rocket_2.png")
const rocket_3_texture = preload("res://Assets/rockets/rocket_3.png")


var lift_strength = 0 
var drag_coefficient = 0
var raycast:RayCast2D = null
var direction : Vector2
var gravity_vector = Vector2(0,1)
const ramp_gravity_scale = 2.0
var boost_strength = 0 
var rocket_fuel = 0
var current_boost_time = 0
var is_on_ramp = true
var touch_water : bool = false
var max_altitude = 0
var start_time = 0
var acceleration = 0
var previous_speed = 0
var speed = 0
func _ready():
	var wind_sfx = $"wind_sfx"
	wind_sfx.play()
	reset_gravity()
	contact_monitor = true
	raycast = $RayCast2D
	max_contacts_reported = 2
	angular_velocity = 0.0
	direction = Vector2(1,1)
	apply_file_config()
	start_time = Time.get_unix_time_from_system()

func update_speed():
	var current_speed = linear_velocity.length()

	# Calculate the variation in speed (could be negative if slowing down)
	var speed_variation = current_speed - previous_speed
	previous_speed = current_speed
	speed = speed_variation


func _physics_process(delta):
	raycasting_process(delta)
	if is_on_ramp:
		set_gravity_scale(ramp_gravity_scale)
	else:
		reset_gravity()
	apply_central_impulse(Vector2(1,0)) 
	if !is_on_ramp && !touch_water:
		fly()
		apply_boost(delta)
	track_altitude()
	update_speed()

func apply_rocket_config():
	var rocket = Sprite2D.new()
	match  FileManager.get_rocket():
		1:
			boost_strength = 300
			rocket.texture = rocket_1_texture
			scale_rocket(rocket)
			self.add_child(rocket)
		2:
			boost_strength = 500
			rocket.texture = rocket_2_texture
			scale_rocket(rocket)
			self.add_child(rocket)
		3:
			boost_strength = 800
			rocket.texture = rocket_3_texture
			scale_rocket(rocket)
			self.add_child(rocket)
	rocket_fuel = FileManager.get_rocket_fuel()
	
func apply_glider_config():
	var glider_level = FileManager.get_glider()
	var glider:Sprite2D = Sprite2D.new()
	match glider_level:
		1:
			lift_strength = 1500
			glider.texture = glider_1_texture
			scale_glider(glider)
			self.add_child(glider)
		2: 
			lift_strength = 1800
			glider.texture = glider_2_texture
			scale_glider(glider)
			self.add_child(glider)
		3:
			lift_strength = 2200
			glider.texture = glider_3_texture
			scale_glider(glider)
			self.add_child(glider)
func apply_air_resistance_config():
	var air_resistance = FileManager.get_air_resistance()
	# Ensure air_resistance is within the expected range
	air_resistance = clamp(air_resistance, 0, 10)
	# Map from 0-10 to 1-0.1
	drag_coefficient = lerp(2.0, 1.0, air_resistance / 10.0)

func apply_acceleration_config():
	acceleration = FileManager.get_acceleration()
	acceleration = clamp(acceleration,0,10)
	acceleration = lerp(1.0,1.9,acceleration / 10)

func scale_glider(glider:Sprite2D):
	glider.position.x = -7
	glider.position.y = -18
	glider.rotation = 0.5
	glider.scale.x = 0.240
	glider.scale.y = 0.260

func scale_rocket(rocket:Sprite2D):
		rocket.position.x = -43
		rocket.position.y = 1
		rocket.rotation = 0.5
		rocket.scale.x = 0.24
		rocket.scale.y = 0.26

func apply_file_config():
	apply_rocket_config()
	apply_glider_config()
	apply_air_resistance_config()
	apply_acceleration_config()


func modify_in_water():
   # Adjust properties when in water (e.g., reduce gravity, apply buoyancy)
	var gravity_scale = 0.5
	var linear_damping = 2.0
	set_gravity_scale(gravity_scale)

func fly():
	if(rotation_degrees < 0 && rotation_degrees >= -90):
		apply_lift()
		apply_drag()
		#reset_gravity()
	scale_gravity()
	modify_angular_momentum()
	
func scale_gravity():
	var threshold = 0.1  # Define the sensitivity of the change, adjust as needed
	var closeness_to_zero = min(abs(speed) / threshold, 1.0)
	var mapped_gravity_scale = lerp(3.0, 1.0, closeness_to_zero)
	set_gravity_scale(mapped_gravity_scale)
	
func reset_gravity():
	set_gravity_scale(1.0)

func modify_angular_momentum():
	if Input.is_action_pressed("ui_right") && angular_velocity < 1:
		angular_velocity += 0.5
		set_angular_velocity(angular_velocity)
	if Input.is_action_pressed("ui_left") && angular_velocity > -1:
		angular_velocity -= 0.5
		set_angular_velocity(angular_velocity)

		
func apply_boost(delta):
	var rocket_sfx = $"rocket_sfx"
	var music_position = rocket_sfx.get_playback_position()
	if Input.is_action_pressed("apply_boost") and rocket_fuel > 0:
		var boost_direction = Vector2(1, 0).rotated(rotation)  # Align with penguin's forward direction
		apply_central_force(boost_direction * boost_strength) 
		rocket_fuel -= delta
		rocket_sfx.play(music_position)
	else:
		rocket_sfx.stop()
		



func apply_lift():
	#var lift_force = Vector2(0, -1) * lift_strength  # lift_strength is a variable you can adjust
	#apply_central_force(lift_force)
	var force = Vector2(lift_strength * cos(rotation),lift_strength*sin(rotation))
	apply_central_force(force)
func apply_drag():
	var velocity = linear_velocity
	var speed = velocity.length()
	var dynamic_drag_coefficient = lerp(drag_coefficient, drag_coefficient * 2, speed / 1000)
	var drag_force = velocity.normalized() * -dynamic_drag_coefficient * speed
	apply_central_force(drag_force)

func get_angle_of_attack() -> float:
	var forward_direction = Vector2(cos(rotation), sin(rotation))
	var velocity_direction = linear_velocity.normalized()
	
	# Ensure we don't calculate the AoA when there's no movement
	if linear_velocity.length() == 0:
		return 0

	# Calculate the angle between the two vectors
	var dot_product = forward_direction.dot(velocity_direction)
	var angle = acos(dot_product)
	
	# Convert radians to degrees if needed (optional)
	var angle_degrees = rad_to_deg(angle)
	
	return angle_degrees 

func raycasting_process(delta):
	var collider = raycast.get_collider()
	if collider:
		var i = raycast.get_collider_shape()
		var hit_node = collider.shape_owner_get_owner(collider.shape_find_owner(i))
		var parent_node = hit_node.get_parent()
		if parent_node && parent_node.is_in_group("ramp"):
			is_on_ramp = true
		else:
			is_on_ramp = false
	else:
		is_on_ramp = false
func track_altitude():
	var current_altitude = abs(position.y)  
	if current_altitude > max_altitude:
		max_altitude = current_altitude

func _on_wota_2_body_exited(body):
	linear_velocity.y = 0.4 * linear_velocity.y
	if linear_velocity.y > -80 && touch_water && self.is_inside_tree():
		var distance = (linear_velocity.length() / 10)
		var duration = Time.get_unix_time_from_system() - start_time
		var altitude = (max_altitude / 100)
		var total = round(altitude + distance)
		Results.set_distance("%.2f" %  distance + "m")
		Results.set_duration("%.2f" % duration + "s")
		Results.set_altitude("%.2f" % altitude + "m")
		Results.set_total("%s$" % total)
		FileManager.set_money(FileManager.get_money() + total)
		get_tree().change_scene_to_file("res://scenes/results.tscn")

func _on_wota_2_body_entered(body):
	if body.is_in_group("character"):
		touch_water = true
		var water_sfx = $"water_sfx"
		water_sfx.play()


		
