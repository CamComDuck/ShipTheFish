class_name Level
extends Node2D

@onready var fish := $Fish as Fish
@onready var market := $Market as Location
@onready var shop := $Shop as Location

@onready var bubble := preload("res://bubble/bubble.tscn") as PackedScene

@export var fish_type : FishType
@export var market_type : LocationType
@export var shop_type : LocationType

@export var route_1 : Route

func _ready() -> void:
	fish.load_fish_type(fish_type)
	market.load_location_type(market_type)
	shop.load_location_type(shop_type)
	fish.load_route(route_1)
	
	for child in get_children():
		if child is Location:
			child.connect("location_clicked", on_location_clicked)


func on_location_clicked(location_type: LocationType) -> void:
	print(location_type.name)
