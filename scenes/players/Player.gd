extends CharacterBody2D

class_name Player

@export var speed: int = 200

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
func jump():
	velocity.y = jump_velocity
	$JumpSound.play()

var can_jump: bool
var jump_buffer: bool

var can_die: bool = true
var death_particles_scene = preload("res://scenes/particles/death_particles.tscn")

func _physics_process(delta):
	if $ResetTimer.is_stopped():
		
		if not is_on_floor():
			velocity.y += _get_gravity() * delta
			$AnimatedSprite2D.play("jump")
		else:
			if jump_buffer:
				jump()
				
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() or not $CoyoteTimer.is_stopped():
				jump()
			else:
				jump_buffer = true
				$JumpBuffer.start()
				
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0

		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			if is_on_floor():
				$AnimatedSprite2D.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor():
				$AnimatedSprite2D.play("idle")
				
		var was_on_floor = is_on_floor()
		move_and_slide()
		if was_on_floor and not is_on_floor():
			$CoyoteTimer.start()
		
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
			
		if Input.is_action_just_pressed("restart"):
			die()
			
		for i in range (get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var normal = collision.get_normal()
			var body = collision.get_collider()
			if normal == Vector2.UP:
				if body and body.is_in_group("enemies"):
					jump()
					body.die()
				elif body.is_in_group("falling_platforms"):
					body.activate()
		
func die():
	if can_die:
		can_die = false
		var particles = death_particles_scene.instantiate()
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
		$AnimatedSprite2D.queue_free()
		$ResetTimer.start()
		GlobalVariables.death_sound()

func _ready() -> void:
	$ResetTimer.connect("timeout", Callable(self, "_on_reset_timer_timeout"))
	$JumpBuffer.connect("timeout", Callable(self, "_on_jump_buffer_timeout"))
	
func _on_reset_timer_timeout() -> void:
	queue_free()
func _on_jump_buffer_timeout():
	jump_buffer = false
