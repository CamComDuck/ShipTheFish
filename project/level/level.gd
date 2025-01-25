class_name Level
extends Node2D

var bubble_active_location : LocationType = null
var current_bubble : Bubble = null

@onready var fish_1 := $Fish as Fish
@onready var market := $Market as Location
@onready var shop := $Shop as Location

@onready var bubble := preload("res://bubble/bubble.tscn") as PackedScene

@export var fish_type : FishType
@export var market_type : LocationType
@export var shop_type : LocationType

@export var route_1 : Route

func _ready() -> void:
	fish_1.load_fish_type(fish_type)
	market.load_location_type(market_type)
	shop.load_location_type(shop_type)
	fish_1.load_route(route_1)
	
	for child in get_children():
		if child is Location:
			child.connect("location_clicked", on_location_clicked)
		elif child is Fish:
			child.connect("fish_clicked", on_fish_clicked)


func on_location_clicked(location: LocationType) -> void:
	if bubble_active_location == null:
		print("Bubble spawned at " + location.name + " [Level]")
		bubble_active_location = location
		current_bubble = bubble.instantiate() as Bubble
		add_child(current_bubble)
		current_bubble.global_position = Vector2(location.coordinates.x - 100, location.coordinates.y)
		current_bubble.connect("bubble_sent", on_bubble_sent)


func on_fish_clicked(fish : Fish) -> void: 
	if bubble_active_location == fish.route.start: 
		print(fish.fish_type.name)
		current_bubble.add_fish(fish)


func on_bubble_sent() -> void:
	bubble_active_location = null
	current_bubble = null
