extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if Global.can_shoot == true:
			Global.ranged_dmg += 5
			self.queue_free()
		else:
			Global.can_shoot = true
			self.queue_free()
