extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var playerScene: PackedScene
@onready var spawn := $Mapa1/Spawn
@onready var lobby := $LOBBY

func _on_host_pressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_on_peer_connected)

	# Spawn do host
	_on_peer_connected(multiplayer.get_unique_id())

	lobby.hide()
	print("HOST READY:", multiplayer.get_unique_id())

func _on_join_pressed():
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
	lobby.hide()
	print("CLIENT READY:", multiplayer.get_unique_id())

func _on_peer_connected(id: int):
	if not multiplayer.is_server():
		return

	print("SPAWNING PLAYER:", id)

	var player = playerScene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)

	add_child(player)

	player.rpc("rpc_apply_spawn", spawn.global_transform)
