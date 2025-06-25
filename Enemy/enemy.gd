extends Node3D

@export var ratio = 0.12

@onready var rand= RandomNumberGenerator.new()

@onready var word_dict = [
	"hello world",
	"wasssuppp",
	"f chat gpt"
]

@onready var phrase=""

@onready var anim_player=$ZombiAnim
@onready var prev_state=""
@onready var next_state="advance"
@onready var curr_state=""

func _process(delta: float) -> void:
	prev_state = curr_state
	curr_state = next_state
	
	match curr_state:
		"Idle":
			pass

		"Walk_to":
			if curr_state!=prev_state:

					print("enemy in attack formation")
					add_to_group("active_enemy")
					$EnemysBoard/Sprite3D.visible=true
					get_tree().call_group("player", "engage_attack")
					anim_player.play("Walk")
					KeyboardManger.initiate_attack(self,phrase)
					
			var player = get_tree().get_first_node_in_group("player")
			var direction = global_transform.origin.move_toward(player.global_transform.origin, 0.4 * delta)
			global_transform.origin = direction
			
		"Attack":
			if curr_state!=prev_state:
				print("entering attack state")
				anim_player.play("attack")
		
		"Die":
			if curr_state!=prev_state:
				print("entering death state")
				remove_from_group("active_enemy")
				get_tree().call_group("player", "finish_attack")
				anim_player.play("Die")

func _ready() -> void:
	add_to_group("enemy")
	$EnemysBoard/Sprite3D.visible=false
	var rand_num = rand.randi_range(0,len(word_dict)-1)
	phrase = word_dict[rand_num]
	$EnemysBoard/SubViewport/RichTextLabel.add_text(phrase)

#print the red for whats typed 
#and the green for wha we gotta type
#subrtactificate from the two words basically 
func update_word(word):
	$EnemysBoard/SubViewport/RichTextLabel.text=word

func _on_attack_area_entered(area: Area3D) -> void:
	print("hitting the area!!!!!!!!!!!!!")
	if area.is_in_group("player_area"):
		print("gettting here")
		next_state="Attack"

func _on_detection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_area"):
		next_state="Walk_to"
