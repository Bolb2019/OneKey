extends Node

const PORT = 23942

var player_name = "Player"

signal player_count_updated(players: int)
signal player_updated(id: int, data: Dictionary)
signal player_left(id: int)
signal player_died(id: int)
signal score_updated(id: int, score: int)
signal server_connected
signal server_connection_failed
signal server_disconnected

## { "name": "meow", "velocity": Vector2, "position": Vector2, "rotation": 0.0 }
## does not include self
var players: Dictionary[int, Dictionary] = {}

var game_started := false

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_server_connected)
	multiplayer.connection_failed.connect(server_connection_failed.emit)
	multiplayer.server_disconnected.connect(server_disconnected.emit)

func host_game():
	game_started = false
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	_update_player_count()

func join_game(ip: String):
	game_started = false
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func leave_game() -> void:
	game_started = false
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	_update_player_count()

func update_name(new_name: String):
	player_name = new_name
	var data = { "name": player_name, "velocity": Vector2.ZERO, "position": Vector2.ZERO, "rotation": 0.0 }
	update_data.rpc(multiplayer.get_unique_id(), data)

func _on_peer_connected(id: int):
	_update_player_count()
	var data = { "name": player_name, "velocity": Vector2.ZERO, "position": Vector2.ZERO, "rotation": 0.0 }
	update_data.rpc_id(id, multiplayer.get_unique_id(), data)
	if multiplayer.is_server() and game_started:
		start_game.rpc_id(id)

func _on_peer_disconnected(id: int):
	players.erase(id)
	_update_player_count()
	player_left.emit(id)

func _on_server_connected():
	server_connected.emit()
	_update_player_count()

func _update_player_count():
	var count = multiplayer.get_peers().size() + 1
	player_count_updated.emit(count)

@rpc("call_local")
func start_game():
	game_started = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")

@rpc("any_peer", "unreliable_ordered")
func update_data(id: int, data: Dictionary):
	players[id] = data
	player_updated.emit(id, data)

@rpc("any_peer", "call_local")
func update_score(id: int, score: int):
	if players.has(id):
		players[id]["score"] = score
		score_updated.emit(id, score)
	elif id == multiplayer.get_unique_id():
		pass

@rpc("any_peer")
func report_dead():
	var id = multiplayer.get_remote_sender_id()
	if players.has(id):
		var was_dead = players[id].get("dead", false)
		if not was_dead:
			players[id]["dead"] = true
			player_died.emit(id)

@rpc("any_peer")
func report_win():
	# TODO: dead screen
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
