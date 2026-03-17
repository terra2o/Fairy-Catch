extends Area2D

var fall_speed = 110

func _ready():
	if DifficultyManager:
		if DifficultyManager.has_signal("difficulty_changed"):
			DifficultyManager.difficulty_changed.connect(update_difficulty_settings)
		update_difficulty_settings()
	
	print("Apple created with fall speed: ", fall_speed)
	
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	set_physics_process(true)

func update_difficulty_settings():
	if DifficultyManager:
		if DifficultyManager.settings.has(DifficultyManager.current_difficulty):
			var diff_settings = DifficultyManager.settings[DifficultyManager.current_difficulty]
			if diff_settings.has("apple_fall_speed"):
				fall_speed = diff_settings["apple_fall_speed"]
				print("Apple difficulty updated: ", fall_speed)
			else:
				push_error("Missing 'apple_fall_speed' in difficulty settings")
		else:
			push_error("Missing settings for difficulty level: ", DifficultyManager.current_difficulty)
	else:
		push_error("DifficultyManager not found!")

func _on_body_entered(_body):
	if has_node("/root/GameManager"):
		get_node("/root/GameManager").add_point()
	
	SFXManager.play_collect_sound()
	queue_free()

func _physics_process(delta):
	position.y += fall_speed * delta
	if global_position.y > get_viewport_rect().size.y - 600:
		EventBus.apple_missed.emit()
		queue_free()
