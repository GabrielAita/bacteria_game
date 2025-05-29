extends Node2D


@onready var bullet = preload("res://scenes/bullet.tscn")


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	atirar()
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	

func atirar():
	if Input.is_action_just_pressed("fire"):
		var bullet_instance = bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = $Marker2D.global_position
		bullet_instance.rotation = rotation
