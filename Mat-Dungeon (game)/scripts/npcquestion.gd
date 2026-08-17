extends CharacterBody2D

var player_near = false

func _on_interaction_area_body_entered(body):
	if body is CharacterBody2D:
		if body.name == "Player":
			player_near = true
			print("Player chegou ao NPC!")

func _on_interaction_area_body_exited(body):
	if body is CharacterBody2D:
		if body.name == "Player":
			player_near = false
			print("Player saiu do NPC!")

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
