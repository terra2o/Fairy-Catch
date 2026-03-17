extends Node

@onready var sfx_player = $SFXPlayer

func _ready():
	sfx_player.bus = "EffectSFX"

func play_collect_sound():
	sfx_player.stream = preload("res://assets/sound_effect.wav")
	sfx_player.play()

func play_button_click():
	sfx_player.stream = preload("res://assets/sound_effect.wav")
	sfx_player.play()
