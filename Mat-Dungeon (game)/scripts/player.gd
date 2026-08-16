extends CharacterBody2D
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = 0

	if Input.is_action_pressed("move_left"):
		direction -= 1

	if Input.is_action_pressed("move_right"):
		direction += 1

	velocity.x = direction * SPEED

	if is_on_floor():
		if direction > 0:
			animated.flip_h = false
			animated.play("walk")
		elif direction < 0:
			animated.flip_h = true
			animated.play("walk")
		else:
			animated.play("idle")
	else:
		animated.play("jump")

	move_and_slide()
