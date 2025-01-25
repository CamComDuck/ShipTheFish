@icon("res://bubble/bubble.png")
class_name Bubble
extends RigidBody2D

signal bubble_sent

var fish_inside : Array[Fish] = []
var max_size := 1

@onready var grid_container := %GridContainerBubble as GridContainer
@onready var max_size_label := %MaxSizeLabel as Label

func _ready() -> void:
	max_size_label.text = "Bubble Size: " + str(max_size)


func add_fish(new_fish : Fish) -> void:
	if fish_inside.size() < max_size:
		fish_inside.append(new_fish)
		grid_container.add_child(new_fish)


func remove_fish(fish_removed : Fish) -> void:
	fish_inside.erase(fish_removed)
	fish_removed.queue_free()


func _on_button_pressed() -> void:
	bubble_sent.emit()
	queue_free()
