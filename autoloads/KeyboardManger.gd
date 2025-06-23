extends Node



@onready var curr_word = null
@onready var active_enemy = null

func initiate_attack(enemy, word):
	print(enemy ," : ", word )
	curr_word = word
	active_enemy = enemy

#if we type the letter we are supposed to 
#we remove that letter and continue 
#if we type the wrong letter we just contuine for now but will do damage later?

func _input(event):
	if curr_word != null:
		if event is InputEventKey and event.pressed and not event.echo:
			var scancode = event.keycode
			var char = OS.get_keycode_string(scancode)
			if scancode == 32 and curr_word[0]==" ":
				curr_word=curr_word.erase(0)
				active_enemy.update_word(curr_word)
			elif char.to_lower() == curr_word[0]:
				curr_word=curr_word.erase(0)
				active_enemy.update_word(curr_word)
			if len(curr_word)<=0:
				curr_word = null
				get_tree().call_group("active_enemy","defeated")
			
