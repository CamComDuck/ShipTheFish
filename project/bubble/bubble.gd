@icon("res://bubble/bubble.png")
class_name Bubble
extends CharacterBody2D

signal bubble_sent

var fish_inside : Array[Fish] = []
var max_size := 1
var is_moving := false
var location_target : LocationType = null

var speed := 100
var accel := 7

@onready var grid_container := %GridContainerBubble as GridContainer
@onready var max_size_label := %MaxSizeLabel as Label
@onready var nav := %NavigationAgent as NavigationAgent2D
@onready var send_button := %SendButton as Button


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
	if not is_moving:
		if not fish_inside.is_empty():
			location_target = fish_inside[0].route.destination
			is_moving = true
			for fish in fish_inside:
				fish.is_in_moving_bubble = true
		bubble_sent.emit()
		send_button.hide()
		max_size_label.hide()


func _on_navigation_agent_target_reached() -> void:
	is_moving = false
	queue_free()
