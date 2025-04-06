extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	for i in range (get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		if collider:
			if normal == Vector2.DOWN:
				if collider.is_in_group("players"):
					collider.jump()
					queue_free()
			elif normal == Vector2.LEFT or normal == Vector2.RIGHT:
				if collider.is_in_group("players"):
					collider.die()
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
