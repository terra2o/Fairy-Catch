extends Node

@onready var track1 = $Track1
@onready var track2 = $Track2

func _ready():
	track1.play()
	track1.connect("finished", Callable(self, "_on_track1_finished"))
	track2.connect("finished", Callable(self, "_on_track2_finished"))

func _on_track1_finished():
	await get_tree().create_timer(1.0).timeout
	track2.play()

func _on_track2_finished():
	await get_tree().create_timer(1.0).timeout
	track1.play()
