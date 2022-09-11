class_name Player
extends KinematicBody2D

var speed = 80
var jump_impulse = 360
var gravity = 1200
var acceleration = 60
var friction = 20
var air_friction = 10

var can_input = true
var velocity := Vector2.ZERO


func get_input_direction() -> float:
	if not can_input:
		return 0.0
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if direction < 0:
		$Sprite.flip_h = true
	if direction > 0:
		$Sprite.flip_h = false
	
	return direction


func ready_for_input():
	can_input = true
