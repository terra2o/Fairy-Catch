extends Control

@onready var game = $"../../"

func _on_resume_pressed():
	game.pauseMenu()
	SFXManager.play_collect_sound()


func _on_touch_resume_button_pressed():
	game.pauseMenu()
	SFXManager.play_collect_sound()
