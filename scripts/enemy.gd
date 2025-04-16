extends CharacterBody2D

var speed = 45
var player_chase = false
var player = null

var heatlh = 100
var player_in_atack_zone = false
var can_take_damage = true
var in_killzone = false

func _physics_process(delta: float) -> void:
	deal_with_damage()

	if heatlh > 0:
		if player_chase:
			position += (player.position - position) / speed
			move_and_slide()
			$AnimatedSprite2D.play("walk")

			if (player.position.x - position.x) < 0:
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


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = false
		

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		in_killzone = true
	if area.has_method("bullet"):
		area.queue_free() 
		if can_take_damage:
			heatlh -= Global.ranged_dmg
			print("Enemy hit by bullet. Health:", heatlh)
			can_take_damage = false
			$damaging_cooldown.start()

			if heatlh <= 0:
				player_chase = false
				$AnimatedSprite2D.play("death")
				$death_timer.start()

		


func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		in_killzone = false

func deal_with_damage():
	if player_in_atack_zone and Global.player_current_atack:
		if can_take_damage:
			heatlh -= Global.malle_dmg
			if (player.position.x - position.x) < 0:
				position.x += 20
			else:
				position.x -= 20
			print("Enemy hit by player. Health:", heatlh)
			can_take_damage = false
			$damaging_cooldown.start()

			if heatlh <= 0:
				player_chase = false
				$AnimatedSprite2D.play("death")
				$death_timer.start()

	if in_killzone and can_take_damage:
		heatlh -= Global.area_dmg
		print("Enemy hit by killzone. Health:", heatlh)
		can_take_damage = false
		$damaging_cooldown.start()

		if heatlh <= 0:
			player_chase = false
			$AnimatedSprite2D.play("death")
			$death_timer.start()


func _on_damaging_cooldown_timeout() -> void:
	can_take_damage = true


func _on_death_timer_timeout() -> void:
	queue_free()

func enemy():
	pass
