extends Node2D

@export var portal_color: String
var portals: Array
var next_index: int
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportSound

var teleport_particles_scene: PackedScene = preload("res://scenes/particles/teleport_particles.tscn")
@export var teleport_particles_color: Color

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") or body.is_in_group("enemies"):
		if $CooldownTimer.is_stopped():
			portals = get_tree().get_nodes_in_group(portal_color + "_portals")
			var self_index: int = portals.find(self)
			next_index = (self_index + 1) % portals.size()
			body.global_position = portals[next_index].global_position
			portals[next_index].cooldown_timer.start()
			
			var particles = teleport_particles_scene.instantiate()
			particles.global_position = portals[next_index].global_position
			particles.color = teleport_particles_color
			get_tree().current_scene.add_child(particles)
			portals[next_index].teleport_sound.play()
