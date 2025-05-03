extends StaticBody2D

var bullet_scene: PackedScene = preload("res://scenes/enemies/bullet.tscn")

func _on_shoot_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $CastPoint.global_position
	bullet.angle = ($CastPoint.global_position - global_position).angle()
	get_tree().current_scene.add_child(bullet)
	$ShootSound.play()
