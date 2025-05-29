extends Area2D

var health = 20
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if Global.can_atack == true:
			Global.malle_dmg += 10
			self.queue_free()
		else:
			Global.can_atack = true
			print("Corre")
			self.queue_free()
		
