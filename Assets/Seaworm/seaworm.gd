extends Node3D


@onready var rand= RandomNumberGenerator.new()

@onready var word_dict = [
	"hello world",
	"wasssuppp",
	"f chat gpt"
]

enum Difficulty { EASY, MEDIUM, HARD }

@export var difficulty: Difficulty = Difficulty.EASY


@onready var easy_words = [
	"cat", "dog", "sun", "map", "run", "book", "pen", "red", "blue", "hat",
	"fish", "rain", "bird", "milk", "tree", "wind", "snow", "rock", "home", "fire"
]

@onready var medium_words = [
	"planet", "forest", "rocket", "animal", "puzzle", "whisper", "jungle", "freedom", 
	"danger", "thought", "magnet", "journey", "blanket", "crystal", "balance", 
	"midnight", "gateway", "rebound", "sunlight", "harvest"
]

@onready var hard_phrases = [
	"the quick brown fox jumps over the lazy dog",
	"whispers of the wind echoed through the canyon",
	"never trust a smiling cat with glowing eyes",
	"coding is easier when the coffee is strong",
	"she danced like nobody was watching at all",
	"words are magic spells in the right hands",
	"ghosts are real and they live in the code",
	"sunsets are proof that endings can be beautiful",
	"type fast, stay sharp, and never look back",
	"embrace the chaos and type your way out"
]


@onready var phrase=""

@onready var anim_player=$WormAnims
@onready var prev_state=""
@onready var next_state="Idle"
@onready var curr_state=""
@onready var dead=false

func _process(delta: float) -> void:
	prev_state = curr_state
	curr_state = next_state
	
	match curr_state:
		"Idle":
			if curr_state!=prev_state:
				$WormAnims.play("Idle")

		"Walk_to":
			if curr_state!=prev_state:
				$detectionArea/CollisionShape3D2.disabled=true
				print("WORM in attack formation")
				add_to_group("active_enemy")
				$EnemysBoard.visible=true
				get_tree().call_group("player", "engage_attack")
				anim_player.play("prepareAttack")
				KeyboardManger.initiate_attack(self,phrase)

			var player = get_tree().get_first_node_in_group("player_cart")
			print(player.global_transform.origin)
			var direction = global_transform.origin.move_toward(Vector3(player.global_transform.origin.x,0,player.global_transform.origin.y), 0.4 * delta)
			global_transform.origin = direction
			
		"Attack":
			if curr_state!=prev_state:
				print("entering attack state")
				anim_player.play("attack")
		
		"Die":
			if curr_state!=prev_state:
				dead=true
				$EnemysBoard.visible=false
				$Attackarea/CollisionShape3D.disabled=true
				print("entering death state")
				remove_from_group("active_enemy")
				get_tree().call_group("player", "finish_attack")
				anim_player.play("Die")


func _ready() -> void:
	add_to_group("enemy")
	$EnemysBoard.visible=false
	
	
	
	match difficulty:

		Difficulty.EASY:
			print("getting to the easy part")
			var rand_num = rand.randi_range(0,len(easy_words)-1)
			phrase = easy_words[rand_num]
			$EnemysBoard/SubViewport/RichTextLabel.add_text(phrase)
	
		Difficulty.MEDIUM:
			var rand_num = rand.randi_range(0,len(medium_words)-1)
			phrase = medium_words[rand_num]
			$EnemysBoard/SubViewport/RichTextLabel.add_text(phrase)

		Difficulty.HARD:
			var rand_num = rand.randi_range(0,len(hard_phrases)-1)
			phrase = hard_phrases[rand_num]
			$EnemysBoard/SubViewport/RichTextLabel.add_text(phrase)
			
#print the red for whats typed 
#and the green for wha we gotta type
#subrtactificate from the two words basically 
func update_word(word):
	$EnemysBoard/SubViewport/RichTextLabel.text=word

func smack_player():
	get_tree().call_group("player", "take_damage")




func _on_detection_area_area_entered(area: Area3D) -> void:
	if dead==false:
		if area.is_in_group("player_area"):
			next_state="Walk_to"


func _on_attackarea_area_entered(area: Area3D) -> void:
	print("hitting the area!!!!!!!!!!!!!")
	if dead==false:
		if area.is_in_group("player_area"):
			print("gettting here")
			next_state="Attack"
