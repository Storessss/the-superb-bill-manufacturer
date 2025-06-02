extends Node2D

func _ready() -> void:
	GlobalVariables.level_win.connect(Callable(self, "_on_level_win"))

func _on_level_win():
	$FromLeft.emitting = true
	$FromRight.emitting = true
