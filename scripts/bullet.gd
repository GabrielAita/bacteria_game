extends Area2D


const SPEED: int = 200
 
func on_ready():
	add_to_group("bullet")
 
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
 
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

#func _on_area_2d_body_entered(body: Node2D) -> void:
#	if body.has_method("enemy"):
#		print("hit")
#		queue_free()

func bullet():
	pass
