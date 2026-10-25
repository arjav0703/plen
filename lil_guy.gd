extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D



func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("ui_accept"):
		_animated_sprite.play("default")
	# Handle jump.


	move_and_slide()
