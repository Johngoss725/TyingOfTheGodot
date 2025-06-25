extends Node3D

@export var speed = 0.05

@onready var player_cart=$PlayerPath/PlayerCart

func _ready() -> void:
	add_to_group("player")

@onready var prev_state=""
@onready var next_state="advance"
@onready var curr_state=""

func _process(delta: float) -> void:
	prev_state = curr_state
	curr_state = next_state
	
	match curr_state:
		"advance":
			player_cart.progress_ratio+=delta*speed
			
		"engage":
			pass
			

func finish_attack():
	print("finishing attack")
	next_state = "advance"


func _on_player_area_area_entered(area: Area3D) -> void:
	if area.owner.is_in_group("enemy"):
		area.owner.next_state="Walk_to"
		next_state="engage"
