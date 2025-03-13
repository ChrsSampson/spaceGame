extends Node

#Game Director switches between major scenes like space and planetStores, ect...
#Manages Game state passed between major scenes

var store_scene = preload("res://scenes/planetStore.tscn")
var space_scene = preload("res://scenes/level.tscn")

var current_planet:Area2D = null
var player_credits:int = 0
var player_respawn_position:Vector2 = Vector2.ZERO
var player_respawn_rotation:int

#list of currently spawned planets
var planets:Array[Area2D] = []

func _process(delta:float) -> void:
	pass

#Scene Managment

func switch_to_store() -> void:
	var level = get_node("Level")
	var store = store_scene.instantiate()
	store.planet  = current_planet
	store.credits = player_credits
	remove_child(level)
	add_child(store)
	pass
	
func switch_to_space() -> void:
	var store = get_node("PlanetStore")
	var level = space_scene.instantiate()
	remove_child(store)
	add_child(level)
	pass

#----------------------Getters and Setters--------------
func set_current_planet(p:Area2D) -> void:
	current_planet = p

func set_player_credits(v:int) -> void:
	player_credits = v

func add_planet_to_map(p:Area2D) -> void:
	planets.push_back(p)

func get_planets() -> Array:
	return planets

func set_player_respawn_position(p:Vector2, r:int) -> void:
	player_respawn_position = p
	player_respawn_rotation = r

func get_player_respawn_position() -> Vector2:
	return player_respawn_position

func  get_player_respawn_rotation() -> int:
	return player_respawn_rotation
