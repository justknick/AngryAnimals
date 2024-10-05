extends RigidBody2D

@onready var label: Label = $Label
@onready var birdfalse: RigidBody2D = $"."


func _process(delta: float) -> void:
	label.text = "%s" % sleeping


func _on_timer_timeout() -> void:
	freeze = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.button_mask == 1:
		#print("event ", event)
		var coords = get_global_mouse_position()
		#print(coords)
		#print(str(coords.type))
		birdfalse.position = coords
		#birdfalse.glonal_position = coords

		print("coords = ", coords)
		print("bird is at ", birdfalse.position)
		print("bird is at ", birdfalse.global_position)


#func _input(event):
	#if event is InputEventMouseButton and event.pressed:
		#match event.button_index
			#MOUSE_BUTTON_LEFT:
				#print("Left mouse button")
			#MOUSE_BUTTON_WHEEL_UP:
				#print("Scroll wheel up")
			#MOUSE_BUTTON_WHEEL_DOWN:
				#print("Scroll wheel down")
