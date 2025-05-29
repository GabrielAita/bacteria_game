extends MarginContainer


@export var quantide_display: Label
@export var vida_display: Label 
@export var objetivo_1_display : Label
@export var objetivo_2_display : Label
@export var objetivo_3_display : Label
@export var objetivo_4_display : Label
@export var objetivo_1_panel : Panel
@export var objetivo_2_panel : Panel
@export var objetivo_3_panel : Panel
@export var objetivo_4_panel : Panel


var vidamax = str(Global.health_cap)
var quantidade = str(Global.score)
var vida_atual = str(Global.vida_atual)

func _process(delta: float) -> void:
	vidamax = str(Global.health_cap)
	quantidade = str(Global.score)
	vida_atual = str(Global.vida_atual)
	update_txt()
	_att_objetivo()

func update_txt():
	quantide_display.text = ("QTD: " + quantidade)
	vida_display.text = ("Vida: " + vida_atual + "/" + vidamax)

func _att_objetivo():
	if Global.current_scene == "lvl1":
		var kill_1: int = 15
		var time_1: int = 120
		objetivo_1_display.text = "Elimine " + str(kill_1) + " inimigos: " + str(Global.enemies_defeated)
		objetivo_2_display.text = "Sobreviva por " + str(time_1) + " segundos: " + str(Global.time_survived)
		objetivo_3_display.hide()
		objetivo_4_display.hide()
		if Global.enemies_defeated == kill_1: 
			objetivo_1_panel.show()
		elif Global.time_survived == time_1:
			objetivo_2_panel.show()
		else:
			pass
	if Global.current_scene == "lvl2":
		var kill_1: int = 10
		var time_1: int = 90
		objetivo_1_display.text = "Elimine " + str(kill_1) + " inimigos: " + str(Global.enemies_defeated)
		objetivo_2_display.text = "Sobreviva por " + str(time_1) + " segundos: " + str(Global.time_survived)
		objetivo_3_display.hide()
		objetivo_4_display.hide()
		if Global.enemies_defeated == kill_1: 
			objetivo_1_panel.show()
		elif Global.time_survived == time_1:
			objetivo_2_panel.show()
		else:
			pass
	if Global.current_scene == "lvl3":
		var time_1: int = 180
		objetivo_1_display.text = "Sobreviva por " + str(time_1) + " segundos: " + str(Global.time_survived)
		objetivo_2_display.hide()
		objetivo_3_display.hide()
		objetivo_4_display.hide()
		if Global.time_survived == time_1:
			objetivo_1_panel.show()
		else:
			pass
