extends CanvasLayer

func _process(delta: float) -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$Left.visible = true
		$Right.visible = true
		$Jump.visible = true
		$Down.visible = true
	else:
		$Left.visible = false
		$Right.visible = false
		$Jump.visible = false
		$Down.visible = false
