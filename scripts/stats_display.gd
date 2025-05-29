extends VBoxContainer

@onready var enemy_display = $enemyDisplay
@onready var xp_display = $xpDisplay
# Called when the node enters the scene tree for the first time.

var xp: String = str(Global.xp)
var enemies: String = str(Global.enemies_defeated)


func _process(delta: float) -> void:
	xp = str(Global.xp)
	enemies = str(Global.enemies_defeated)
	update_txt()

func update_txt():
	enemy_display.text = ("Enemies: " + enemies)
	xp_display.text = ("Xp: " + xp)
	
