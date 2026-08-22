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
	
	# Configura o efeito hover apenas para a imagem do botão (self_modulate)
	var botoes = [$Panel/ButtonA, $Panel/ButtonB, $Panel/ButtonC, $Panel/ButtonD]
	
	for btn in botoes:
		btn.self_modulate.a = 0.0
		btn.mouse_entered.connect(func(): btn.self_modulate.a = 1.0)
		btn.mouse_exited.connect(func(): btn.self_modulate.a = 0.0)

func _process(delta):
	if !contando:
		return

	tempo -= delta
	timer_label.text = str(ceili(tempo))

	if tempo <= 0:
		errou_resposta()

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
	timer_label.text = "20"

	# Garante que os botões estão ativos e sem foco residual
	$Panel/ButtonA.disabled = false
	$Panel/ButtonB.disabled = false
	$Panel/ButtonC.disabled = false
	$Panel/ButtonD.disabled = false

	$Panel/ButtonA.release_focus()
	$Panel/ButtonB.release_focus()
	$Panel/ButtonC.release_focus()
	$Panel/ButtonD.release_focus()

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
		acertou_resposta()
	else:
		errou_resposta()

func acertou_resposta():
	contando = false
	
	var panel_node = $Panel
	
	#Desativa os botões
	$Panel/ButtonA.disabled = true
	$Panel/ButtonB.disabled = true
	$Panel/ButtonC.disabled = true
	$Panel/ButtonD.disabled = true
	
	var tween = create_tween().set_parallel(true)
	
	#Pisca o painel em verde
	tween.tween_property(panel_node, "modulate", Color(0.3, 1.0, 0.3), 0.15)
	
	#Efeito que aumenta e volta para o tomanho normal
	var scale_tween = create_tween()
	scale_tween.tween_property(panel_node, "scale", Vector2(1.08, 1.08), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(panel_node, "scale", Vector2(1.0, 1.0), 0.15)

	#Espera o efeito terminar
	await get_tree().create_timer(1.2).timeout
	
	#Reseta o painel
	panel_node.modulate = Color(1, 1, 1)
	panel_node.scale = Vector2(1, 1)
	$Panel/ButtonA.disabled = false
	$Panel/ButtonB.disabled = false
	$Panel/ButtonC.disabled = false
	$Panel/ButtonD.disabled = false
	
	visible = false

	# Libera a passagem no NPC
	if npc_atual:
		npc_atual.liberar_passagem()

func errou_resposta():
	contando = false
	
	# Bloqueia o NPC para não aceitar novos toques durante a animação/respawn
	if npc_atual:
		npc_atual.bloquear_npc()
	
	var panel_node = $Panel
	
	# Desativa os botões para evitar múltiplos cliques
	$Panel/ButtonA.disabled = true
	$Panel/ButtonB.disabled = true
	$Panel/ButtonC.disabled = true
	$Panel/ButtonD.disabled = true
	
	# Animação de erro em vermelho + tremer
	var tween = create_tween().set_parallel(true)
	tween.tween_property(panel_node, "modulate", Color(1, 0.3, 0.3), 0.1)
	
	var pos_original = panel_node.position
	var shake_tween = create_tween()
	for i in range(5):
		shake_tween.tween_property(panel_node, "position:x", pos_original.x + 10, 0.04)
		shake_tween.tween_property(panel_node, "position:x", pos_original.x - 10, 0.04)
	shake_tween.tween_property(panel_node, "position:x", pos_original.x, 0.04)

	await get_tree().create_timer(1.2).timeout
	
	# Reseta as propriedades visuais do painel
	panel_node.modulate = Color(1, 1, 1)
	$Panel/ButtonA.disabled = false
	$Panel/ButtonB.disabled = false
	$Panel/ButtonC.disabled = false
	$Panel/ButtonD.disabled = false
	visible = false

	# Manda o jogador para o respawn
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.pode_andar = true
		player.respawn()
