extends Camera2D

@export var min_zoom := 0.2
@export var max_zoom := 1
@export var margin := 500.0
@export var move_speed := 5.0
@export var zoom_speed := 5.0

@onready var player1 = $"../Player_1"
@onready var player2 = $"../Player_2"

func _process(delta):
	$"../CanvasLayer/Player1/dmg".text = str(GlobalStats.damage_p1) + "%"
	$"../CanvasLayer/Player2/dmg".text = str(GlobalStats.damage_p2) + "%"
	$"../CanvasLayer/Player1/stocks".text = "Stocks: " + str(GlobalStats.stocks_p1)
	$"../CanvasLayer/Player2/stocks".text = "Stocks: " + str(GlobalStats.stocks_p2)

	# Center camera between players
	var center = (player1.global_position + player2.global_position) / 2.0
	global_position = global_position.lerp(center, move_speed * delta)

	# Distance between players
	var distance = player1.global_position - player2.global_position
	var width = abs(distance.x) + margin
	var height = abs(distance.y) + margin

	# Size of the game window
	var viewport_size = get_viewport_rect().size

	# Zoom needed to fit both players
	var zoom_x = viewport_size.x / width
	var zoom_y = viewport_size.y / height

	# Use the smaller zoom so both axes fit
	var target_zoom = min(zoom_x, zoom_y)

	# Clamp so it doesn't zoom too far
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)

	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), zoom_speed * delta)
