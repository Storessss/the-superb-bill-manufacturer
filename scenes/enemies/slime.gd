extends Enemy

func _physics_process(delta):
	super._physics_process(delta)
					
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if $JumpTimer.is_stopped():
		$JumpTimer.start()
		var player = get_tree().get_first_node_in_group("players")
		if player:
			if player.global_position.x < global_position.x:
				velocity.x = -120
				$AnimatedSprite2D.flip_h = true
			else:
				velocity.x = 120
				$AnimatedSprite2D.flip_h = false
		velocity.y = -300
		$JumpSound.play()
		
	velocity.x = move_toward(velocity.x, 0, 1)
	if is_on_floor() and velocity.y == 0:
		velocity.x = 0
	
	move_and_slide()
