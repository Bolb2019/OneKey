extends Control

func _ready() -> void:
	Lobby.host_game()
	%Name.text = Lobby.player_name
	%Name.text_changed.connect(Lobby.update_name)

func _on_exit_button_pressed() -> void:
	Lobby.leave_game()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")

func _on_ip_button_pressed() -> void:
	$VBoxContainer/HBoxContainer/IPButton/Label.text = str(get_local_ip())

func _on_play_button_pressed() -> void:
	Lobby.start_game.rpc()

func get_local_ip() -> String:
	var addresses = IP.get_local_addresses()
	for ip in addresses:
		# Filter for typical IPv4 local network configurations
		if ip.begins_with("192.168.") or ip.begins_with("10."):
			return ip
	return "No local IP found"
