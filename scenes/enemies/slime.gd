extends CharacterBody2D

var can_die: bool = true
var death_particles_scene = preload("res://scenes/particles/death_particles.tscn")

func _physics_process(delta):
	for i in range (get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		var body = collision.get_collider()
		if body and body.is_in_group("players"):
			if normal == Vector2.LEFT or normal == Vector2.RIGHT or normal == Vector2.UP:
				body.die()
					
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
		
	velocity.x = move_toward(velocity.x, 0, 1)
	if is_on_floor() and velocity.y == 0:
		velocity.x = 0
	
	move_and_slide()
	
func die():
	if can_die:
		can_die = false
		var particles = death_particles_scene.instantiate()
		particles.color = Color.GREEN
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
		queue_free()
