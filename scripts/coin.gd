extends Area2D

@onready var collider = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
