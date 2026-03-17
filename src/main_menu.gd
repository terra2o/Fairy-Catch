extends Control


@onready var high_score_label = $HighScoreLabel
var difficulty_dialog = preload("res://scenes/DifficultyDialog.tscn")

func _ready():
	GameManager.load_high_scores()
	update_high_score_display()
	DifficultyManager.connect("difficulty_changed", Callable(self, "_on_difficulty_changed"))

	$Title.text = "Fairy Catch"
	$Title.add_theme_font_size_override("font_size", 72)

func update_high_score_display():
	if high_score_label:
		var display_names = {
			DifficultyManager.Difficulty.EASY: "Easy",
			DifficultyManager.Difficulty.NORMAL: "Normal", 
			DifficultyManager.Difficulty.HARD: "Hard",
			DifficultyManager.Difficulty.VERY_HARD: "Very Hard"
		}
		
		var all_scores_text = ""
		for difficulty in DifficultyManager.Difficulty.values():
			var score = GameManager.get_high_score(difficulty)
			all_scores_text += "%s: %d\n" % [display_names[difficulty], score]
		
		high_score_label.text = "HIGH SCORES:\n" + all_scores_text
	else:
		push_error("HighScoreLabel not found!")

func _on_difficulty_changed():
	update_high_score_display()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	SFXManager.play_collect_sound()
		
func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	SFXManager.play_collect_sound()	

var is_muted = false

func _on_mute_music_pressed() -> void:
	SFXManager.play_collect_sound()	
	var bus_index = AudioServer.get_bus_index("Music")
	var current_state = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !current_state)

func _on_mute_sfx_pressed() -> void:
	var bus_index = AudioServer.get_bus_index("EffectSFX")
	var current_state = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !current_state)

func _on_difficulty_pressed() -> void:
	SFXManager.play_collect_sound()


func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/help.tscn")
	SFXManager.play_collect_sound()
