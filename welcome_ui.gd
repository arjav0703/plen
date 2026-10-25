extends CanvasLayer

signal start_requested


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if (
				event.keycode == KEY_ENTER
				or event.keycode == KEY_KP_ENTER
			):
				start_requested.emit()
