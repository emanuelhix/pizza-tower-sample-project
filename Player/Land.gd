extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

var fall_threshold : float = 0.7
var free_fall_threshold: float = 1.35

func enter(_msg := {}) -> void:
	if _msg.fall_time >= fall_threshold:
		animation_player.play("Land")
	if _msg.fall_time >= free_fall_threshold:
		animation_player.play("FreeFallLand")
	animation_player.connect("animation_finished", self, "on_landed_finished")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		if animation_player.is_connected("animation_finished", self, "on_landed_finished"):
			animation_player.disconnect("animation_finished", self, "on_landed_finished")
		state_machine.transition_to("Air", {do_jump = true})

func on_landed_finished(var _unused) -> void:
	animation_player.disconnect("animation_finished", self, "on_landed_finished")
	state_machine.transition_to("Idle")
