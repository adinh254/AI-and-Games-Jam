class_name Enemy

extends KinematicBody2D

export var max_speed = 1
export var steer_force = 0.1
export var look_ahead = 100
export var num_rays = 8

var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func _ready():
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func set_default_interest():
	for i in num_rays:
		var scalar: float = ray_directions[i].rotated(rotation).dot(transform.x)
		interest[i] = max(0, scalar)


func set_interest():
	var parent = get_parent()
	if parent and parent.has_method("get_path_direction"):
		var path_global_dir = parent.get_path_direction(global_position)
		for i in num_rays:
			var scalar: float = ray_directions[i].rotated(global_rotation).dot(path_global_dir)
			interest[i] = max(0, scalar)
	else:
		set_default_interest()


func set_danger():
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(
			position,
			position + ray_directions[i].rotated(rotation) * look_ahead,
			[self]
		)
		danger[i] = 1.0 if result else 0.0


func choose_direction():
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()


func _physics_process(delta: float) -> void:
	set_interest()
	set_danger()
	choose_direction()
	
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = velocity.angle()
	move_and_collide(velocity * delta)
