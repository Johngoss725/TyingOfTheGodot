extends Node3D

@export var ratio = 0.12

@onready var rand= RandomNumberGenerator.new()

@onready var word_dict = [
	"hello world",
	"wasssuppp",
	"f chat gpt"
]

@onready var phrase=""


func _ready() -> void:
	add_to_group("enemy")
	$EnemysBoard/Sprite3D.visible=false
	var rand_num = rand.randi_range(0,len(word_dict)-1)
	phrase = word_dict[rand_num]
	$EnemysBoard/SubViewport/RichTextLabel.add_text(phrase)
	
func attack():
	KeyboardManger.initiate_attack(self,phrase)
	print("enemy in attack formation")
	add_to_group("active_enemy")
	$EnemysBoard/Sprite3D.visible=true
	get_tree().call_group("player", "engage_attack")

func update_rich_text_label():
	pass
#print the red for whats typed 
#and the green for wha we gotta type
#subrtactificate from the two words basically 
func update_word(word):
	$EnemysBoard/SubViewport/RichTextLabel.text=word
	
	
func defeated():
	remove_from_group("active_enemy")
	get_tree().call_group("player", "finish_attack")
