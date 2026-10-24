extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("ui_accept"):
		_animated_sprite.play("default")

	
