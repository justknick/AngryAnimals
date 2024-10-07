extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	#SignalManager.on_player_landed.connect(on_player_landed)
	pass


func vanish_cup() -> void: 
	animation_player.play("vanish")


func on_player_landed() -> void: 
	vanish_cup()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	SignalManager.on_player_landed.emit()
	#print("emit on_player_landed")
	queue_free()
