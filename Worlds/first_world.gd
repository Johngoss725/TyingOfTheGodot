extends Node3D


@export var speed = 0.05

@onready var player_cart=$PlayerPath/PlayerCart

func _ready() -> void:
	print("looking good ")

func _process(delta: float) -> void:
	player_cart.progress_ratio+=delta*speed
