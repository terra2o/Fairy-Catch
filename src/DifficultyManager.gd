# DifficultyManager.gd (autoload singleton)
extends Node

signal difficulty_changed

enum Difficulty {EASY, NORMAL, HARD, VERY_HARD}

var current_difficulty = Difficulty.NORMAL

var settings = {
	Difficulty.EASY: {
		"apple_fall_speed": 70,
		"player_speed": 175,
		"boost_speed": 390,
		"spawn_speed": 1
	},
	Difficulty.NORMAL: {
		"apple_fall_speed": 110,
		"player_speed": 180,
		"boost_speed": 360,
		"spawn_speed": 0.8
	},
	Difficulty.HARD: {
		"apple_fall_speed": 130,
		"player_speed": 200,
		"boost_speed": 400,
		"spawn_speed": 0.7
	},
	Difficulty.VERY_HARD: {
		"apple_fall_speed": 140,
		"player_speed": 220,
		"boost_speed": 420,
		"spawn_speed": 0.5
	}
}

func set_difficulty(difficulty: int):
	current_difficulty = difficulty
