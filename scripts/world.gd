extends Node2D



func _ready() -> void:
	if Global.game_first_loaded == true:
		$CharacterBody2D.position.x = Global.player_start_posX
		$CharacterBody2D.position.y = Global.player_start_posY
	else:
		$CharacterBody2D.position.x = Global.player_exit_posX
		$CharacterBody2D.position.y = Global.player_exit_posY
	
	






func _on_area_2_transition_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
		if Global.transition_scene == true:
			if Global.current_scene == "world":
				get_tree().change_scene_to_file("res://scenes/map_2.tscn")
				Global.current_scene = "map_2"
				Global.game_first_loaded = false


func _on_area_2_transition_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = false

func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/map_2.tscn")
			Global.finish_chanescenes()
		


	
