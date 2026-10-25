extends Camera2D


@export var level_horizon_y: float = 324.0 

func _ready():
	top_level = true
	global_position.y = level_horizon_y
	
	process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS

func _physics_process(_delta):
	if get_parent():
		global_position.x = get_parent().global_position.x + 550
