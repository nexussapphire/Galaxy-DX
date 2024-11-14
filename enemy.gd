extends  RigidBody2D

#state of entity
enum mode {FLIGHT, FIGHT, GRID, LAST_STAND}
@export var state_machine : mode = mode.FIGHT
@export var missile_entity : PackedScene
@export_category("movement")
@export var speed : int = 300
@export var movement_delta : float = 5
@export var rotation_delta : float = .1
@export var movement_deadzone : int = 30
@export_range(0,180,1,"suffix:°") var rotation_speed_deg : int = 5
@export_category("grid")
@export var grid_rotation_delta : float = .3
@export_category("fight")
@export var fight_rotation_delta : float = .05
@export_category("shooting")
@export_range(0,135,1,"suffix:°") var attack_angle_deg : int = 45
@export var max_proj :int = 1
#state control
var one_shot = true
var shot_valid = false
var evade : Vector2

#cordinates
var player_pos : Vector2 = Vector2(270,720)
var grid_pos : Vector2 = Vector2(10,10)
var flight_pos: Vector2 = Vector2.ZERO
#deg_to_rad convertions
var rotation_speed_rad = deg_to_rad(rotation_speed_deg)
var attack_angel_rad = deg_to_rad(180 - attack_angle_deg)
const rotation_fix = deg_to_rad(90)

func _ready() -> void:
	position = Vector2(280,0)
	var one_shot = true
	
	
func _process(delta: float) -> void:
	if rotation > attack_angel_rad or rotation < -attack_angel_rad:
		shot_valid = true
	else:
		shot_valid = false
		
	if state_machine != mode.FLIGHT:
		one_shot = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		null
		grid_pos = get_global_mouse_position()
	if event.is_action_pressed("ui_left"):
		null
		flight_pos = get_global_mouse_position()
	if event.is_action_pressed("ui_down"):
		null
		player_pos = get_global_mouse_position()	
	if event.is_action_pressed("ui_accept"):
		match state_machine:
			mode.FLIGHT:
				null
				state_machine = mode.FIGHT
			mode.FIGHT:
				null
				state_machine = mode.GRID
			mode.GRID:
				null
				state_machine = mode.LAST_STAND
			mode.LAST_STAND:
				null
				state_machine = mode.FLIGHT

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var player_angle = get_angle_to(player_pos) + rotation_fix + rotation
	var move = true
	
	match state_machine:
		mode.FLIGHT:
			var 	flight_direction = get_angle_to(flight_pos) + rotation + rotation_fix
			move = false
			position = position.move_toward(flight_pos, movement_delta)
			if position != flight_pos:
				rotation = rotate_toward(rotation, flight_direction, rotation_delta)
				
		mode.FIGHT:
			if evade:
				pass
				
		mode.GRID:
			var grid_angle = rotate_toward(rotation, get_angle_to(grid_pos) + rotation_fix + rotation, grid_rotation_delta)
			if position.distance_squared_to(grid_pos) > movement_deadzone:
				rotation = grid_angle
			else:
				rotation = rotate_toward(rotation, Vector2.RIGHT.angle(), rotation_delta)
				move = false
		mode.LAST_STAND:
			if evade:
				rotation = rotate_toward(rotation, evade.angle(), fight_rotation_delta)
				if position.x <= 0:
					evade = Vector2.DOWN
				if position.x >= 540:
					evade = Vector2.UP
			else:
				rotation = rotate_toward(rotation, player_angle, fight_rotation_delta)
				print(rotation_degrees)
			if position.y >= 720:
				position.y = -64
			
	position.clamp(Vector2.ZERO, get_viewport_rect().size)
		
	if move:
		state.linear_velocity = Vector2.from_angle(rotation - rotation_fix) * speed
	else:
		state.linear_velocity = Vector2.ZERO
		
		
		

		
		
func spawn_missile():
	null
	max_proj -= 1
	var init = missile_entity.instantiate()
	call_deferred("add_child",init)
	init.set_enemy_projectile()
	init.proj_rotation = get_angle_to(player_pos) + rotation
	init.rotation = get_angle_to(player_pos) + rotation_fix
	init.eproj_left_screen.connect(_on_eproj_left_screen)
	
func _on_eproj_left_screen():
	max_proj += 1
	


func _on_timer_timeout() -> void:
	if not evade:
		if randi_range(0,1) == 1:
			evade = Vector2.from_angle(deg_to_rad(135))
		else:
			evade = Vector2.from_angle(deg_to_rad(-135))
	else:
		evade = Vector2.ZERO
	if max_proj > 0:
		if shot_valid:
			if state_machine == mode.FIGHT or state_machine == mode.LAST_STAND:
				spawn_missile()
			elif state_machine == mode.FLIGHT and one_shot:
				spawn_missile()
				one_shot = false
