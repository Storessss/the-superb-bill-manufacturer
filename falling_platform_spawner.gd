extends Node2D

var falling_platform_scene = preload("res://scenes/tiles/falling_platform.tscn")

func _process(delta: float) -> void:
	if not $Platform.get_child(0) and $SpawnTimer.is_stopped():
		$SpawnTimer.start()

func spawn_platform():
	var falling_platform = falling_platform_scene.instantiate()
	$Platform.add_child(falling_platform)

func _on_spawn_timer_timeout() -> void:
	spawn_platform()
