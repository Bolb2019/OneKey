extends Control

var players: Dictionary[int, Label] = {}

func _ready() -> void:
	Lobby.player_count_updated.connect(_update_player_count)
	Lobby.player_updated.connect(_on_player_updated)
	Lobby.player_left.connect(_on_player_left)
	Lobby.server_disconnected.connect(_on_server_disconnecter)

func _process(_delta: float) -> void:
	%Self.text = Lobby.player_name

func _update_player_count(count: int) -> void:
	%PlayerCount.text = str(count)

func _on_player_updated(id: int, data: Dictionary):
	if players.has(id):
		players[id].text = data["name"]
	else:
		var label = Label.new()
		label.text = data["name"]
		players[id] = label
		%Players.add_child(label)

func _on_player_left(id: int):
	if players.has(id):
		players[id].queue_free()
		players.erase(id)

func _on_server_disconnecter():
	for player in players.values():
		player.queue_free()
	players.clear()
