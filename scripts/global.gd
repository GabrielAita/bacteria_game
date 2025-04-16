extends Node

# não complicar a camera

var player_current_atack = false
var can_atack = false
var score = 0

var current_scene = "world"
var transition_scene = false

var player_exit_posX = 159
var player_exit_posY = -204
var player_start_posX = 60
var player_start_posY = 5

var game_first_loaded = true

# player damage
var malle_dmg = 20
var ranged_dmg = 5
var area_dmg = 10

func finish_chanescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "map_2"
		elif current_scene == "map_2":
			current_scene = "world"

func add_point():
	score +=1
	print(score)


func is_alive(body):
	if body.health <= 0:
		body.health = 0
		Engine.time_scale = 0.5
		
func reload():
	get_tree().reload_current_scene()
	Engine.time_scale = 1
