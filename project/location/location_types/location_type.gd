class_name LocationType
extends Resource

signal fish_added (new_fish : Fish)
signal fish_removed (fish_removed : Fish)

@export var name : String
@export var speech_icon : Texture2D
@export var map_icon : Texture2D

var coordinates : Vector2
var fish_at_location : Array[Fish]

func add_fish(new_fish : Fish) -> void:
	print("Fish added: " + new_fish.fish_type.name + " [LocationType]")
	fish_at_location.append(new_fish)
	fish_added.emit(new_fish)
	

func remove_fish(old_fish : Fish) -> void:
	fish_at_location.erase(old_fish)
	fish_removed.emit(old_fish)
