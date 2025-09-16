extends CanvasLayer

func _process(delta: float) -> void:
	if OS.get_name() == "Android":
		$Left.visible = true
		$Right.visible = true
		$Jump.visible = true
		$Down.visible = true
	else:
		$Left.visible = false
		$Right.visible = false
		$Jump.visible = false
		$Down.visible = false
