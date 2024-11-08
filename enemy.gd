extends RigidBody2D

var player_pos : Vector2 = Vector2(270,720)
@export var rotation_speed : int = 4
@export var angle_from_180d : int = 45 # the angle offset from 180 degrees
@export var projectile : PackedScene
@export var aval_shots : int = 1
var combat = false
var destroyed
var single_shot = true






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rotation_degrees <  -(180 - angle_from_180d) or rotation_degrees > 180 - angle_from_180d:
		if aval_shots > 0:
			if combat:
				create_bullet()
				aval_shots -= 1
			elif single_shot:
				print("shot")
				create_bullet()
				single_shot = false
				aval_shots -= 1
			
			
	else:
		single_shot = true
	
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse = get_angle_to(get_global_mouse_position()) + deg_to_rad(90)
		if mouse < deg_to_rad(rotation_speed) and mouse > -deg_to_rad(rotation_speed):
			rotate(mouse)
		elif mouse < 0:
			rotate(deg_to_rad(-rotation_speed))
		else:
			rotate(deg_to_rad(rotation_speed))
		linear_velocity = Vector2.from_angle(rotation - deg_to_rad(90)) * 300
	else:
		linear_velocity = Vector2.ZERO
		
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
	
	
func set_player_position(player):
	player_pos = player
	
func set_combat_state():
	combat = true

func create_bullet():
	var shot = projectile.instantiate()
	add_child(shot)
	shot.set_enemy_projectile(true)
	shot.rotation= shot.get_angle_to(player_pos) + deg_to_rad(90)
	shot.eproj_left_screen.connect(_on_eproject_left_screen)
	
	
func _on_eproject_left_screen():
	aval_shots += 1
	
	
