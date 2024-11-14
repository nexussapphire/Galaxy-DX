extends RigidBody2D

@export var projectile_speed: int = 600
var proj_rotation
var is_enemy = true

signal eproj_left_screen
signal pproj_left_screen


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = Vector2.from_angle(proj_rotation) * projectile_speed
	
	
func set_enemy_projectile(enemy: bool = true):
	is_enemy = enemy
	set_collision_layer_value(3, not enemy)
	set_collision_layer_value(4, enemy)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_enemy:
		eproj_left_screen.emit()
	else:
		pproj_left_screen.emit()
	queue_free()
		
