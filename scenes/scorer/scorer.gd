extends Node


var _attempts: int = 0
var _total_cups: int = 0
var _cups_landed: int = 0
var _level_number: int = 0

#var _points: int = 0


func _ready() -> void: 
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_level_number = ScoreManager.get_level_selected()
	SignalManager.on_player_attempt.connect(on_player_attempt)
	SignalManager.on_player_landed.connect(on_player_landed)


func on_player_attempt() -> void: 
	_attempts += 1
	SignalManager.on_score_update.emit(_attempts)


func on_player_landed() -> void:
	_cups_landed += 1 
	if _cups_landed == _total_cups:
		#insert end screen 
		SignalManager.on_level_complete.emit()
		ScoreManager.set_score(_attempts, str(_level_number))
