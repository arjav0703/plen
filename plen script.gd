extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	var plen_rotation = 3.14/8
	if Input.is_action_pressed("ui_up"):
		_animated_sprite.rotation = -plen_rotation	
	elif Input.is_action_pressed("ui_down"):
		_animated_sprite.rotation = plen_rotation
	else:
		_animated_sprite.rotation_degrees = 0

	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("default")
	else:
		_animated_sprite.stop()
	

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	var lift := Input.get_axis("ui_up", "ui_down")
	if lift:
		velocity.y = lift * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
