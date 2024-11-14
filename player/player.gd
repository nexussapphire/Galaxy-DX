extends CharacterBody2D

@export var speed : int = 200
@export var padding : int = 30
@export var y_position : int = 50
@export var aval_shot : int = 3
@export var projectile : PackedScene
const window_size = Vector2(540,720)


func _ready() -> void:
	position = Vector2(window_size.x / 2, window_size.y - y_position)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if aval_shot > 0:
			create_bullet()
			aval_shot -= 1


func _physics_process(_delta: float) -> void:
	var movement = Input.get_axis("move_left","move_right")
	var vpad = Vector2(padding,0)
	if movement:
		velocity.x = movement * speed
	elif velocity:
		velocity = Vector2.ZERO
		
	position = position.clamp(vpad, window_size - vpad)
	move_and_slide()

	
func create_bullet():
	var shot = projectile.instantiate()
	add_child(shot)
	shot.set_enemy_projectile(false)
	shot.pproj_left_screen.connect(_on_pproj_left_screen)
	print(shot.linear_velocity)
	

func _on_pproj_left_screen():
	aval_shot += 1
	print("Bye")
