extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

var connected_peer_ids=[]

func _on_host_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	_add_player(1)
	multiplayer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)# this be calling up everone!!!
			rpc_id(new_peer_id,"add_previously_connected_player_characters", connected_peer_ids)#this calls one instance of rpc
			_add_player(new_peer_id)
	)

@rpc
func add_newly_connected_player_character(new_peer_id):
	_add_player(new_peer_id)
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		_add_player(peer_id)
	
func _add_player(peer_id):
	connected_peer_ids.append(peer_id)
	var player = player_scene.instantiate()
	player.name = str(peer_id)#this is not in ditzy ninja tutorial 
	#print("Name: ",player.name)
	player.set_multiplayer_authority(peer_id)
	#add_child(player)
	call_deferred("add_child", player, true)

func _on_join_pressed() -> void:
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer

func _on_start_round_pressed() -> void:
	print("yo")
	
