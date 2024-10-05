extends Node2D

const BIRD = preload("res://scenes/player/bird.tscn")

@export var bird_scene: PackedScene

@onready var animal_start: Marker2D = $AnimalStart


func _ready() -> void: 
	spawn_player()
	SignalManager.on_player_defeat.connect(respawn_player)


func _physics_process(_delta: float) -> void:
	pass


func spawn_player() -> void:
	var player = BIRD.instantiate()
	player.position = animal_start.position
	add_child(player)


func respawn_player() -> void:
	spawn_player()
