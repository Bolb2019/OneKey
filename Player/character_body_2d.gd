extends CharacterBody2D

var input = "OneKey_L"

const MOVE_VELOCITY = 350.0
const JUMP_VELOCITY = -450.0
const FRICTION = 10

const COMBOS = {
	#MOVEMENT
	#--basic--
	"left": "10",
	"right": "01",
	"jump": "010",
	#--expert--
	"left_dash": "10110",
	"right_dash": "01101",
	"high_jump": "01110",
	#--impossible--
	
	#ATTACKS
	#--basic--
	"left_attack": "1000",
	"right_attack": "0001",
	"down_attack": "0110",
	"up_attack": "1001"
	#--expert--
	#--impossible--
}

var Combo_used = ""
var time = 0
var hold_buffer = 0
var combo_buffer = 0

func _ready() -> void:
	if name == "Player_2":
		input = "OneKey_R"

func _physics_process(delta: float) -> void:
	
	time += delta
	#Start input
	if Input.is_action_just_pressed(input):
		hold_buffer = time + 1
	
	if Input.is_action_pressed(input):
		$Combo/Charge.value = abs(hold_buffer - time - 1)
		$Combo/Charge2.value = abs(hold_buffer - time - 1)
	
	#decide if it's a dot or dash
	if Input.is_action_just_released(input):
		if time > hold_buffer:
			Combo_used = Combo_used + str(" ")
		elif time > hold_buffer - 0.5:
			Combo_used = Combo_used + str("1")
		else:
			Combo_used = Combo_used + str("0")
		combo_buffer = time + 1
		$Combo.text = Combo_used
		$Use/Timer.start()
		$Combo/Charge.value = 0
		$Combo/Charge2.value = 0
	
	if $Use/Timer.is_stopped():
		if Combo_used != "":
			config_combo()
		Combo_used = ""
		$Use.text = ""
		$Combo.text = Combo_used
	else:
		$Use.text = str("%.2f" % $Use/Timer.time_left)
			
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if velocity.x >= 0:
		velocity.x -= FRICTION 
	else:
		velocity.x += FRICTION 
	if abs(velocity.x) <= 10 and abs(velocity.x) >= 0.0:
		velocity.x = 0

	move_and_slide()
	
func config_combo():
	Combo_used = Combo_used + " "
	var action = ""
	var Combo_actions = []
	
	while Combo_used.length() >= 1:
		action += Combo_used.substr(0, 1)
		Combo_used = Combo_used.substr(1)
		if action.ends_with(" "):
			Combo_actions.append(action.substr(0, action.length() - 1))
			action = ""
			
	for move in Combo_actions:
		use_combo(move)
		await get_tree().create_timer(0.1).timeout
	
func use_combo(action):
	
	#MOVEMENT
	#--basic--
	if action == COMBOS["left"]:
		velocity.x = -MOVE_VELOCITY
	if action == COMBOS["right"]:
		velocity.x = MOVE_VELOCITY
	if action == COMBOS["jump"]:
		velocity.y = JUMP_VELOCITY
	#--expert--
	if action == COMBOS["left_dash"]:
		velocity.x = -MOVE_VELOCITY * 2
	if action == COMBOS["right_dash"]:
		velocity.x = MOVE_VELOCITY * 1.5
	if action == COMBOS["high_jump"]:
		velocity.y = JUMP_VELOCITY * 1.5
	#--impossible--
	
	#ATTACKS
	#--basic--
	if action == COMBOS["left_attack"]:
		$Attack_L.visible = true
		await get_tree().create_timer(0.5).timeout
		$Attack_L.visible = false
	if action == COMBOS["right_attack"]:
		$Attack_R.visible = true
		await get_tree().create_timer(0.5).timeout
		$Attack_R.visible = false
	if action == COMBOS["down_attack"]:
		$Attack_down.visible = true
		await get_tree().create_timer(0.5).timeout
		$Attack_down.visible = false
	if action == COMBOS["up_attack"]:
		$Attack_up.visible = true
		await get_tree().create_timer(0.5).timeout
		$Attack_up.visible = false
	#--expert--
	#--impossible--
