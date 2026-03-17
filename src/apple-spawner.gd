extends Node

@export var apple_scene : PackedScene
@export var spawn_interval : float = 0.7
@export_group("Spawn Points")
@export var spawn_points : Array[Marker2D]

var timer : float = 0.0

func _ready():
	DifficultyManager.difficulty_changed.connect(update_difficulty_settings)
	
	update_difficulty_settings()

func update_difficulty_settings():
	if DifficultyManager and DifficultyManager.settings.has(DifficultyManager.current_difficulty):
		var settings = DifficultyManager.settings[DifficultyManager.current_difficulty]
		if settings.has("spawn_speed"):
			spawn_interval = settings["spawn_speed"]
			print("Spawn interval updated to: ", spawn_interval)

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		_spawn_apple()

func _spawn_apple():
	if apple_scene == null or spawn_points.is_empty():
		return
	var valid_markers = spawn_points.filter(func(m): return m != null)
	if valid_markers.is_empty():
		return
		
	var random_marker = valid_markers[randi() % valid_markers.size()]
	
	var apple = apple_scene.instantiate()
	apple.global_position = random_marker.global_position
	call_deferred("add_child", apple)
