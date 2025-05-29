extends CharacterBody2D

var speed = 45

@export var player_tracker: Node2D
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D


func _physics_process(delta: float) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos)
	velocity = dir * speed
	print(velocity)
	move_and_slide()
	
func makepath():
	nav_agent.target_position = player_tracker.global_position

func _on_timer_timeout() -> void:
	makepath()
