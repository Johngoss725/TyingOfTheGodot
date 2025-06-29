extends Node3D

@export var speed = 0.01

@onready var player_cart=$PlayerPath/PlayerCart

func _ready() -> void:
	add_to_group("player")
	for i in range(health):
		var textureRect = TextureRect.new()
		#var  textureRect = use_textureRect.instantiate()
		textureRect.texture=load("res://UI_Images/myimag.png")
		textureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_IGNORE_SIZE)

		textureRect.custom_minimum_size = Vector2(40,40)
		$PlayerPath/PlayerCart/Camera3D/Control/HeartHolder/HBoxContainer.add_child(textureRect)

@onready var dead=false
@onready var prev_state=""
@onready var next_state="advance"
@onready var curr_state=""

func _process(delta: float) -> void:
	prev_state = curr_state
	curr_state = next_state
	
	match curr_state:
		"advance":
			player_cart.progress_ratio+=delta*speed
			$PlayerPath/PlayerCart/Camera3D.rotation_degrees.y = 0
			
		"engage":
			if curr_state!=prev_state:
				$PlayerPath/PlayerCart/Look_At.look_at(current_enemy.global_transform.origin, Vector3.UP)
				$PlayerPath/PlayerCart/Camera3D.rotation.y = $PlayerPath/PlayerCart/Look_At.rotation.y
			
		"hurt":
			if curr_state!=prev_state:

				$PlayerPath/PlayerCart/Camera3D/Control/UIAnimPlayer.play("FlashOverlay")
				health-=1
				if health<=0:
					dead=true
					
					next_state="death"

				for children in $PlayerPath/PlayerCart/Camera3D/Control/HeartHolder/HBoxContainer.get_children():
					children.queue_free()

				for i in range(health):
					var textureRect = TextureRect.new()
					#var  textureRect = use_textureRect.instantiate()
					textureRect.texture=load("res://UI_Images/myimag.png")
					textureRect.custom_minimum_size = Vector2(40,40)
					textureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_IGNORE_SIZE)
					$PlayerPath/PlayerCart/Camera3D/Control/HeartHolder/HBoxContainer.add_child(textureRect)
				next_state="engage"

		"death":
			if curr_state!=prev_state:
				print("getting here")
				$PlayerPath/PlayerCart/CamAnims.play("scan")
				$PlayerPath/PlayerCart/SecondaryCam.current=true
			
			

func finish_attack():
	print("finishing attack")
	next_state = "advance"

@onready var health = 5

func take_damage():
	if dead==false:
		next_state="hurt"

	

@onready var current_enemy=null
func _on_player_area_area_entered(area: Area3D) -> void:
	if area.owner.is_in_group("enemy"):
		if area.owner.dead==false:
			area.owner.next_state="Walk_to"
		next_state="engage"
		current_enemy=area.owner


func _on_cam_anims_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"scan":
			get_tree().change_scene_to_packed(load("res://Worlds/game_over.tscn"))
