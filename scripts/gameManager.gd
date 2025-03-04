extends Node

var rock1_scene = preload("res://entity/rock1.tscn")

@onready var rockSpawnTimer = $RockSpawner
@onready var enemyContainer = $Enemies
@onready var spawn_area:Area2D = $SpawnArea

var spawn_interval: int = 10
var entities_spawned:int = 1

func _ready() -> void:
	rockSpawnTimer.start(1)
	pass
	
func spawn_rock():
	print("spawned rock")
	var rock = rock1_scene.instantiate()
	rock.set_spawn_area(spawn_area)
	enemyContainer.add_child(rock)
	pass
	


func _on_rock_spawner_timeout() -> void:
	for m in entities_spawned:
		spawn_rock()
	entities_spawned += 1
	rockSpawnTimer.start(spawn_interval)

#kill anything out of bounds
func _on_spawn_area_body_exited(body: Node2D) -> void:
	body.queue_free()
