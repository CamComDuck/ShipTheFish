@icon("res://bubble/bubble.png")
class_name Bubble
extends Area2D

var fish_inside : Array[Fish] = []
var max_size := 1

@onready var fish_inside_texture := preload("res://bubble/fish_inside_bubble.tscn") as PackedScene
@onready var grid_container := %GridContainer as GridContainer


func add_fish(new_fish : Fish) -> bool:
	if fish_inside.size() < max_size:
		fish_inside.append(new_fish)
		var new_texture := fish_inside_texture.instantiate() as TextureRect
		new_texture.texture = new_fish.fish_type.icon
		grid_container.add_child(new_texture)
		return true
	else:
		return false


func remove_fish(fish_removed : Fish) -> void:
	fish_inside.erase(fish_removed)
