extends StaticBody2D

func _process(_delta: float) -> void:
	if Input.is_action_pressed("down"):
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
