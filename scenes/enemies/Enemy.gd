extends CharacterBody2D

class_name Enemy

var can_die: bool = true
var death_particles_scene = preload("res://scenes/particles/death_particles.tscn")
@export var death_particles_color: Color

func _physics_process(_delta: float) -> void:
	for i in range (get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		var body = collision.get_collider()
		if body and body.is_in_group("players"):
			if normal == Vector2.LEFT or normal == Vector2.RIGHT or normal == Vector2.UP:
				body.die()
	
func die():
	if can_die:
		can_die = false
		var particles = death_particles_scene.instantiate()
		particles.color = death_particles_color
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
		GlobalVariables.death_sound()
		queue_free()
