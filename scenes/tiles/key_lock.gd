extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and GlobalVariables.keys > 0:
		GlobalVariables.keys -= 1
		$AnimatedSprite2D.play("opening")
		GlobalVariables.lock_unlock_sound()
		
func _process(_delta: float) -> void:
	if $AnimatedSprite2D.frame == 8:
		queue_free()
