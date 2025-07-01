extends Node3D

@onready var fired=false
@onready var current_boss=null

func fire(boss):
	current_boss=boss
	fired=true
	
func _process(delta: float) -> void:
	if fired==true:
		var player = get_tree().get_first_node_in_group("player_cart")
		var direction = global_transform.origin.move_toward(player.global_transform.origin, 10 * delta)
		global_transform.origin = direction


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_area"):
		remove_from_group("active_fireballs")
		area.owner.take_damage()
		current_boss.fire_fireball()
		queue_free()
		
