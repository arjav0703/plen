extends Node2D

const BIRD_SCENE: PackedScene = preload("res://bird.tscn")

@onready var player: Node2D = $"Plen Body 2D"
@onready var game_over_ui: CanvasLayer = $GameOverUI
@onready var restart_button: Button = $GameOverUI/DimBackground/CenterContainer/PanelContainer/VBoxContainer/Sprite2D/RestartButton
@onready var lil_guy_animation = $"Lil Guy/AnimatedSprite2D"
@onready var lil_guy = $"Lil Guy"
@export var spawn_distance: float = 500.0
@export var spawn_y_range: float = 110.0
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 2.0

@onready var welcome_ui: CanvasLayer = $WelcomeUI

var game_started := false
var intro_playing := false
var spawn_timer: Timer
var game_over := false


func _ready() -> void:
	randomize()

	welcome_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	game_over_ui.process_mode = Node.PROCESS_MODE_ALWAYS

	welcome_ui.show()
	game_over_ui.hide()

	welcome_ui.start_requested.connect(_start_game)

	restart_button.pressed.connect(_restart_game)

	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_spawn_bird)
	
	# Let the animation play while the game is paused.
	lil_guy.process_mode = Node.PROCESS_MODE_ALWAYS

	# Make sure the intro plays only once.
	lil_guy_animation.sprite_frames.set_animation_loop("intro", false)
	lil_guy_animation.animation_finished.connect(_on_lil_guy_animation_finished)


	get_tree().paused = true

func _on_lil_guy_animation_finished() -> void:
	if not intro_playing:
		return

	if lil_guy_animation.animation != "intro":
		return

	intro_playing = false
	game_started = true

	get_tree().paused = false
	spawn_timer.start(1.0)

func _start_game() -> void:
	if game_started or game_over or intro_playing:
		return

	intro_playing = true
	welcome_ui.hide()

	lil_guy_animation.play("intro")

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

func _process(_delta: float) -> void:
	if not game_started or game_over:
		return

	var screen_pos: Vector2 = player.get_global_transform_with_canvas().origin

	var viewport_height: float = get_viewport().get_visible_rect().size.y

	if screen_pos.y > viewport_height - 20.0:
		_end_game()


func _end_game() -> void:
	game_over = true
	spawn_timer.stop()
	game_over_ui.show()
	get_tree().paused = true


func _restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
