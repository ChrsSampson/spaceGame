extends Area2D

@export var speed:float = 2
@export var health:int = 1
var direction = Vector2.ZERO
var target_varience = 1000
var rotation_rate:int
var spawn_area:Area2D
@onready var sprite = $Sprite2D
@onready var collider = $Collider

# default behaivor
	# random speed
	# travels at a random point around the player
	# random rotation
	# breaks apart when shot

func _ready() -> void:
	randomize()
	var player = get_tree().get_first_node_in_group("player").global_position
	position = Vector2(0,0)
	set_random_speed()
	set_random_rotation()
	set_random_location()
	set_random_target(player)
	pass


func _process(delta: float) -> void:
	var velocity = direction  * speed
	position += velocity * delta

#	spin sprite and collision as one
	sprite.rotation += rotation_rate * delta
	collider.rotation += rotation_rate * delta



#-------------------------random state generators--------------------------

#sets speed to random int
func set_random_speed() -> void:
	speed = randf_range(0,5)

#applies varience to the direction based around the players current location
func set_random_target(base:Vector2) -> void:
	direction = global_transform.basis_xform(base)
	
func set_random_location() -> void:
	var box = spawn_area.get_node("CollisionShape2D")
	var view = get_viewport().size #get area of view
	var outside = box.shape.get_rect().size
	print(outside)
	var rx = randi_range(view.x, outside.x)
	var ry =  randi_range(view.y, outside.y)
	global_position = Vector2(rx,ry)
	pass

func set_random_rotation() -> void:
	rotation_rate = randf_range(0.25,2)

func set_random_scale() -> void:
	var s = randi_range(1,4)
	scale = Vector2(s,s)

#--------------------------kill off screen-----------------------
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass
	

#------------------Collision Behavior--------------------
func _on_body_entered(body: Node2D) -> void:
#	kill player
	if body.is_in_group("player"):
		if body.has_method("die"):
			body.die()
	
	if body.is_in_group("bullet"):
		queue_free();
		
#	rocks bounce off each other
#	invert direction
	if body.is_in_group("rock"):
		if direction.x > direction.y:
			direction.x *= -1
		else:
			direction.y *= -1
	pass # Replace with function body.

#--------------getters and setters--------------

func set_spawn_area(area:Area2D) -> void:
	spawn_area = area
	pass
