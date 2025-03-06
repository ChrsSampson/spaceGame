extends Area2D

@onready var collider = $CollisionShape2D
@onready var animator = $AnimatedSprite2D

func _ready() -> void:
	print("spawned health at", position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animator.play("die")
		body.heal(1)
		pass

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
