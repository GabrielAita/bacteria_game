extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("Open Menu"):
		Global.toggle_pause()
		toggle_visibility(self)
		
func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
