extends RigidBody2D

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
	

func apply_rocket_config():
	match  FileManager.get_rocket():
		1:
			boost_strength = 300
		2:
			boost_strength = 500
		3:
			boost_strength = 800
	rocket_fuel = FileManager.get_rocket_fuel()
	
func apply_glider_config():
	match FileManager.get_glider():
		1:
			lift_strength = 400
		2: 
			lift_strength = 700
		3:
			lift_strength = 1000
		
func apply_air_resistance_config():
	var air_resistance = FileManager.get_air_resistance()
	# Ensure air_resistance is within the expected range
	air_resistance = clamp(air_resistance, 0, 10)
	# Map from 0-10 to 1-0.1
	drag_coefficient = lerp(1.0, 0.1, air_resistance / 10.0)

func apply_acceleration_config():
	acceleration = FileManager.get_acceleration()
	acceleration = clamp(acceleration,0,10)
	acceleration = lerp(1.0,1.9,acceleration / 10)

func apply_file_config():
	apply_rocket_config()
	apply_glider_config()
	apply_air_resistance_config()
	apply_acceleration_config()

func _physics_process(delta):
	if direction.length_squared() > 0:
		direction = direction.normalized() 
	raycasting_process(delta)
	if is_on_ramp:
		set_gravity_scale(ramp_gravity_scale)
	else:
		reset_gravity()
		
	
	apply_central_impulse(direction * acceleration) 
	if !is_on_ramp && !touch_water:
		apply_lift()
		apply_drag()
		modify_angular_momentum()
		apply_boost(delta)
	track_altitude()
func modify_in_water():
   # Adjust properties when in water (e.g., reduce gravity, apply buoyancy)
	var gravity_scale = 0.5
	var linear_damping = 2.0
	set_gravity_scale(gravity_scale)

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
	var lift_force = Vector2(0, -1) * lift_strength  # lift_strength is a variable you can adjust
	apply_central_force(lift_force)

func apply_drag():
	var velocity = linear_velocity
	var drag_force = velocity.normalized() * -drag_coefficient * velocity.length()  # drag_coefficient is a variable you can adjust
	apply_central_force(drag_force)

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
	var current_altitude = position.y  # This is an example; adjust based on your game's logic
	if current_altitude > max_altitude:
		max_altitude = current_altitude

func _on_wota_2_body_exited(body):
	linear_velocity.y = 0.4 * linear_velocity.y
	if linear_velocity.y > -80 && touch_water && self.is_inside_tree():
		var distance = (linear_velocity.length() / 100)
		var duration = Time.get_unix_time_from_system() - start_time
		var altitude = (max_altitude / 100)
		var total = round(altitude + distance)
		Results.set_distance("%.2f" %  distance + "m")
		Results.set_duration("%.2f" % duration + "s")
		Results.set_altitude("%.2f" % altitude + "m")
		Results.set_total("%s$" % total)
		print(round(altitude + distance))
		print(altitude)
		print(distance)
		FileManager.set_money(FileManager.get_money() + total)
		get_tree().change_scene_to_file("res://scenes/results.tscn")

func _on_wota_2_body_entered(body):
	if body.is_in_group("character"):
		touch_water = true
		var water_sfx = $"water_sfx"
		water_sfx.play()


		
