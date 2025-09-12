class_name Input_Controller
var player: Player

func _init(player_ref):
	player = player_ref

func update() -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	player.velocity = input_vector * player.SPD
	if Input.is_action_pressed("sprint"):
		player.velocity *= 1.5

	if player.velocity.x * player.direction < 0:
		player.flip()
	if !(player.current_state == player.states.special or player.current_state == player.states.healing or player.current_state == player.states.secondary or player.current_state == player.states.primary):
		player.move_and_slide()

	if Input.is_action_just_pressed("special"):
		player.state_update(player.states.special)
	elif Input.is_action_just_pressed("heal"):
		player.state_update(player.states.healing)
	elif Input.is_action_just_pressed("secondary"):
		player.state_update(player.states.secondary)
	elif Input.is_action_just_pressed("primary"):
		player.primary()
	elif player.velocity.length() > 0:
		if Input.is_action_pressed("sprint"):
			player.state_update(player.states.running)
		else:
			player.state_update(player.states.walking)
	else:
		player.state_update(player.states.idle)
