extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and GlobalVariables.keys > 0:
		GlobalVariables.keys -= 1
		queue_free()
