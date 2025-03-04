extends Node

var rock1_scene = preload("res://entity/rock1.tscn")

@onready var rockSpawnTimer = $RockSpawner
@onready var enemyContainer = $Enemies

var spawn_interval: int = 10
var entities_spawned:int = 1

func _ready() -> void:
	rockSpawnTimer.start(1)
	pass
	
func spawn_rock():
	print("spawned rock")
	var rock = rock1_scene.instantiate()
	enemyContainer.add_child(rock)
	pass
	


func _on_rock_spawner_timeout() -> void:
	var i = 0
	while i < entities_spawned:
		spawn_rock()
	entities_spawned += 1
	rockSpawnTimer.start(spawn_interval)
