extends StaticBody2D

@export var enemy_scene: PackedScene

func _on_spawn_timer_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = $CastPoint.global_position
	get_tree().current_scene.add_child(enemy)
	$SpawnSound.play()
	
func _process(_delta: float) -> void:
	if $SpawnTimer.time_left < 1.0:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
