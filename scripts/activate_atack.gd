extends Area2D

var health = 20
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.can_atack = true
		print("Corre")
		self.queue_free()
		
