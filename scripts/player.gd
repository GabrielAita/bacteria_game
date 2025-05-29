extends CharacterBody2D

#Ataque
@onready var bullet = preload("res://scenes/bullet.tscn")
var enemy_in_atack_range = false
var enemy_atack_cooldown = true
var fire = true
#Status e demais

var player_alive = true
var atacking = false
var SPEED = 100
var direction = "none"

#Killzone
var can_spawn_killzone = true

# Camera
var camera_transition = true
var target_zoom = Vector2(4, 4)  
var zoom_speed = 1.5

#Movimentação
var player_can_move = true
var can_take_damage = true

func _ready() -> void:
	queue_redraw()
	Global.vida_atual = Global.vida_inicial
	Global.area_dmg = Global.dano_area_inicial
	Global.ranged_dmg = Global.dano_ranged_inicial
	Global.malle_dmg = Global.dano_melle_inicial
	Global.xp = Global.quantidade_inicial
	Global.back_to_menu = false
	Global.time_survived = 0
	Global.score = 0
	Global.enemies_defeated = 0
	add_to_group("player")
	$AnimatedSprite2D.play("front_idle")
	target_zoom = $world_camera.zoom
	


func player():
	pass
	
func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_atack()
	atack()
	camera()
	current_camera()
	atirar()
	$world_camera.zoom = $world_camera.zoom.lerp(target_zoom,zoom_speed*delta)
	if  Global.vida_atual < 200:
		scale = Vector2(1,1)
		$player_hitbox/CollisionShape2D.scale = Vector2(1,1)
	elif Global.vida_atual >= 200 and Global.vida_atual < 400:
		scale = Vector2(1.2,1.2)
		$player_hitbox/CollisionShape2D.scale = Vector2(1.2,1.2)
	else:
		scale = Vector2(1.5,1.5)
		$player_hitbox/CollisionShape2D.scale = Vector2(1.5,1.5)
		
	if Global.vida_atual <= 0:
		Global.vida_atual = 0
		player_can_move = false
		$AnimatedSprite2D.play("death")
		$death_timer.start()
	else:
		return
	
	
func player_movement(delta: float):
	if player_can_move:
		if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			direction = "down"
			play_animation(1)
			velocity.x = (sqrt(2)/2)*SPEED
			velocity.y = (sqrt(2)/2)*SPEED
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			direction = "down"
			play_animation(1)
			velocity.x = -(sqrt(2)/2)*SPEED
			velocity.y = (sqrt(2)/2)*SPEED
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			direction = "up"
			play_animation(1)
			velocity.x = (sqrt(2)/2)*SPEED
			velocity.y = -(sqrt(2)/2)*SPEED
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			direction = "up"
			play_animation(1)
			velocity.x = -(sqrt(2)/2)*SPEED
			velocity.y = -(sqrt(2)/2)*SPEED
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_right"):
			direction = "right"
			play_animation(1)
			velocity.x = SPEED
			velocity.y = 0
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_left"):
			direction = "left"
			play_animation(1)
			velocity.x = -SPEED
			velocity.y = 0
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_down"):
			direction = "down"
			play_animation(1)
			velocity.x = 0
			velocity.y = SPEED
			spawn_killzone()
			
		elif Input.is_action_pressed("ui_up"):
			direction = "up"
			play_animation(1)
			velocity.x = 0
			velocity.y = -SPEED
			spawn_killzone()
			
		else:
			play_animation(0)
			velocity.x = 0
			velocity.y = 0
		
		move_and_slide()

func play_animation(movement):
	var dir = direction
	var anim = $AnimatedSprite2D
	if player_can_move:
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if atacking == false:
					anim.play("side_idle")
		
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if atacking == false:
					anim.play("side_idle")
		
		if dir == "down":
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				if atacking == false:
					anim.play("side_idle")
		
		if dir == "up":
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				if atacking == false:
					anim.play("side_idle")
	

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atack_range = true
	


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atack_range = false
		
func enemy_atack():
	if can_take_damage:
		if enemy_in_atack_range:
			if enemy_atack_cooldown == true:
				Global.vida_atual = Global.vida_atual - 20
				enemy_atack_cooldown = false
				$atack_cooldown.start()
				print(Global.vida_atual)


func _on_atack_cooldown_timeout() -> void:
	enemy_atack_cooldown = true
	
	
func atack():
	var dir = direction
	if Input.is_action_just_pressed("atack"):
		Global.player_current_atack = true
		atacking = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_atack")
			$deal_atack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_atack")
			$deal_atack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_atack")
			$deal_atack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_atack")
			$deal_atack_timer.start()

func _on_deal_atack_timer_timeout() -> void:
	$deal_atack_timer.stop()
	Global.player_current_atack = false
	atacking = false

@onready var killzone_scene = preload("res://scenes/killzone.tscn")

func spawn_killzone():
	if can_spawn_killzone and Global.can_atack:
		can_spawn_killzone = false
		$killzone_timer.start()
		var killzone_instance = killzone_scene.instantiate()
		get_parent().add_child(killzone_instance)  
		killzone_instance.global_position = global_position  


func _on_killzone_timer_timeout() -> void:
	can_spawn_killzone = true


func camera():
	if Input.is_action_just_pressed("zoom_in") and camera_transition:
		camera_transition = false
		target_zoom = Vector2(1, 1)
		$world_camera/camera_timer.start()
		
	if Input.is_action_just_pressed("zoom_out") and camera_transition:
		camera_transition = false
		target_zoom = Vector2(4, 4)
		$world_camera/camera_timer.start()

func _on_camera_timer_timeout() -> void:
	camera_transition = true

func current_camera():
	if Global.current_scene == "world":
		$world_camera.enabled = true
		$map_2_camera.enabled = false
	elif Global.current_scene == "map_2":
		$world_camera.enabled = false
		$map_2_camera.enabled = true

func _on_death_timer_timeout() -> void:
	Global.back_to_menu = true
	
	

func atirar():
	if Input.is_action_just_pressed("fire") and Global.can_shoot:
		Global.can_shoot = false
		$AnimatedSprite2D.play("front_atack")
		
		var bullet_instance = bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		
		var direction = (get_global_mouse_position() - global_position).normalized()
		
		bullet_instance.global_position = global_position
		bullet_instance.rotation = direction.angle()
		
		bullet_instance.bullet(direction,self)
		
		$fire_rate.start()



func _on_fire_rate_timeout() -> void:
	Global.can_shoot = true


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_player_hitbox_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
