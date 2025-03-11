extends Node

#Scenes
var rock1_scene = preload("res://entity/rock1.tscn")
var healthPack_scene = preload("res://entity/healthPack.tscn")
var coin_scene = preload("res://entity/coin.tscn")
var planet_store_scene = preload("res://scenes/planetStore.tscn")
var planet_scene = preload("res://entity/planet.tscn")

#Selectors
@onready var rockSpawnTimer = $Timers/RockSpawner
@onready var enemyContainer = $Enemies
@onready var health_spawn_timer = $Timers/HealthSpawnTimer
@onready var health_pack_container = $HealthPacks
@onready var player = $Ship
@onready var view:Vector2 = Vector2(1920, 1080)
@onready var coin_timer = $Timers/CoinTimer
@onready var coin_container = $Coins
@onready var ui = $GameInterface
@onready var overlay = $Overlay
@onready var planet_container = $Planets

#player game state
var credits:int = 0
var is_paused: bool = false
var can_enter_store:bool = false
var in_store:bool = false
var docked_near:Area2D = null

#spawn intervals and stats
var spawn_interval: int = 10
var junk_spawned:int = 1
var enemies_spawned:int = 0
var coin_spawned:int = 0
var health_spawn_interval:int = 10
var health_spawned:int = 1


func _ready() -> void:
	rockSpawnTimer.start(1)
	coin_timer.start(5)
	handle_health_spawns()
	connect_planet_signals()
	pass

func _process(delta:float) -> void:
	if can_enter_store == false:
		exit_store()
	
#	player exit store
	elif in_store and Input.is_action_just_pressed("interact"):
		in_store = false
		exit_store()
	
#	player enter store
	elif can_enter_store and Input.is_action_just_pressed("interact") and not in_store:
		in_store = true
		player_enter_store(docked_near)

#----------------------Spawners and Location Generators----------------------------

#this works pretty ok
func get_random_point_offscreen() -> Vector2:
	var origin  = player.global_position
	var rx = (view.x + origin.x) * randi_range(-1, 1)
	var ry = (view.y + origin.y) * randi_range(-1, 1)
	var p = Vector2(rx, ry)
	return p

func spawn_rock():
	var rock = rock1_scene.instantiate()
	rock.set_player_position(player.global_position)
	rock.position = get_random_point_offscreen()
	enemyContainer.add_child(rock)
	pass
	

func spawn_coin():
	var new_coin = coin_scene.instantiate()
	new_coin.scale = Vector2(0.075, 0.075)
	new_coin.position = get_random_point_offscreen()
	coin_container.add_child(new_coin)
	new_coin.connect("body_entered", score)
	coin_timer.start(randi_range(2, 20))
	pass

func spawn_planet():
	var new_planet = planet_scene.instantiate()
	new_planet.position = get_random_point_offscreen()
	pass

func handle_health_spawns():
	randomize()
	health_spawn_timer.start(health_spawn_interval)
	health_spawn_interval = randi_range(5,30)
	health_spawned = randi_range(1,5)

func _on_rock_spawner_timeout() -> void:
	for m in junk_spawned:
		spawn_rock()
	junk_spawned += 1
	rockSpawnTimer.start(spawn_interval)

#kill anything out of bounds
func _on_spawn_area_body_exited(body: Node2D) -> void:
	body.queue_free()


func _on_health_spawn_timer_timeout() -> void:
	var new_pack = healthPack_scene.instantiate()
	var viewport = get_viewport().get_visible_rect().size
	new_pack.position = get_random_point_offscreen()
	health_pack_container.add_child(new_pack)
	handle_health_spawns()


func _on_coin_timer_timeout() -> void:
	spawn_coin()


#-------------------- Init Signals -------------------
func connect_planet_signals() -> void:
	var p = planet_container.get_children()
	for planet in p:
		planet.connect("player_docked", set_can_enter_store)

#------------------------- UI Updates------------------

func score(body) -> void:
	if body.is_in_group("player"):
		credits += 1
		ui.update_credits(credits)

func set_can_enter_store(v:bool, planet: Area2D) -> void:
	can_enter_store = v
	docked_near = planet

func player_enter_store(planet:Area2D) -> void:
	if can_enter_store:
		if Input.is_action_pressed("interact"):
			var store = planet_store_scene.instantiate()
			store.planet = planet
			overlay.add_child(store)
	pass
	
func exit_store() -> void:
	var node = overlay.get_node("PlanetStore")
	overlay.remove_child(node)
	pass
