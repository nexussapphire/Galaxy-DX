extends RigidBody2D

@export var projectile_speed: int = 600
var flip = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = Vector2.from_angle(global_rotation + deg_to_rad(270)) * projectile_speed
	
	
func set_enemy_projectile(enemy: bool = true):
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)
