extends Node

@onready var container = $CanvasLayer/UI
@onready var credits_display = $CanvasLayer/UI/CreditDisplay
@onready var planet_display = $CanvasLayer/UI/PlanetDisplay
@onready var exit_button = $"CanvasLayer/Exit Button"

@onready var game_director = self.get_parent()

var color:Color
var planet:Area2D
var credits:int

func _ready() -> void:
	set_color(planet.modulate)
	update_credits()
	update_planet_name()
	pass

func set_color(c:Color) -> void:
	color = c
	container.modulate = color

func update_planet_name() -> void:
	var str = "%s Travel Hub"
	planet_display.text = str % planet.planet_name

func update_credits() -> void:
	var str = "Credtis: %s"
	credits_display.text = str % credits


func _on_exit_button_pressed() -> void:
	game_director.switch_to_space()
	
