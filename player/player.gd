extends CharacterBody2D

@export var speed : int = 200
@export var delta_accel : float = 15
@export var delta_decay : float = 5
@export_range(0,1,.01,"suffix:%") var border_percent : float = .3
@export var padding : int = 30
#Global var initialized after start
@onready var window_size = get_viewport_rect().size - Vector2(padding, padding)
@onready var border_min = Vector2(0, window_size.y - (window_size.y * border_percent)) + Vector2(padding,0)





func _physics_process(_delta: float) -> void:
	var movement = Input.get_vector("move_left","move_right","move_up","move_down")
	if movement:
		velocity = velocity.move_toward(movement * speed, delta_accel)
	elif velocity:
		velocity = velocity.move_toward(Vector2.ZERO, delta_decay)
		
	position = position.clamp(border_min,window_size)
	
	
	
	
	move_and_slide()
