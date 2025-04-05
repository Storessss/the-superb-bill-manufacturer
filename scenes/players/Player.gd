extends CharacterBody2D

class_name Player

@export var speed: int = 200
@export var jump_velocity: int = -400

var death_particles_scene = preload("res://scenes/particles/death_particles.tscn")

func _physics_process(delta):
	if $ResetTimer.is_stopped():
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
			
		if Input.is_action_just_pressed("rotate"):
			die()
		
func die():
	var particles = death_particles_scene.instantiate()
	particles.global_position = global_position
	get_tree().current_scene.add_child(particles)
	$AnimatedSprite2D.queue_free()
	$ResetTimer.start()
	$DeathSound.play()

func _ready() -> void:
	$ResetTimer.connect("timeout", Callable(self, "_on_reset_timer_timeout"))
	
func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()
