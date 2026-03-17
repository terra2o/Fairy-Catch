# GameManager.gd
extends Node

var score := 0
var high_scores := {}
const SAVE_PATH := "user://highscores.save"
var hud_path = "/root/Game/HUD"

func _ready():
	load_high_scores()
	# initialize default high scores if they don't exist
	for difficulty in DifficultyManager.Difficulty.values():
		if not high_scores.has(difficulty):
			high_scores[difficulty] = 0

func add_point():
	score += 1
	EventBus.score_updated.emit(score)
	var hud = get_node_or_null(hud_path)
	if hud:
		hud.update_score(score)
	else:
		printerr("HUD not found at path: ", hud_path)
		
func save_high_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(high_scores)
	else:
		push_error("Failed to save high scores!")

func load_high_scores():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if typeof(loaded_data) == TYPE_DICTIONARY:
				high_scores = loaded_data
			else:
				high_scores = {}
				printerr("Invalid high scores data format - resetting")
		else:
			high_scores = {}
			push_error("Failed to load high scores!")
	else:
		high_scores = {}
		
func reset_game():
	# update high score for current difficulty if current score is higher
	var current_diff = DifficultyManager.current_difficulty
	if score > high_scores.get(current_diff, 0):
		high_scores[current_diff] = score
		save_high_scores()
	
	score = 0
	EventBus.score_updated.emit(0)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func get_high_score(difficulty: int) -> int:
	return high_scores.get(difficulty, 0)
