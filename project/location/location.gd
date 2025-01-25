@icon("res://location/graphics/market.png")
class_name Location
extends Area2D

var location_type : LocationType

@onready var sprite := %Sprite as Sprite2D

func load_location_type(new_type : LocationType) -> void:
	location_type = new_type
	sprite.texture = location_type.map_icon
	print("I am a " + location_type.name + " [Location]")
