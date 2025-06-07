extends Node2D

var direction: Vector2
var angle: float
var speed: int = 150

func _process(delta: float) -> void:
	direction = Vector2(cos(angle), sin(angle))
	position += direction * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.die()
	elif body is TileMapLayer:
		GlobalVariables.bullet_hit_wall_sound()
		queue_free()
