extends CharacterBody2D

var speed = 90
var player = null
var heatlh = 100
var player_in_atack_zone = false
var can_take_damage = true
var in_killzone = false

@export var collectible_scenes: Array = []
@export var drop_chance: float = 0.5
@export var bullet_scene: PackedScene

# Estados
enum State { PATROL, CHASE , DEAD}
var estado_atual: State = State.PATROL

# Patrulha
var patrol_timer := 0.0
var patrol_max := 3.0
var patrol_direction := Vector2.LEFT

func _ready():
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	if heatlh>0:
		deal_with_damage()
	else:
		estado_atual = State.DEAD

	match estado_atual:
		State.PATROL:
			patrulhar(delta)
		State.CHASE:
			perseguir(delta)
		State.DEAD:
			$AnimatedSprite2D.play("death")

func patrulhar(delta):
	patrol_timer += delta
	if patrol_timer >= patrol_max:
		patrol_direction *= -1
		patrol_timer = 0

	velocity = patrol_direction.normalized() * speed
	move_and_slide()
	$AnimatedSprite2D.play("walk")
	if patrol_direction.x>=0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

	# Se o jogador for detectado
	if player and position.distance_to(player.position) <= 200:
		estado_atual = State.CHASE

func perseguir(delta):
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()
		$AnimatedSprite2D.play("walk")

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

		# Se o jogador fugir
		if position.distance_to(player.position) > 250:
			estado_atual = State.PATROL
	else:
		estado_atual = State.PATROL

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		estado_atual = State.CHASE

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		estado_atual = State.PATROL

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
			can_take_damage = false
			$damaging_cooldown.start()
			print("Enemy hit by bullet. Health:", heatlh)
			death()

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
			death()

	if in_killzone and can_take_damage:
		heatlh -= Global.area_dmg
		print("Enemy hit by killzone. Health:", heatlh)
		can_take_damage = false
		$damaging_cooldown.start()
		death()

func _on_damaging_cooldown_timeout() -> void:
	can_take_damage = true

func _on_death_timer_timeout() -> void:
	queue_free()

func enemy():
	pass

func death():
	if heatlh <= 0:
		heatlh = 0
		Global.score += 1000
		Global.enemies_defeated += 1
		player = null
		estado_atual = State.PATROL
		print(Global.score)

		if randf() <= drop_chance:
			var random_collectible = collectible_scenes[randi() % collectible_scenes.size()]
			var collectible_instance = random_collectible.instantiate()
			collectible_instance.position = self.position
			get_parent().add_child(collectible_instance)

		$AnimatedSprite2D.play("death")
		$death_timer.start()
