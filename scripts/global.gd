extends Node

# não complicar a camera

var player_current_atack = false
var can_atack = false
var score = 0

func add_point():
	score +=1
	print(score)


func is_alive(body):
	if body.health <= 0:
		body.health = 0
		Engine.time_scale = 0.5
		print(body.health)
		
