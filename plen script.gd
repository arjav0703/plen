extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D


const SPEED = 300

func _ready() -> void:
	velocity.x = SPEED


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
	
		
		
	var lift := Input.get_axis("ui_up", "ui_down")
	if lift:
		velocity.y = lift * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
			
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 7
	elif Input.is_action_pressed("ui_left"):
		velocity.x += -10
	else:
		velocity.x += -1.5
	
	if velocity.x < 100:
		velocity.y += 250
		
		if velocity.x < 1:
			velocity.x = 0

	move_and_slide()
