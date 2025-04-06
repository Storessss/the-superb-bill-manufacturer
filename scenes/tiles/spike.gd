extends Node2D


func _on_area_2d_body_entered(body):
	if body is not TileMapLayer and body.is_in_group("players"):
		body.die()
