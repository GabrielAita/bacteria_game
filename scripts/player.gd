extends CharacterBody2D

#Ataque
var enemy_in_atack_range = false
var enemy_atack_cooldown = true
#Status e demais
var health = 100
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

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")
	target_zoom = $Camera2D.zoom


func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_atack()
	atack()
	camera()
	$Camera2D.zoom = $Camera2D.zoom.lerp(target_zoom,zoom_speed*delta)
	if  health < 200:
		scale = Vector2(1,1)
	elif health >= 200 and health < 400:
		scale = Vector2(1.2,1.2)
	else:
		scale = Vector2(1.5,1.5)
		
	Global.is_alive(self)
	if health == 0:
		$AnimatedSprite2D.play("death")
		self.queue_free()
	
	
func player_movement(delta: float):
	
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

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atack_range = false
		
func enemy_atack():
	if enemy_in_atack_range and enemy_atack_cooldown == true:
		health = health - 20
		enemy_atack_cooldown = false
		$atack_cooldown.start()
		print(health)

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
		$Camera2D/camera_timer.start()
		
	if Input.is_action_just_pressed("zoom_out") and camera_transition:
		camera_transition = false
		target_zoom = Vector2(4, 4)
		$Camera2D/camera_timer.start()

func _on_camera_timer_timeout() -> void:
	camera_transition = true

func _on_death_timer_timeout() -> void:
	self.queue_free()
