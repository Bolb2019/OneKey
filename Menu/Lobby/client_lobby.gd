extends Control

const link_off_icon = preload("res://assets/link_off.png")
const link_icon = preload("res://assets/link.png")

var connected = false

func _ready() -> void:
	Lobby.server_connection_failed.connect(_on_connect_failed)
	Lobby.server_connected.connect(_on_connected)
	%Name.text = Lobby.player_name
	%Name.text_changed.connect(Lobby.update_name)

func _on_connect_button_pressed() -> void:
	if connected:
		Lobby.leave_game()
		connected = false
		%ConnectButton.icon = link_icon
	else:
		if not Lobby.join_game(%IP.text):
			%ConnectButton.disabled = true

func _on_connect_failed() -> void:
	%ConnectButton.disabled = false
	print("connect failed")

func _on_connected() -> void:
	connected = true
	%ConnectButton.disabled = false
	%ConnectButton.icon = link_off_icon
	print("connected")

func _on_exit_button_pressed() -> void:
	Lobby.leave_game()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
