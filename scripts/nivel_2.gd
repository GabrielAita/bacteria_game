extends Node2D

@export var spawner_area: Area2D
@export var player_node: NodePath
@onready var enemies = preload("res://scenes/enemy.tscn")
@onready var linfoctotos = preload("res://scenes/linfocito_t.tscn")

var can_spawn := false
var number_of_spawn := 0
var max_spawn := 30
var is_dead := false

var spawned_enemies: Array = []
var spawned_linfocitos: Array = []

func _ready() -> void:
	Global.current_scene = "lvl2"
	queue_redraw() 

func _process(delta: float) -> void:
	spawn()
	if Global.vida_atual <= 0 and not is_dead:
		is_dead = true
		for enemy in spawned_enemies:
			if is_instance_valid(enemy):
				enemy.queue_free()
		for linfocito in spawned_linfocitos:
			if is_instance_valid(linfocito):
				linfocito.queue_free()

		spawned_enemies.clear()
		spawned_linfocitos.clear()

		print("morreu")
		$byebye_timer.start()


func spawn():
	if can_spawn and number_of_spawn < max_spawn:
		var collision_shape = spawner_area.get_node_or_null("CollisionShape2D")
		if collision_shape == null:
			print("CollisionShape2D não encontrado!")
			return

		var radius = (collision_shape.shape as CircleShape2D).radius
		
		var angle = randf_range(0, TAU)
		var distance = randf_range(0, radius)
		var local_position = Vector2(cos(angle), sin(angle)) * distance

		var spawn_position = spawner_area.global_position + local_position
		
		print("Posição de spawn: ", spawn_position)

		var enemies_instance = enemies.instantiate()
		enemies_instance.global_position = spawn_position
		get_parent().add_child(enemies_instance)
		spawned_enemies.append(enemies_instance)

		var linfocito_instance = linfoctotos.instantiate()
		linfocito_instance.jogador = get_node(player_node)
		linfocito_instance.global_position = spawn_position
		get_parent().add_child(linfocito_instance)
		spawned_linfocitos.append(linfocito_instance)


		
		
		print("Inimigos instanciados!")
		
		number_of_spawn += 2
		can_spawn = false
		$spawner_timer.start()


func _on_spawn_area_body_exited(body: Node2D) -> void:
	$survive_timer.start()
	print("saiu")
	can_spawn = true
	$spawn_area.queue_free()


func _on_spawner_timer_timeout() -> void:
	can_spawn = true


func _on_survive_timer_timeout() -> void:
	$spawner_timer.start()
	Global.time_survived += 1


func _on_byebye_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
