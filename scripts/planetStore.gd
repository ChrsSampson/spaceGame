extends Node

static var this_scene = preload("res://entity/planet.tscn")

@onready var container = $CanvasLayer/UI
@onready var close_button = $CanvasLayer/UI/CloseButton
@onready var store_title_display = $DisplayName
@onready var credit_display = $CanvasLayer/UI/CreditDisplay

var color:Color
var planet:Area2D
var credits:int = 0

signal close_shop()

func _ready() -> void:
	set_store_title(planet.planet_name)
	pass

#--------Getters and Setters ---------------

#TODO - some kind of order of operations issue with planet name
func set_store_title(name:String) -> void:
	var title = "%s Travel Hub"
	var planet_name = await planet.get_planet_name()
	var str = title % planet_name
	#store_title_display.text = String(str)

func set_color(c:Color) -> void:
	color = c
	container.modulate = color

func set_planet(p:Area2D) -> void:
	planet = p

func set_credits(i:int) -> void:
	credits = i

func _on_close_button_pressed() -> void:
	close_shop.emit()
