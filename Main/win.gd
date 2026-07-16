extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalStats.winner == "p1":
		text = "Red Wins"
		modulate = Color(0.788, 0.0, 0.0)
	elif GlobalStats.winner == "p2":
		text = "Blue Wins"
		modulate = Color(0.179, 0.409, 0.739)
