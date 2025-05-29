extends MarginContainer

@export var lvl1: MarginContainer
@export var lvl2: MarginContainer
@export var lvl3: MarginContainer


	
func _ready() -> void:
	queue_redraw()
	
func _physics_process(delta: float) -> void:
	pass

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_lvl_1_button_pressed() -> void:
	toggle_visibility(lvl1)
	lvl2.hide()
	lvl3.hide()


func _on_lvl_2_button_pressed() -> void:
	toggle_visibility(lvl2)
	lvl1.hide()
	lvl3.hide()

func _on_lvl_3_button_pressed() -> void:
	toggle_visibility(lvl3)
	lvl1.hide()
	lvl2.hide()


func _on_lvl_1_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nivel_1.tscn")
	Global.current_scene = "lvl1"


func _on_lvl_2_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nivel_2.tscn")
	Global.current_scene = "lvl2"


func _on_lvl_3_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nivel_3.tscn")
	Global.current_scene = "lvl3"
