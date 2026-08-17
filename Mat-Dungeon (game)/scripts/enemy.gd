extends CharacterBody2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D


func _ready():
	animated.flip_h = true
	animated.play("idle")

	area.body_entered.connect(_on_area_body_entered)


func _on_area_body_entered(body):

	if body.is_in_group("player"):
		body.death()
