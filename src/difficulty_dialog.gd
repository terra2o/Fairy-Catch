extends AcceptDialog

signal difficulty_selected(difficulty)

func _ready():
	$VBoxContainer/EASY.pressed.connect(_on_difficulty_pressed.bind(DifficultyManager.Difficulty.EASY))
	$VBoxContainer/NORMAL.pressed.connect(_on_difficulty_pressed.bind(DifficultyManager.Difficulty.NORMAL))
	$VBoxContainer/HARD.pressed.connect(_on_difficulty_pressed.bind(DifficultyManager.Difficulty.HARD))
	$VBoxContainer/VERYHARD.pressed.connect(_on_difficulty_pressed.bind(DifficultyManager.Difficulty.VERY_HARD))	
	get_ok_button().hide()

func _on_difficulty_pressed(difficulty: int):
	difficulty_selected.emit(difficulty)
	hide()


func _on_easy_pressed() -> void:
	SFXManager.play_collect_sound()


func _on_normal_pressed() -> void:
	SFXManager.play_collect_sound()


func _on_hard_pressed() -> void:
	SFXManager.play_collect_sound()


func _on_veryhard_pressed() -> void:
	SFXManager.play_collect_sound()
