class_name Projectile
extends Area2D


export var speed: float = 500.0
var direction := Vector2.RIGHT setget set_direction


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func set_direction(p_vec: Vector2) -> void:
	direction = p_vec if p_vec.is_normalized() else p_vec.normalized()
