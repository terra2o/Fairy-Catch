extends Button

var difficulty_dialog = preload("res://scenes/DifficultyDialog.tscn")

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var dialog = difficulty_dialog.instantiate()
	add_child(dialog)
	dialog.difficulty_selected.connect(_on_difficulty_selected)
	dialog.popup_centered()

func _on_difficulty_selected(difficulty: int):
	DifficultyManager.set_difficulty(difficulty)
	print("Difficulty set to: ", DifficultyManager.Difficulty.keys()[difficulty])
