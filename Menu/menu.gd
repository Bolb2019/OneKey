extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Lobby/client_lobby.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Lobby/server_lobby.tscn")
