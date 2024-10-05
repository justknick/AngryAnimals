extends Area2D

@onready var splash_audio: AudioStreamPlayer2D = $SplashAudio


func _on_body_entered(_body: Node2D) -> void:
	splash_audio.play()
