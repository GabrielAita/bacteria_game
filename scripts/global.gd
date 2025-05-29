extends Node2D

var vida_inicial = 150
var dano_ranged_inicial = 5
var dano_area_inicial = 10
var dano_melle_inicial = 20
var quantidade_inicial = 0

var back_to_menu = false

var can_shoot = false
var player_current_atack = false
var can_atack = false
var score = 0
var xp = 0
var enemies_defeated := 0
var time_survived := 0

var current_scene = null

var player_exit_posX = 159
var player_exit_posY = -204
var player_start_posX = 60
var player_start_posY = 5

var game_first_loaded = true

# player stats
var health_cap = 150
var malle_dmg = 20
var ranged_dmg = 200
var area_dmg = 10
var vida_atual = 150



func add_point():
	score +=1
	print(score)


func _ready() -> void:
	queue_redraw()
		
func reload():
	get_tree().reload_current_scene()
	Engine.time_scale = 1


var is_paused: bool = false

# Função para alternar pause/despause
func toggle_pause():
	if is_paused == true:
		is_paused = false
	else:
		is_paused = true
	get_tree().paused = is_paused
	print("Jogo pausado: ", is_paused)
	
