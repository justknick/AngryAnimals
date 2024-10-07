extends Node

const SAVE_DATA = "user://animals.json" 
const DEFAULT_SCORE: int = 999

var _level_selected: int = 0
var _level_scores: Dictionary = {}


func _ready() -> void:
	load_file()


func check_and_add_key(level: String) -> void: 
	if _level_scores.has(level) == false:
		_level_scores[level] = DEFAULT_SCORE


func set_level_selected(ls: int) -> void: 
	_level_selected = ls


func get_level_selected() -> int:
	if _level_selected == 0:
		print("error : selected level 0")
	return _level_selected


func set_score(score: int, level: String) -> void:
	check_and_add_key(level)
	# update high score 
	if _level_scores[level] > score: 
		_level_scores[level] = score
		save_file()


func get_best_level_score(level: String) -> int: 
	check_and_add_key(level)
	return _level_scores[level]


func save_file() -> void: 
	# we will write/create a save data 
	var file = FileAccess.open(SAVE_DATA, FileAccess.WRITE)
	# turn the _level_script dictionary into a json file (serialization) 
	var score_json_str = JSON.stringify(_level_scores)
	# store the json file as a string
	file.store_string(score_json_str)
	file.close()
	print("File saved. ")


func load_file() -> void: 
	var file = FileAccess.open(SAVE_DATA, FileAccess.READ)
	if file == null:
		print("No save file found. Creating a new save file. ")
		save_file()
	else:
		# access save, grab json file as a string
		var data = file.get_as_text()
		# convert json string into dictionary via parse (deserialization)
		_level_scores = JSON.parse_string(data)
