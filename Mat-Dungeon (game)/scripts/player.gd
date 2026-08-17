extends CharacterBody2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_walk: AnimatedSprite2D = $AnimatedSprite2DWalk

const SPEED = 230.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1000.0
const VOID_Y = 750.0

var last_flip = false
var dead = false
var respawning = false
var start_position: Vector2
var fade: ColorRect


func _ready():
	start_position = global_position

	fade = get_tree().current_scene.get_node_or_null("CanvasLayer/Fade")

	if fade == null:
		print("ERRO: CanvasLayer/Fade não foi encontrado!")
	else:
		fade.modulate.a = 0.0
		fade.visible = false


func death():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	animated.visible = true
	animated_walk.visible = false
	animated.play("dead")
	await animated.animation_finished
	animated.frame = animated.sprite_frames.get_frame_count("dead") - 1
	animated.pause()
	respawn()

@warning_ignore("unused_parameter")

func _on_hitbox_area_entered(area):
	death()

func respawn():
	if respawning:
		return

	respawning = true
	velocity = Vector2.ZERO

	if fade == null:
		global_position = start_position
		velocity = Vector2.ZERO
		respawning = false
		dead = false
		return

	fade.visible = true
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.0)
	tween.tween_callback(func():
		global_position = start_position
		velocity = Vector2.ZERO
		animated.play("idle")
)
	
	tween.tween_interval(0.3)
	tween.tween_property(fade, "modulate:a", 0.0, 1.0)
	tween.tween_callback(func():
		fade.visible = false
		respawning = false
		dead = false
		animated.visible = true
		animated_walk.visible = false
		animated.play("idle")
	)

func _physics_process(delta):

	if dead:
		return

	if global_position.y > VOID_Y and not respawning:
		respawn()
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
