extends Area2D

@export var speed: int = 150
var velocity: Vector2 = Vector2.ZERO
var pao: CharacterBody2D = null


func _ready() -> void:
	add_to_group("bullet")

func _process(delta: float) -> void:
	position += velocity * delta

func bullet(direction: Vector2, shooter: Node) -> void:
	velocity = direction.normalized() * speed
	pao = shooter

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == pao:
		return  
	
	if body.has_method("enemy_atack") and pao != body:
		body.enemy_atack()
		Global.vida_atual -= Global.ranged_dmg
		queue_free()
		return
	
	if body.is_in_group("killzone"):
		return
	else:
		queue_free()
