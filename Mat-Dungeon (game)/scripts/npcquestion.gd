extends CharacterBody2D

@export var panel_question: CanvasLayer

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export_multiline var pergunta := "Qual é a derivada de "
@export var alternativa_a := "x³ / 3"
@export var alternativa_b := "x²"
@export var alternativa_c := "2x"
@export var alternativa_d := "x² / 2"

@export_enum("A","B","C","D")
var resposta_correta := "C"

var respondida: bool = false
var bloqueado: bool = false

func _ready():
	if panel_question == null:
		push_error("PanelQuestion não foi atribuído ao NPC!")
		return
	panel_question.visible = false
	
	if animated_sprite:
		animated_sprite.play("idle")

func _on_area_2d_body_entered(body):
	if respondida or bloqueado:
		return

	if body.is_in_group("player"):
		body.pode_andar = false
		panel_question.npc_atual = self

		# Mantém a animação em idle ao abrir a pergunta
		if animated_sprite:
			animated_sprite.play("idle")

		panel_question.show_question(
			pergunta,
			alternativa_a,
			alternativa_b,
			alternativa_c,
			alternativa_d,
			resposta_correta
		)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		if not respondida and panel_question:
			panel_question.visible = false

func liberar_passagem():
	respondida = true
	bloqueado = false
	
	# Toca a animação 'talking' assim que o jogador acerta!
	if animated_sprite:
		animated_sprite.play("talking")

	if collision:
		collision.set_deferred("disabled", true)
	if panel_question:
		panel_question.visible = false

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.pode_andar = true

func bloquear_npc():
	bloqueado = true

func reset_npc():
	respondida = false
	bloqueado = false
	
	# Reseta a animação de volta para 'idle' quando o player morre/respawna
	if animated_sprite:
		animated_sprite.play("idle")
	
	if collision:
		collision.set_deferred("disabled", false)
