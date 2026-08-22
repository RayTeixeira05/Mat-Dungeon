extends CanvasLayer

@onready var question_label: Label = $Panel/Label
@onready var timer_label: Label = $Panel/TimerLabel

@onready var answer_a_label: Label = $Panel/ButtonA/LabelA
@onready var answer_b_label: Label = $Panel/ButtonB/LabelB
@onready var answer_c_label: Label = $Panel/ButtonC/LabelC
@onready var answer_d_label: Label = $Panel/ButtonD/LabelD

var correct_answer: String = ""
var npc_atual = null

var tempo: float = 20.0
var contando := false

func _ready():
	visible = false

func _process(delta):
	if !contando:
		return

	tempo -= delta
	timer_label.text = str(ceili(tempo))

	if tempo <= 0:
		contando = false
		visible = false

		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.pode_andar = true
			player.respawn()

func show_question(
	question: String,
	answer_a: String,
	answer_b: String,
	answer_c: String,
	answer_d: String,
	correct: String
):
	question_label.text = question

	answer_a_label.text = answer_a
	answer_b_label.text = answer_b
	answer_c_label.text = answer_c
	answer_d_label.text = answer_d

	correct_answer = correct

	tempo = 20.0
	contando = true
	timer_label.text = "10"

	visible = true

func _on_button_a_pressed():
	check_answer("A")

func _on_button_b_pressed():
	check_answer("B")

func _on_button_c_pressed():
	check_answer("C")

func _on_button_d_pressed():
	check_answer("D")

func check_answer(answer: String):
	if answer == correct_answer:
		contando = false

		if npc_atual:
			npc_atual.liberar_passagem()
	else:
		print("Resposta errada!")
