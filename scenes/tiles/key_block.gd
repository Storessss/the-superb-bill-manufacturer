extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		GlobalVariables.keys += 1
		GlobalVariables.key_get_sound()
		queue_free()
