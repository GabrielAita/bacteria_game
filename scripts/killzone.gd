extends Area2D

@export var dano: int = 10
@export var tempo_de_vida: float = 0.5 

func _ready():
	add_to_group("killzone")
	$Timer.wait_time = tempo_de_vida
	$Timer.start()


func _on_timer_timeout():
	queue_free()
