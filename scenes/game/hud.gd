extends CanvasLayer

func _process(delta: float) -> void:
	$LevelName.text = GlobalVariables.level_name
	$LevelCode.text = GlobalVariables.level_code
