extends Enemy

var bullet_scene: PackedScene = preload("res://scenes/enemies/bullet.tscn")
var speed: int = 25

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var target_player = get_tree().get_first_node_in_group("players")
	if target_player:
		var direction = target_player.global_position - global_position
		if $ShootTimer.time_left < 1.0:
			velocity = Vector2.ZERO
		else:
			velocity = direction.normalized() * speed
		move_and_slide()

func _on_shoot_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	var target_player = get_tree().get_first_node_in_group("players")
	if target_player:
		bullet.angle = (target_player.global_position - global_position).angle()
		get_tree().current_scene.add_child(bullet)
		$ShootSound.play()
		
func _process(_delta: float) -> void:
	if $ShootTimer.time_left < 1.0:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
