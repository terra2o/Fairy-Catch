extends Node2D

@onready var pause_menu = $Camera2D/PauseMenu

var paused = false

func _ready():
	$Camera2D.make_current()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func _on_pause_button_pressed():
	var esc_event = InputEventKey.new()
	esc_event.keycode = KEY_ESCAPE
	esc_event.pressed = true
	Input.parse_input_event(esc_event)
	
	await get_tree().create_timer(0.1).timeout
	
	esc_event.pressed = false
	Input.parse_input_event(esc_event)
	
