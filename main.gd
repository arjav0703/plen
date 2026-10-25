extends Node2D

const BIRD_SCENE: PackedScene = preload("res://bird.tscn")

@onready var player: Node2D = $"Plen Body 2D"
@onready var game_over_ui: CanvasLayer = $GameOverUI
@onready var restart_button: Button = $GameOverUI/DimBackground/CenterContainer/PanelContainer/VBoxContainer/RestartButton

@export var spawn_distance: float = 500.0
@export var spawn_y_range: float = 110.0
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 2.0

var spawn_timer: Timer
var game_over := false


func _ready() -> void:
	randomize()

	game_over_ui.hide()
	game_over_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	restart_button.pressed.connect(_restart_game)

	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)

	spawn_timer.timeout.connect(_spawn_bird)
	spawn_timer.start(1.0)


func _spawn_bird() -> void:
	if game_over:
		return

	var bird := BIRD_SCENE.instantiate() as Area2D
	add_child(bird)

	# Spawn ahead of the player, at a slightly varied height.
	bird.global_position = Vector2(
		player.global_position.x + spawn_distance,
		player.global_position.y + randf_range(
			-spawn_y_range,
			spawn_y_range
		)
	)

	# Detect when this bird hits the player.
	bird.body_entered.connect(_on_bird_body_entered)

	# Schedule the next bird.
	spawn_timer.start(
		randf_range(min_spawn_interval, max_spawn_interval)
	)


func _on_bird_body_entered(body: Node2D) -> void:
	if body == player and not game_over:
		_end_game()


func _end_game() -> void:
	game_over = true
	spawn_timer.stop()
	game_over_ui.show()
	get_tree().paused = true


func _restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
