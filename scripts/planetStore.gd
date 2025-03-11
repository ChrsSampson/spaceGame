extends Node

@onready var container = $CanvasLayer/UI

var color:Color
var planet:Area2D

func _ready() -> void:
	set_color(planet.modulate)
	pass

func set_color(c:Color) -> void:
	color = c
	container.modulate = color
