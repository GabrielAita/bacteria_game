extends Area2D

var health = 30
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.health += health
		print(body.health)
		self.queue_free()
		
