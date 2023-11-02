extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

var total_fall_time : float = 0.0
var fall_threshold : float = 0.75
var free_fall_threshold : float = 1.35
var mach_free_fall_threshold : float = 1.75

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		animation_player.play("Jump")

func exit() -> void:
	# reset the tracked fall time
	total_fall_time = 0.0

func physics_update(delta: float) -> void:
	total_fall_time += delta
	
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0, player.air_friction * delta)
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1")
	
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Land", {fall_time = total_fall_time})
		else:
			state_machine.transition_to("Run")
	else:
		if total_fall_time >= mach_free_fall_threshold:
			animation_player.play("MachFreeFall")
			return
		if total_fall_time >= free_fall_threshold:
			animation_player.play("FreeFall")
			return
		if total_fall_time >= fall_threshold:
			animation_player.play("Fall")
			return
