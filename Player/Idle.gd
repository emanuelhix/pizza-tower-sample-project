extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	animation_player.play("Idle")
	

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.velocity.x = lerp(player.velocity.x, 0, player.friction * delta)
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1")
	elif not is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Run")
