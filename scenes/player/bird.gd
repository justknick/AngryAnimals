extends RigidBody2D

@onready var state_label: Label = $StateLabel
@onready var arrow: Sprite2D = $Arrow
@onready var arrow_sound: AudioStreamPlayer2D = $ArrowSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var impact_sound: AudioStreamPlayer2D = $ImpactSound

enum PLAYER_STATE {READY, DRAG, RELEASE}

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULTIPLIER: float = 20.0
const IMPULSE_MAX: float = 1200.0

var _state: PLAYER_STATE = PLAYER_STATE.READY
var _player_start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _drag_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO
var _sound_played: bool = false
var _arrow_scale_x: float = 0.0
var _last_collision_count: int = 0


func _ready() -> void:
	_player_start = position
	_sound_played = false
	_arrow_scale_x = arrow.scale.x


func _physics_process(delta: float) -> void:
	state_listener(delta)
	state_label.text = "%s\n" % PLAYER_STATE.keys()[_state]
	state_label.text += "%.1f, %.1f" % [_drag_vector.x, _drag_vector.y]


func state_listener(_delta: float) -> void: 
	match _state:
		PLAYER_STATE.DRAG:
			drag_state_action()
		PLAYER_STATE.RELEASE:
			update_flight()


func set_new_state(new_state: PLAYER_STATE) -> void:
	_state = new_state
	if _state == PLAYER_STATE.RELEASE:
		set_release()
	elif _state == PLAYER_STATE.DRAG:
		set_drag()


func play_collision() -> void:
	if (_last_collision_count == 0 and
		get_contact_count() > 0 and 
		impact_sound.playing == false):
		impact_sound.play()
		#print("kick ", get_contact_count())
	_last_collision_count = get_contact_count()
	#print("contact count: ", get_contact_count())


func update_flight() -> void:
	#play_collision()
	pass


func set_release() -> void:
	freeze = false
	apply_central_impulse(get_impulse())
	arrow.hide()
	launch_sound.play()
	SignalManager.on_player_attempt.emit()


func set_drag() -> void:
	arrow.show()
	_drag_start = get_global_mouse_position()


func drag_state_action() -> void: 
	# checks if mouse is released 
	if detect_action_release() == true:
		set_new_state(PLAYER_STATE.RELEASE)
	
	var mouse_position = get_global_mouse_position()
	_drag_vector = get_dragged_vector(mouse_position)
	scale_arrow()
	play_arrow_sound()
	drag_limiter()


func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start


func drag_limiter() -> void: 
	_last_dragged_vector = _drag_vector
	
	_drag_vector.x = clampf(
		_drag_vector.x, 
		DRAG_LIM_MIN.x, 
		DRAG_LIM_MAX.x
	)
	_drag_vector.y = clampf(
		_drag_vector.y, 
		DRAG_LIM_MIN.y, 
		DRAG_LIM_MAX.y
	)
	position = _player_start + _drag_vector


func scale_arrow() -> void:
	var impulse_length = get_impulse().length() 
	var percent = impulse_length / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * percent) + _arrow_scale_x
	arrow.rotation = (_player_start - position).angle()


func play_arrow_sound() -> void:
	if (_last_dragged_vector - _drag_vector).length() > 0: 
		if arrow_sound. playing == false: 
			if _sound_played == false:
				arrow_sound.play()
				_sound_played = true


func detect_action_release() -> bool:
	if _state == PLAYER_STATE.DRAG:
		if Input.is_action_just_released("drag") == true:
			SignalManager.on_drag_active.emit(false)
			return true
	return false


func get_impulse() -> Vector2:
	return _drag_vector * -1 * IMPULSE_MULTIPLIER


func defeat() -> void: 
	queue_free()
	#print("defeated")


func landed() -> void: 
	queue_free()
	#print("landed")
	


func _on_player_screen_exited() -> void:
	SignalManager.on_player_defeat.emit()
	defeat()


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	#print(event)
	if _state == PLAYER_STATE.READY && Input.is_action_pressed("drag"):
		set_new_state(PLAYER_STATE.DRAG)
		SignalManager.on_drag_active.emit(true)


func _on_sleeping_state_changed() -> void:
	if sleeping == true:
		var colliding_bodies = get_colliding_bodies()
		if colliding_bodies.size() > 0: 
			colliding_bodies[0].vanish_cup()
		call_deferred("queue_free")
		#print("landed")
		#SignalManager.on_player_landed.emit()


func _on_body_entered(_body: Node) -> void:
	if impact_sound.playing == false:
		impact_sound.play()
