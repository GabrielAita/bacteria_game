extends CharacterBody2D

@export var velocidade: float = 100.0
@export var alcance_visao: float = 200.0
@export var player_node: NodePath
@export var bullet_scene: PackedScene

var jogador: Node2D
var estado_atual := State.PATROL
enum State { PATROL, CHASE }

var direcao := Vector2.RIGHT
var tempo_patrol := 2.0
var tempo_atual := 0.0

var health:= 100
var player_in_atack_zone = false
var can_take_damage = true
var in_killzone = false
var is_dead := false

func _ready():
	add_to_group("enemy")
	#jogador = get_node(player_node)
	
	if jogador == null:
		print("Erro: jogador não encontrado!")
	else:
		print("Jogador referenciado corretamente.")
		
	$FireRateTimer.start()


func _process(delta: float):
	if health <= 0:
		if not is_dead:
			is_dead = true
		death()
		return
	deal_with_damage()
	if not Global.vida_atual:
		return
	
	match estado_atual:
		State.PATROL:
			patrulhar(delta)
		State.CHASE:
			perseguir(delta)

func patrulhar(delta: float):
	tempo_atual += delta
	if tempo_atual >= tempo_patrol:
		direcao *= -1
		tempo_atual = 0

	velocity = direcao * velocidade
	move_and_slide()
	
	$AnimatedSprite2D.play("walk")
	if direcao.x>=0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

	if position.distance_to(jogador.position) <= alcance_visao:
		estado_atual = State.CHASE


func perseguir(delta: float):
	var dir = (jogador.position - position).normalized()
	velocity = dir * (velocidade * 0.3)
	move_and_slide()
	$AnimatedSprite2D.play("walk")

	if (jogador.position.x - position.x) < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if position.distance_to(jogador.position) > alcance_visao:
		estado_atual = State.PATROL


func atirar():
	if Global.vida_atual <= 0:
		pass
	else:
		var bullet_instance = bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		var direction = (jogador.global_position - global_position).normalized()
		bullet_instance.global_position = global_position
		bullet_instance.rotation = direction.angle()
			
		bullet_instance.bullet(direction,self)


func _on_fire_rate_timer_timeout() -> void:
	if estado_atual == State.CHASE:
		print("atirou")
		atirar()

func deal_with_damage():
	if health > 0:
		if player_in_atack_zone and Global.player_current_atack:
			if can_take_damage:
				health -= Global.malle_dmg
				
				if (jogador.global_position.x - global_position.x) < 0:
					position.x += 20
				else:
					position.x -= 20
					
				print("Enemy hit by player. Health:", health)
				can_take_damage = false
				$damaging_cooldown.start()
				Global.enemies_defeated += 1


	if in_killzone and can_take_damage:
		health -= Global.area_dmg
		print("Enemy hit by killzone. Health:", health)
		can_take_damage = false
		$damaging_cooldown.start()
		death()
		
func death():
	if health <= 0:
		health = 0
		jogador = null
		Global.score += 1000
		Global.enemies_defeated += 1
		estado_atual = State.PATROL
		print(Global.score)

		$AnimatedSprite2D.play("death")
		$death_timer.start()


func _on_damaging_cooldown_timeout() -> void:
	can_take_damage = true


func _on_death_timer_timeout() -> void:
	self.queue_free()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = true


func _on_hurt_box_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atack_zone = false
