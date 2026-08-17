extends CharacterBody2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_walk: AnimatedSprite2D = $AnimatedSprite2DWalk

const SPEED = 230.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1000.0

var last_flip = false
var dead = false


func death():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO

	animated.visible = true
	animated_walk.visible = false

	animated.play("dead")


func _physics_process(delta):

	if dead:
		return

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
			animated.visible = false
			animated_walk.visible = true

			animated_walk.flip_h = false
			last_flip = false

			animated_walk.play("walk")

		elif direction < 0:
			animated.visible = false
			animated_walk.visible = true

			animated_walk.flip_h = true
			last_flip = true

			animated_walk.play("walk")

		else:
			animated.visible = true
			animated_walk.visible = false

			animated.flip_h = last_flip
			animated.play("idle")

	else:

		animated.visible = true
		animated_walk.visible = false

		if direction > 0:
			animated.flip_h = false
			last_flip = false

		elif direction < 0:
			animated.flip_h = true
			last_flip = true

		else:
			animated.flip_h = last_flip

		animated.play("jump")

	move_and_slide()
