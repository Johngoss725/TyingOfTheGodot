extends Node3D

@onready var fireball=load("res://Assets/Boss/BossFireball.tscn")

func _ready() -> void: 
	reload_fireballs()
	await get_tree().create_timer(3).timeout
	fire_fireball()

func reload_fireballs():
	for chilens in $OuterRing/FirballHolders.get_children():
		var fb = fireball.instantiate()
		chilens.add_child(fb)
		fb.add_to_group("active_fireballs")

#we done be firinig a single fireball
#we be waitinfg for da next one to be firin again. 
func fire_fireball():
	print("we should be firing")
	if get_tree().get_node_count_in_group("active_fireballs")>=1:
		print("we are past the if in active check")
		var fb = get_tree().get_first_node_in_group("active_fireballs")
		fb.fire(self)
	else:
		print("we are out of ammo ")
		
