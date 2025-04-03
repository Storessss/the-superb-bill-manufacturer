extends CharacterBody2D

class_name Player

@export var speed: int = 200
@export var jump_velocity: int = -400


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")

	move_and_slide()
	
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0
