extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#change_scene()
	pass


func _on_map_2_world_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
		if Global.transition_scene == true:
			if Global.current_scene == "map_2":
				get_tree().change_scene_to_file("res://scenes/world.tscn")
				Global.current_scene = "world"


func _on_map_2_world_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = false
