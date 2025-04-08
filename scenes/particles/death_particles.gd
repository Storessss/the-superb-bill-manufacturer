extends Node2D

var color: Color

func _ready():
	$CPUParticles2D.emitting = true
	if color:
		$CPUParticles2D.color = color
