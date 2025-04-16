extends CharacterBody2D


@export var enemy_scene = preload("res://scenes/enemy.tscn")
@export var max_enemies: int = 3
@export var spawn_radius: float = 100.0  # raio em que os inimigos serão spawnados

var current_enemies: int = 0

func _ready():
	while current_enemies < max_enemies:
		spawn_enemy()

func spawn_enemy():
	if not enemy_scene:
		print("Cena de inimigo não atribuída.")
		return

	var enemy = enemy_scene.instantiate()

	# Calcula posição aleatória ao redor do spawner
	var angle = randf() * TAU  # TAU = 2 * PI
	var offset = Vector2(cos(angle), sin(angle)) * randf_range(spawn_radius * 0.5, spawn_radius)
	enemy.position = self.position + offset

	get_tree().current_scene.add_child(enemy)
	current_enemies += 1

	# Quando o inimigo sair da árvore (morrer), decrementa e repõe
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_enemy_exited():
	current_enemies -= 1
	# Garante que sempre vai manter 3
	if current_enemies < max_enemies:
		spawn_enemy()
