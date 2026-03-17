extends CharacterBody2D

var BASE_SPEED = 180  # this will be overwritten in update_difficulty_settings()
var BOOST_SPEED = 360 # this too
const JUMP_VELOCITY = 0
const MAX_STAMINA = 100.0
const STAMINA_DRAIN = 10  # per second
const STAMINA_RECOVER = 2  # per second

var stamina = MAX_STAMINA
var is_boosting = false

func update_difficulty_settings():
	BASE_SPEED = DifficultyManager.settings[DifficultyManager.current_difficulty]["player_speed"]
	BOOST_SPEED = DifficultyManager.settings[DifficultyManager.current_difficulty]["boost_speed"]


@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	update_difficulty_settings()
	EventBus.apple_missed.connect(_on_apple_missed)
	add_to_group("player")
	set_collision_mask_value(1, false)  
	await get_tree().create_timer(0.1).timeout  
	set_collision_mask_value(1, true)
	EventBus.game_over.connect(_on_game_over)

func _on_game_over():
	var current_diff = DifficultyManager.current_difficulty
	if GameManager.score > GameManager.get_high_score(current_diff):
		GameManager.high_scores[current_diff] = GameManager.score
		GameManager.save_high_scores()
	get_tree().change_scene_to_file("res://main_menu.tscn")
func _on_apple_missed():
	var current_diff = DifficultyManager.current_difficulty
	if GameManager.score > GameManager.get_high_score(current_diff):
		GameManager.high_scores[current_diff] = GameManager.score
		GameManager.save_high_scores()
	GameManager.reset_game()
	
func _process(_delta: float) -> void:
	if is_boosting:
		var ghost: AnimatedSprite2D = $AnimatedSprite2D.duplicate()
		ghost.position = $AnimatedSprite2D.global_position
		ghost.animation = $AnimatedSprite2D.animation
		ghost.frame = $AnimatedSprite2D.frame
		ghost.flip_h = $AnimatedSprite2D.flip_h
		ghost.flip_v = $AnimatedSprite2D.flip_v

		ghost.modulate = Color(1, 1, 1, 0.1)
		get_parent().add_child(ghost)

		var start_color = ghost.modulate
		var end_color = Color(start_color.r, start_color.g, start_color.b, 0.0)

		var tween = create_tween()
		tween.tween_property(ghost, "modulate", end_color, 0.3) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN)
		tween.finished.connect(Callable(ghost, "queue_free"))
	else:
		var ghost: AnimatedSprite2D = $AnimatedSprite2D.duplicate()
		ghost.position = $AnimatedSprite2D.global_position
		ghost.animation = $AnimatedSprite2D.animation
		ghost.frame = $AnimatedSprite2D.frame
		ghost.flip_h = $AnimatedSprite2D.flip_h
		ghost.flip_v = $AnimatedSprite2D.flip_v

		ghost.modulate = Color(1, 1, 1, 0.05)
		get_parent().add_child(ghost)

		var start_color = ghost.modulate
		var end_color = Color(start_color.r, start_color.g, start_color.b, 0.0)

		var tween = create_tween()
		tween.tween_property(ghost, "modulate", end_color, 0.1) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN)
		tween.finished.connect(Callable(ghost, "queue_free"))

func _physics_process(delta: float) -> void:
	# Visual feedback
	if is_boosting:
		animated_sprite.modulate = Color(1, 0.8, 0.8)
	else:
		animated_sprite.modulate = Color.WHITE
		
	if Input.is_action_pressed("boost") and stamina > 0 and is_on_floor():
		is_boosting = true
		stamina = max(stamina - STAMINA_DRAIN * delta, 0)
	else:
		is_boosting = false
		stamina = min(stamina + STAMINA_RECOVER * delta, MAX_STAMINA)
	
	var current_movement_speed = BASE_SPEED * (BOOST_SPEED / 180 if is_boosting else 1)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_action_strength("right") - Input.get_action_strength("left")
	if direction:
		velocity.x = direction * current_movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_movement_speed)
	
	move_and_slide()
