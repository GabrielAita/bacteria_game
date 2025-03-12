extends CharacterBody2D

var speed = 45
var player_chase = false
var player = null

var heatlh = 100
var player_in_atack_zone = false

func _physics_process(delta: float) -> void:
	if player_chase == true:
		position += (player.position - position)/speed
		move_and_collide(Vector2(0,0))
		#move_and_slide()
		
		$AnimatedSprite2D.play("walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = false

func deal_with_damage():
	pass
