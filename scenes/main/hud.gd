extends CanvasLayer

func _ready() -> void:
	GlobalVariables.level_win.connect(Callable(self, "_on_level_win"))
	
func _on_level_win():
	$WinTimer.start()
	
func _process(_delta: float) -> void:
	$LevelName.text = GlobalVariables.level_name
	$LevelCode.text = GlobalVariables.level_code
	
	if not $WinTimer.is_stopped():
		$LevelWin.visible = true
		$YouDidIt.visible = true
		GlobalVariables.music_player.stop()
	else:
		$LevelWin.visible = false
		$YouDidIt.visible = false
		if not GlobalVariables.music_player.playing:
			GlobalVariables.music_player.play()
			
	for key in $Keys.get_children():
		key.queue_free()
	for i in range(GlobalVariables.keys):
		var key = Sprite2D.new()
		key.texture = preload("res://sprites/key.png")
		key.position.x = (16 * (i + 1)) / 2
		$Keys.add_child(key)
