extends Area2D

@export var speed:float = 900
@export var health:int = 1
var direction = Vector2.ZERO
var target_varience = 300

# default behaivor
	# random speed
	# travels at a random point around the player
	# random rotation
	# breaks apart when shot

func _ready() -> void:
	randomize()
	var player = get_tree().get_first_node_in_group("player").global_position
	set_random_location()
	set_random_target(player)
	
	pass


func _process(delta: float) -> void:
	#direction = global_transform.basis_xform(Vector2.RIGHT)
	var velocity = direction  * speed
	position += velocity * delta
	

#sets speed to random int
func set_random_speed(max:int) -> void:
	speed = randi() % 2000

#applies varience to the direction based around the players current location
func set_random_target(base:Vector2) -> void:
	var highx = base.x + target_varience
	var highy = base.y + target_varience
	var rx = randi() % int(highx)
	var ry = randi() % int(highy)
	direction = global_transform.basis_xform(Vector2(rx, ry))
	
func set_random_location() -> void:
	var view = get_viewport().size
	var rx = randi() % view.x + target_varience
	var ry =  randi() % view.y + target_varience
	global_position = Vector2(rx,ry)
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.
