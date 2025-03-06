extends Node

var rock1_scene = preload("res://entity/rock1.tscn")
var healthPack_scene = preload("res://entity/healthPack.tscn")

@onready var rockSpawnTimer = $RockSpawner
@onready var enemyContainer = $Enemies
@onready var health_spawn_timer = $HealthSpawnTimer
@onready var health_pack_container = $HealthPacks
@onready var player = $Ship

#spawn intervals and stats
var spawn_interval: int = 10
var entities_spawned:int = 1
var health_spawn_interval:int = 10
var health_spawned:int = 1

var is_paused: bool = false

func _ready() -> void:
	rockSpawnTimer.start(1)
	handle_health_spawns()
	pass

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		if is_paused:
			is_paused = false
			get_tree().paused = false
		else:
			is_paused = true
			get_tree().paused = true

func spawn_rock():
	var rock = rock1_scene.instantiate()
	rock.set_player_position(player.global_position)
	enemyContainer.add_child(rock)
	pass
	

func handle_health_spawns():
	randomize()
	health_spawn_timer.start(health_spawn_interval)
	health_spawn_interval = randi_range(5,30)
	health_spawned = randi_range(1,5)

func _on_rock_spawner_timeout() -> void:
	for m in entities_spawned:
		spawn_rock()
	entities_spawned += 1
	rockSpawnTimer.start(spawn_interval)

#kill anything out of bounds
func _on_spawn_area_body_exited(body: Node2D) -> void:
	body.queue_free()


func _on_health_spawn_timer_timeout() -> void:
	var new_pack = healthPack_scene.instantiate()
	var viewport = get_viewport().get_visible_rect().size
	new_pack.position = Vector2(randi_range(0,viewport.x), randi_range(0, viewport.y))
	health_pack_container.add_child(new_pack)
	handle_health_spawns()

#------------------------- Game state and Menus------------------
