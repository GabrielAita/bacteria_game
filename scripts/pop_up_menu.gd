extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
@export var help_menu_screen: MarginContainer
@export var settings_menu_screen: MarginContainer

func _ready() -> void:
	if Global.is_paused == false:
			menu_screen.hide()
func _process(delta: float) -> void:
	pass

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
		

		
func _on_toggle_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)

func _on_toggle_help_menu_pressed() -> void:
	toggle_visibility(help_menu_screen)
	toggle_visibility(menu_screen)



func _on_toggle_settings_menu_pressed() -> void:
	toggle_visibility(settings_menu_screen)
	toggle_visibility(menu_screen)
	
func _input(event):
	if event.is_action_pressed("Open Menu"):
		Global.toggle_pause()
		if Global.is_paused == false:
			menu_screen.hide()
			open_menu_screen.hide()
			help_menu_screen.hide()
			settings_menu_screen.hide()
		else:
			menu_screen.show()
			open_menu_screen.hide()
			help_menu_screen.hide()
			settings_menu_screen.hide()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
