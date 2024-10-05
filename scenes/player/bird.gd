extends RigidBody2D

@onready var state_label: Label = $StateLabel
@onready var bird: RigidBody2D = $"."

enum PLAYER_STATE {READY, DRAG, RELEASE}

var _state: PLAYER_STATE = PLAYER_STATE.READY


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	state_listener(delta)
	state_label.text = "%s" % PLAYER_STATE.keys()[_state]


func state_listener(_delta: float) -> void: 
	match _state:
		PLAYER_STATE.DRAG:
			drag_state_action()
		PLAYER_STATE.RELEASE:
			# in release state, do nothing
			pass


func drag_state_action() -> void: 
	# checks if mouse is released 
	if detect_action_release() == true:
		set_new_state(PLAYER_STATE.RELEASE) 
	
	var mouse_position = get_global_mouse_position()
	bird.position = mouse_position


func detect_action_release() -> bool:
	if _state == PLAYER_STATE.DRAG:
		if Input.is_action_just_released("drag") == true:
			return true
	return false


func set_new_state(new_state: PLAYER_STATE) -> void:
	_state = new_state
	if _state == PLAYER_STATE.RELEASE:
		print("player state: ", _state)
		freeze = false
	elif _state == PLAYER_STATE.DRAG:
		# we are not changing any properties in drag state
		print("player state: ", _state)
		pass


func defeat() -> void: 
	queue_free()


func _on_player_screen_exited() -> void:
	SignalManager.on_player_defeat.emit()
	defeat()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print(event)
	#if _state == PLAYER_STATE.READY && event.button_mask == 1:
		#print("drag pressed")
		#set_new_state(PLAYER_STATE.READY)
	
	if _state == PLAYER_STATE.READY && Input.is_action_pressed("drag"):
		set_new_state(PLAYER_STATE.DRAG)
