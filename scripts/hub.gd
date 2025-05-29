extends Node2D

@onready var enemies = preload("res://scenes/enemy.tscn")
@onready var area1 = $Area1
@onready var area2 = $Area2
@onready var area3 = $Area3
@onready var area4 = $Area4
@onready var area5 = $Area5
@onready var area6 = $Area6
var is_in_area1 := false
var is_in_area2 := false
var is_in_area3 := false
var is_in_area4 := false
var is_in_area5 := false
var is_in_area6 := false
var can_spawn = true
var number_of_spawn = 0
var max_spawn = 7


func _ready() -> void:
	queue_redraw()
	
func _physics_process(delta: float) -> void:
	if Global.back_to_menu:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
func _on_area_1_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area1 = true

func _on_area_1_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area1 = false


func _process(delta: float) -> void:
	if is_in_area1:
		spawning_in_area(area1)
	elif  is_in_area2:
		spawning_in_area(area2)
	elif  is_in_area3:
		spawning_in_area(area3)
	elif  is_in_area4:
		spawning_in_area(area4)
	elif  is_in_area5:
		spawning_in_area(area5)
	elif  is_in_area6:
		spawning_in_area(area6)



func spawning_in_area(area):
	if area and can_spawn and number_of_spawn < max_spawn:
		var collision_shape = area.get_node_or_null("CollisionShape2D")
		var extents = collision_shape.shape.extents
		var local_position = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
			# Converte para a posição global
		var spawn_position = area.position + local_position
		

		print("Posição de spawn: ", spawn_position)

		var enemies_instance = enemies.instantiate()
		enemies_instance.position = spawn_position
		get_parent().add_child(enemies_instance)
		print("Inimigo instanciado!")
		
		number_of_spawn += 1
		can_spawn = false
		$Timer_between_spawns.start()


func _on_enemy_exited():
	number_of_spawn -= 1

func _on_timer_between_spawns_timeout() -> void:
	can_spawn = true


func _on_area_2_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area2 = true


func _on_area_2_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area2 = false


func _on_area_3_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area3 = true


func _on_area_3_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area3 = false
		
func _on_area_4_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area4 = true


func _on_area_4_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area4 = false

func _on_area_5_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area5 = true


func _on_area_5_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area5 = false

func _on_area_6_body_entered(body: Node2D) -> void:
	if body == $player:
		is_in_area6 = true


func _on_area_6_body_exited(body: Node2D) -> void:
	if body == $player:
		is_in_area6= false
