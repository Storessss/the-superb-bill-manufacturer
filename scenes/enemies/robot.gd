extends Enemy

var speed: int = 45
var wait: bool = true

func _ready() -> void:
	if is_equal_approx(rotation, PI):
		$AnimatedSprite2D.flip_v = not $AnimatedSprite2D.flip_v
		speed = -speed
		$DownRayCast.target_position.y *= -1

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if $AnimatedSprite2D.flip_h:
		velocity.x = -speed
	else:
		velocity.x = speed
	velocity.y = 200
	
	if wait:
		await get_tree().process_frame
		wait = false
	if not $DownRayCast.is_colliding() or $ForwardRayCast.is_colliding():
		$DownRayCast.target_position.x *= -1
		$ForwardRayCast.target_position.x *= -1
		if $TurnAroundTimer.is_stopped():
			$TurnAroundTimer.start()
			
	if not $TurnAroundTimer.is_stopped() or not $TurnedAroundTimer.is_stopped():
		velocity.x = 0
			
	move_and_slide()
			
func _on_turn_around_timer_timeout() -> void:
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	$TurnAroundSound.play()
	$TurnedAroundTimer.start()
