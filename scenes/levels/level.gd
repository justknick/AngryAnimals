extends Node2D

const BIRD = preload("res://scenes/player/bird.tscn")
const MAIN = preload("res://scenes/main/main.tscn")

@export var bird_scene: PackedScene

@onready var animal_start: Marker2D = $AnimalStart
@onready var launch_area: Node2D = $LaunchArea

#var cup_count: int = 3


func _ready() -> void: 
	spawn_player()
	SignalManager.on_player_defeat.connect(respawn_player)
	SignalManager.on_player_landed.connect(on_player_landed)
	SignalManager.on_drag_active.connect(on_drag_active)


func _physics_process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)


func spawn_player() -> void:
	var player = BIRD.instantiate()
	player.position = animal_start.position
	add_child(player)


func respawn_player() -> void:
	if bird_scene == null:
		spawn_player()


func on_player_landed() -> void:
	#if cup_count > 0:
		#cup_count -= 1
		#print("remaining cups: ", cup_count)
	respawn_player()


func on_drag_active(flag: bool) -> void: 
	if flag == true:
		launch_area.show()
	elif flag == false:
		launch_area.hide()
