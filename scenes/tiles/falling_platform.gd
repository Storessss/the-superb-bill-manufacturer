extends CharacterBody2D

var activated: bool
var speed: int = 90

func _process(_delta: float) -> void:
	if Input.is_action_pressed("down"):
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
		
	if $FallTimer.is_stopped() and activated:
		velocity.y = speed
		
	move_and_slide()
		
func activate():
	if not activated:
		activated = true
		$FallTimer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
