extends Enemy

var bullet_scene: PackedScene = preload("res://scenes/enemies/bullet.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()

func _on_shoot_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	if get_tree().get_nodes_in_group("players")[0]:
		var target_player = get_tree().get_nodes_in_group("players")[0]
		bullet.angle = (target_player.global_position - global_position).angle()
		get_tree().current_scene.add_child(bullet)
		$ShootSound.play()
		
func _process(_delta: float) -> void:
	if $ShootTimer.time_left < 1:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
