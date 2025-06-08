extends Node2D

var counter: int
var color: Color

func _ready() -> void:
	$CPUParticles2D.emitting = true
	if color:
		$CPUParticles2D.color = color
		$CPUParticles2D2.color = color
		$CPUParticles2D3.color = color

func _on_timer_timeout() -> void:
	if counter == 0:
		$CPUParticles2D2.emitting = true
	elif counter == 1:
		$CPUParticles2D3.emitting = true
	counter += 1
