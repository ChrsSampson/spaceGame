extends Area2D

@onready var display_name = $DisplayName
@onready var body = $Sprite2D
@onready var hint = $Hint

var name_collection:Array = []
var planet_name:String = "Arron"

signal player_docked(status:bool, planet:Area2D)

func _ready() -> void:
	randomize()
	name_collection = read_json("res://data/planets.json")["planet_names"]
	var rn = name_collection[get_random_index(len(name_collection) -1)]
	set_planet_name(rn)
	var rc = get_random_color()
	set_planet_color(rc)
	pass

#---------- Random Stat Generators -------------------

func get_random_index(max:int = 10) -> int:
	var r = randi_range(0, max)
	return r

func get_random_color() -> Color:
	return Color(randf(), randf(), randf(), 1.0)  # RGB with full alpha

#----- read planet names from json ---------------------

func read_json(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Failed to open file: ", file_path)
		return {}

	var content = file.get_as_text()  # Read file as a string
	var json = JSON.new()
	var parsed_data = json.parse_string(content)
	
	if parsed_data is Dictionary:
		return parsed_data
	else:
		print("Failed to parse JSON")
		return {}
	
	
#------------Collision---------------

#kills anything that gets too close to planet
func _on_safe_zone_area_entered(area: Area2D) -> void:
	if !area.is_in_group('planet'):
		area.queue_free()

#allow player to enter store and disable weapons
func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_docked.emit(true, self)
		hint.visible = true
	pass # Replace with function body.


func _on_safe_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_docked.emit(false, null)
		hint.visible = false
	pass # Replace with function body.



#---------------Getters and Setters-----------------

func get_planet_name() -> String:
	return self.planet_name

func set_planet_name(name:String) -> void:
	planet_name = name
	display_name.text = planet_name

func set_planet_color(color: Color) -> void:
	body.modulate = color
	pass
