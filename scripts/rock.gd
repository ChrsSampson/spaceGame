extends Area2D

@export var speed:float = 1
@export var health:int = 1
var direction = Vector2.ZERO
var target_varience = 1000
var rotation_rate:int
var spawn_area:Area2D
@onready var sprite = $Sprite2D
@onready var collider = $Collider

var player_position:Vector2 = Vector2.ZERO

# default behaivor
	# random speed
	# travels at a random point around the player
	# random rotation
	# breaks apart when shot

func _ready() -> void:
#	randomize seed for generators
	randomize()
	
#	figure out what we are aiming at
	var player = get_tree().get_first_node_in_group("player")
	if player_position == Vector2.ZERO:
		player_position = player.global_position
	
#	Generate random stats
	set_random_speed()
	set_random_rotation()
	set_random_target(player_position)

	pass


func _process(delta: float) -> void:
	#var velocity = direction  * speed
	#position += velocity * delta
#
##	spin sprite and collision as one
	#sprite.rotation += rotation_rate * delta
	#collider.rotation += rotation_rate * delta
	pass

func _physics_process(delta: float) -> void:
	var velocity = direction  * speed
	position += velocity * delta

#	spin sprite and collision as one
	sprite.rotation += rotation_rate * delta
	collider.rotation += rotation_rate * delta

#-------------------------random state generators--------------------------

#sets speed to random int
func set_random_speed() -> void:
	speed = randf_range(-2.4, 2.4)

#applies varience to the direction based around the players current location
func set_random_target(base:Vector2) -> void:
	var v = randf_range(-1000, 1000)
	
	var b = Vector2(base.x + v, base.y + v)
	
	direction = global_transform.basis_xform(b)

func set_random_rotation() -> void:
	rotation_rate = randf_range(0.25,2)

func set_random_scale() -> void:
	var s = randf_range(0.5,2)
	scale = Vector2(s,s)

#--------------------------kill off screen-----------------------
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass
	

#------------------Collision Behavior--------------------
func _on_body_entered(body: Node2D) -> void:
#	kill player
	print(body)

	if body.is_in_group("player"):
		if body.has_method("die"):
			body.take_damage(1)
	
	elif body.is_in_group("bullet"):
		print('bullet hit')
		queue_free();
		
#	rocks bounce off each other
#	invert direction
	
	pass # Replace with function body.

#-----------------Area Collision Detection------------------
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		queue_free()
	
	elif area.is_in_group("rock"):
		if direction.x > direction.y:
			direction.x *= -1
		else:
			direction.y *= -1

#--------------getters and setters--------------

func set_player_position(p:Vector2) -> void:
	player_position = p
