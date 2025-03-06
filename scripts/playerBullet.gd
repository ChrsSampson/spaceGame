extends Area2D

var speed:float = 500

func _process(delta: float) -> void:
	var direction = global_transform.basis_xform(Vector2.RIGHT)
	var velocity = direction  * speed
	position += velocity * delta
	pass

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("Bullet detected -" , body)
	if body.is_in_group("enemy") or body.is_in_group("rock"):
		queue_free()
	pass # Replace with function body.

#remove if exists screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
