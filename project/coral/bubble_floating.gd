@icon("res://bubble/Bubble.png")
class_name BubbleFloating
extends RigidBody2D

signal bubble_collected

var is_hovered := false

func _ready() -> void:
	var random_gravity := randf_range(-0.95, -0.75)
	gravity_scale = random_gravity
	var spin_velocity := randf_range(2, 5)
	angular_velocity = spin_velocity


func _physics_process(_delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			bubble_collected.emit()
			queue_free()
			
	if global_position.y < -10:
		queue_free()


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false
