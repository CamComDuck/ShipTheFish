@icon("res://bubble/Bubble.png")
class_name Bubble
extends CharacterBody2D

signal bubble_sent (has_fish : bool, bubble_position : Vector2)
signal bubble_reached_destination (num_of_fish : int, bubble_position : Vector2)

var fish_inside : Array[Fish] = []
var max_size := 4
var is_moving := false
var location_target : LocationType = null

var big := Vector2(1.2, 1.2)
var normal := Vector2(1.0, 1.0)

var speed := 100
var accel := 7

@onready var grid_container := %GridContainerBubble as GridContainer
@onready var max_size_label := %MaxSizeLabel as Label
@onready var nav := %NavigationAgent as NavigationAgent2D
@onready var send_button := %SendButton as Button
@onready var navigation_obstacle := %NavigationObstacle as NavigationObstacle2D


func _ready() -> void:
	max_size_label.text = "Bubble Size: " + str(max_size)


func _physics_process(delta: float) -> void:
	if is_moving:
		var direction = Vector3()
		
		nav.target_position = location_target.coordinates
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity.x = move_toward(velocity.x, direction.x * speed, delta * speed)
		velocity.y = move_toward(velocity.y, direction.y * speed, delta * speed)
		move_and_slide()
		
		

func add_fish(new_fish : Fish) -> void:
	fish_inside.append(new_fish)
	grid_container.add_child(new_fish)


func remove_fish(fish_removed : Fish) -> void:
	fish_inside.erase(fish_removed)
	fish_removed.queue_free()


func _on_button_pressed() -> void:
	if not is_moving and not fish_inside.is_empty():
			location_target = fish_inside[0].route.destination
			is_moving = true
			for fish in fish_inside:
				fish.is_in_moving_bubble = true
			bubble_sent.emit(true, global_position)
			navigation_obstacle.queue_free()
			send_button.hide()
			max_size_label.hide()
			var tween_spin : Tween = create_tween().set_ease(Tween.EASE_OUT_IN)
			tween_spin.tween_property(self, "rotation", 20, 20).set_trans(Tween.TRANS_SINE)
	elif not is_moving and fish_inside.is_empty():
		bubble_sent.emit(false, global_position)
		GlobalAudio.play_bubble_pop_sound()
		queue_free()


func _on_navigation_agent_target_reached() -> void:
	is_moving = false
	bubble_reached_destination.emit(fish_inside.size(), global_position)
	GlobalAudio.play_bubble_pop_sound()
	queue_free()


func _on_send_button_mouse_entered() -> void:
	send_button.scale = big


func _on_send_button_mouse_exited() -> void:
	send_button.scale = normal
