extends CharacterBody2D

var enemy_in_atack_range = false
var enemy_atack_cooldown = true
var health = 100
var player_alive = true

var SPEED = 100
var direction = "none"

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")


func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_atack()
	
	if health <= 0:
		player_alive = false 
		#menu
		health = 0
		print("defeat")
		self.queue_free()
	
func player_movement(delta: float):
	
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		direction = "down"
		play_animation(1)
		velocity.x = (sqrt(2)/2)*SPEED
		velocity.y = (sqrt(2)/2)*SPEED
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		direction = "down"
		play_animation(1)
		velocity.x = -(sqrt(2)/2)*SPEED
		velocity.y = (sqrt(2)/2)*SPEED
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		direction = "up"
		play_animation(1)
		velocity.x = (sqrt(2)/2)*SPEED
		velocity.y = -(sqrt(2)/2)*SPEED
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		direction = "up"
		play_animation(1)
		velocity.x = -(sqrt(2)/2)*SPEED
		velocity.y = -(sqrt(2)/2)*SPEED
	elif Input.is_action_pressed("ui_right"):
		direction = "right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		direction = "left"
		play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		direction = "down"
		play_animation(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		direction = "up"
		play_animation(1)
		velocity.x = 0
		velocity.y = -SPEED
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
			anim.play("side_idle")
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

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
