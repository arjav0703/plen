extends CharacterBody2D


const SPEED = 100.0
@onready var _animated_sprite = $AnimatedSprite2D




func _physics_process(delta: float) -> void:

	_animated_sprite.play("default")
	velocity.x = -SPEED



	move_and_slide()
