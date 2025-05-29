extends MarginContainer

@export var menu_screen: HBoxContainer
@export var settings_menu_screen: MarginContainer
@export var controls_menu_screen: MarginContainer
@export var how_to_play_menu_screen: MarginContainer

func _ready() -> void:
	queue_redraw()

		
func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lvl_select_screen.tscn")


func _on_toggle_settings_menu_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(settings_menu_screen)


func _on_toggle_controls_menu_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(controls_menu_screen)


func _on_toggle_htp_menu_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(how_to_play_menu_screen)
