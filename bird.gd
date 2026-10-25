extends Area2D


@onready var _animated_sprite = $AnimatedSprite2D
const SPEED = 300.0



func _ready() -> void:
	_animated_sprite.play("default")


@export var speed: float = 240.0


func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta


	var camera := get_viewport().get_camera_2d()

	#if camera:
		#var left_edge := (
			#camera.global_position.x
			#- get_viewport_rect().size.x / 2.0
			#- 100.0
		#)
#
		#if global_position.x < left_edge:
			#queue_free()
