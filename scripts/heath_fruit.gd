extends Area2D

var health = 30
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if Global.vida_atual + health >= Global.health_cap:
			Global.vida_atual = Global.health_cap
			print(Global.vida_atual)
			self.queue_free() 
		else:
			Global.vida_atual += health
			print(Global.vida_atual)
			self.queue_free()
		
