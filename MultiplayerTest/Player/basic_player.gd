extends CharacterBody2D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 100
	move_and_slide()

@onready var curr_word = null


@rpc
func update_current_word(incoming_word):
	curr_word = incoming_word

func _input(event):
	if curr_word != null:
		if event is InputEventKey and event.pressed and not event.echo:
			var scancode = event.keycode
			var char = OS.get_keycode_string(scancode)
			if scancode == 32 and curr_word[0]==" ":
				curr_word=curr_word.erase(0)
				$PlayerTypeText.text = curr_word
			elif char.to_lower() == curr_word[0]:
				curr_word=curr_word.erase(0)
				$PlayerTypeText.text = curr_word
			if len(curr_word)<=0:
				curr_word = null
				get_tree().get_first_node_in_group("active_enemy").next_state="Die"
