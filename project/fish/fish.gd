@icon("res://fish/fish.png")
class_name Fish
extends CharacterBody2D

signal received_type

var fish_type : FishType = null
var route : Route = null

@onready var sprite := %Sprite as Sprite2D


func load_fish_type(new_type : FishType) -> void:
	fish_type = new_type
	sprite.texture = fish_type.icon
	print("I am a " + fish_type.name + " [Fish]")
	received_type.emit()


func load_route(new_route : Route) -> void:
	route = new_route
	received_type.emit()


func _on_received_type() -> void:
	if fish_type != null and route != null:
		print(fish_type.name + " is going from " + route.start.name + " to " + route.destination.name + " [Route]")
