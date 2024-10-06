extends Node2D

const BIRD = preload("res://scenes/player/bird.tscn")

@export var bird_scene: PackedScene

@onready var animal_start: Marker2D = $AnimalStart

var cup_count: int = 3


func _ready() -> void: 
	spawn_player()
	SignalManager.on_player_defeat.connect(respawn_player)
	SignalManager.on_player_landed.connect(on_player_landed)


func _physics_process(_delta: float) -> void:
	#respawn_player() 
	pass


func spawn_player() -> void:
	var player = BIRD.instantiate()
	player.position = animal_start.position
	add_child(player)


func respawn_player() -> void:
	if bird_scene == null:
		spawn_player()


func count_cups() -> void:
	#cup_count = get_n
	pass


func on_player_landed() -> void:
	if cup_count > 0:
		cup_count -= 1
		print("remaining cups: ", cup_count)
	respawn_player()
