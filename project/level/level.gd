class_name Level
extends Node2D

@onready var fish := $Fish as Fish
@onready var location := $Location as Location
@onready var location_2: Location = $Location2


@export var fish_type : FishType
@export var location_type : LocationType
@export var location_type_2 : LocationType

@export var route_1 : Route

func _ready() -> void:
	fish.load_fish_type(fish_type)
	location.load_location_type(location_type)
	location_2.load_location_type(location_type_2)
	fish.load_route(route_1)
