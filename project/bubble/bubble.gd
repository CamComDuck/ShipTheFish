@icon("res://bubble/bubble.png")
class_name Bubble
extends Area2D

signal bubble_sent

var fish_inside : Array[Fish] = []
var max_size := 1

@onready var fish_inside_texture := preload("res://bubble/fish_inside_bubble.tscn") as PackedScene
@onready var grid_container := %GridContainer as GridContainer
@onready var max_size_label := %MaxSizeLabel as Label

func _ready() -> void:
	max_size_label.text = "Bubble Size: " + str(max_size)


func add_fish(new_fish : Fish) -> void:
	if fish_inside.size() < max_size:
		fish_inside.append(new_fish)
		var new_texture := fish_inside_texture.instantiate() as TextureRect
		new_texture.texture = new_fish.fish_type.icon
		grid_container.add_child(new_texture)
		new_fish.queue_free()


func remove_fish(fish_removed : Fish) -> void:
	fish_inside.erase(fish_removed)


func _on_button_pressed() -> void:
	bubble_sent.emit()
	queue_free()
