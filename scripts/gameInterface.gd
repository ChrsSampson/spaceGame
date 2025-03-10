extends Node
@onready var credit_display = $CanvasLayer/Panel/Label

func update_credits(n:int) -> void:
	var str = "Credits %s"
	credit_display.text = str % [n]
