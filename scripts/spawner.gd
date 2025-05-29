extends CharacterBody2D

var health = 200

var speed = 45
var player_chase = false
var player = null
var player_in_atack_zone = false
var can_take_damage = true
var in_killzone = false

var can_spawn = true
var number_of_spawn = 0
var max_spawn = 3
var player_inside = false
var spawn_radius: float = 100.0

@onready var enemies = preload("res://scenes/enemy.tscn")

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("default")
	if can_spawn and number_of_spawn < max_spawn and player_inside:
		spawning_in_area()

func spawning_in_area():
	# Calcula posição aleatória ao redor do spawner
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * randf_range(spawn_radius * 0.5, spawn_radius)
	var spawn_position = self.global_position + offset

	var enemies_instance = enemies.instantiate()
	enemies_instance.global_position = spawn_position
	get_parent().add_child(enemies_instance)

	number_of_spawn += 1
	can_spawn = false
	$Timer.start()
	print("Spawnando inimigo")

	enemies_instance.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_timer_timeout() -> void:
	can_spawn = true

func _on_enemy_exited():
	number_of_spawn -= 1


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == player:
		print("entrou")
		player_inside = true
	


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inside = false

func deal_with_damage():
	if player_in_atack_zone and Global.player_current_atack:
		if can_take_damage:
			health -= Global.malle_dmg
			print("*Enemy hit by player. Health:", health)
			can_take_damage = false
			$damaging_cooldown.start()

			if health <= 0:
				player_chase = false
				$AnimatedSprite2D.play("death")
				$death_timer.start()

	if in_killzone and can_take_damage:
		health -= Global.area_dmg
		print("*Enemy hit by killzone. Health:", health)
		can_take_damage = false
		$damaging_cooldown.start()

		if health <= 0:
			player_chase = false
			$AnimatedSprite2D.play("death")
			$death_timer.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		in_killzone = true
	if area.has_method("bullet"):
		area.queue_free() 
		if can_take_damage:
			health -= Global.ranged_dmg
			print("*Enemy hit by bullet. Health:", health)
			can_take_damage = false
			$damaging_cooldown.start()

			if health <= 0:
				player_chase = false
				$AnimatedSprite2D.play("death")
				$death_timer.start()


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		in_killzone = false


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_damaging_cooldown_timeout() -> void:
	can_take_damage = true
