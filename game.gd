extends Node2D
@export var enemy_intety : PackedScene
@export_category("Grid animation properties")
@export var grid_shrink : Vector2 = Vector2(.9, .9)
@export var grid_grow : Vector2 = Vector2(1.15, 1.15)
@export var shrink_rate : float = .5

var points : Array
var shrinking = true
const grid_width = 540


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lines in $Grid.get_children():
		points.append_array(lines.get_children())
			
	make_enemy()
	
func _process(delta: float) -> void:
	set_enemy_coordinates()
	grid_animation(delta)
	# enemy states etc
	
	
	
func make_enemy():
	for point in points.size():
		var init = enemy_intety.instantiate()
		$Enemies.add_child(init)
	set_enemy_coordinates()
	# set enemy state -- for testing
	
func set_enemy_coordinates():
	pass # Update enemy state and grid position

func grid_animation(delta:float):
	if $Grid.scale >= grid_grow and not shrinking:
		shrinking = true
	elif $Grid.scale <= grid_shrink and shrinking:
		shrinking = false
	if shrinking:
		$Grid.scale = $Grid.scale.move_toward(grid_shrink, shrink_rate * delta)
	else:
		$Grid.scale = $Grid.scale.move_toward(grid_grow, shrink_rate * delta)
	$Grid.position.x = (grid_width * (1 - $Grid.scale.x)/2)
		

	
		
