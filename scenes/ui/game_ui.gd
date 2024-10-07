extends Control

const MAIN: PackedScene = preload("res://scenes/main/main.tscn")

@onready var level_value: Label = %LevelValue
@onready var attempt_value: Label = %AttemptValue
@onready var complete: VBoxContainer = %Complete
@onready var complete_sound: AudioStreamPlayer = $CompleteSound


func _ready() -> void:
	level_value.text = str(ScoreManager.get_level_selected())
	update_attempt(0)
	SignalManager.on_score_update.connect(update_attempt)
	SignalManager.on_level_complete.connect(on_level_complete)


func _process(delta: float) -> void:
	space_input()


func update_attempt(attempt: int) -> void: 
	attempt_value.text = str(attempt)


func space_input() -> void:
	if Input.is_action_just_pressed("menu") && complete.visible == true:
		get_tree().change_scene_to_packed(MAIN)


func on_level_complete() -> void:
	complete.show()
	complete_sound.play()
