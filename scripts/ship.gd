extends CharacterBody2D

#The UI should really be off in its own instance and then attached to the player in the level
# doing it this way requires the ui to be transformed on every frame to face the right way

#also the player should have an area around it that rocks cannot spawn in 

var bullet_scene = preload("res://entity/bullet.tscn")

#----player stats----
var health:int = 5
var speed:float = 600
var boost_speed: float = 1500
var turn_speed:float = 10
var drag:float = 10
var can_boost:bool = true
var booster_cooldown:float = 5
var fire_rate:float = 3
var can_shoot:bool = true


@onready var bullet_spawn_location = $BulletSpawn.global_position
@onready var health_bar = $UI/HealthBar
@onready var ui = $UI

func _ready() -> void:
	health_bar.value = health
	#var box = play_area.get_node("CollisionShape2D")
	#play_area_size = box.shape.get_rect().size
	pass

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		boost()

	if Input.is_action_just_pressed("shoot"):
		fire()
		pass

	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * turn_speed * delta
	position += velocity * delta

	if direction.length() > 0.0:
		rotation = velocity.angle()
		ui.rotation = velocity.angle() * -1
	
	#position.x = wrapf(position.x, 0, play_area_size.x)
	#position.x = wrapf(position.y, 0, play_area_size.y)
	pass

func _physics_process(delta: float) -> void:
	pass
	

#------------booster logic-----------------------
#activate booster
func boost() -> void:
	if can_boost:
		var booster = $BoostTimer
		speed = boost_speed
		booster.start(2)
	
#booster runs out - speed penatly while cooldown
func _on_boost_timer_timeout() -> void:
	can_boost = false
	var boosterCooldown = $BoostCooldown
	boosterCooldown.start(booster_cooldown)
	speed = 400
	
#booster off cooldown - normal speed
func _on_boost_cooldown_timeout() -> void:
	can_boost = true
	speed = 600

#---------------Fire Logic-----------------------
func fire() -> void:
	if can_shoot:
		bullet_spawn_location = $BulletSpawn.global_position
		var angle = velocity.angle()
#		setup for making the bullet
		var container = $BulletContainer
		var bullet = bullet_scene.instantiate()
		bullet.scale = Vector2(3,3)
		bullet.rotation = angle
		bullet.position = bullet_spawn_location
		container.add_child(bullet)
#		apply cooldowns
		can_shoot = false
		var fire_timer = $FireTimer
		fire_timer.start(fire_rate)

func _on_fire_timer_timeout() -> void:
	can_shoot= true

#--------------------------------UI Logic------------------
func update_health() -> void:
	health_bar.value = health

#--------------Death/Gameover--------------
func die() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
#----------------Getters and Setters----------------
func take_damage(d:int):
	health -= d
	if(health == 0):
		die()
	update_health()

func heal(h:int):
	if health < 5:
		health += h
	update_health()

#determine if point is too close to player
func is_in_black_zone(query_point:Vector2) -> bool:
	var origin = self.global_position
	var border = Vector2(origin.x + 900, origin.y + 900)
	
	var distance = ((border.x - origin.x) ** 2 + (border.y - origin.y) ** 2) ** 0.5
	
	print(distance)
	return false
