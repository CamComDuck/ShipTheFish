class_name Level
extends Node2D

var bubble_active_location : LocationType = null
var current_bubble : Bubble = null

@onready var market := $Market as Location
@onready var shop := $Shop as Location

@onready var bubble := preload("res://bubble/bubble.tscn") as PackedScene
@onready var bubble_floating := preload("res://coral/bubble_floating.tscn") as PackedScene
@onready var fish := preload("res://fish/fish.tscn") as PackedScene
@onready var trash: StaticBody2D = $NavigationRegion/Trash


@onready var navigation_region := %NavigationRegion as NavigationRegion2D


@export var fish_type : FishType
@export var market_type : LocationType
@export var shop_type : LocationType

@export var route_1 : Route
@export var route_2 : Route

func _ready() -> void:
	market.load_location_type(market_type)
	shop.load_location_type(shop_type)
	
	var new_fish = fish.instantiate() as Fish
	new_fish.load_fish_type(fish_type)
	new_fish.load_route(route_1)
	new_fish.connect("fish_clicked", on_fish_clicked)
	new_fish.route.start.add_fish(new_fish)
	
	for child in get_children():
		if child is Location:
			child.connect("location_clicked", on_location_clicked)
		elif child is Fish:
			child.connect("fish_clicked", on_fish_clicked)
	
	for child in navigation_region.get_children():
		if child is Coral:
			child.connect("bubble_spawned", on_bubble_spawned)
	#
	#var new_trash : Trash = trash.duplicate()
	#navigation_region.add_child(new_trash)
	#new_trash.global_position = Vector2(323, 816)
	navigation_region.bake_navigation_polygon()
	


func on_location_clicked(location: LocationType) -> void:
	if bubble_active_location == null:
		#print("Bubble spawned at " + location.name + " [Level]")
		bubble_active_location = location
		current_bubble = bubble.instantiate() as Bubble
		add_child(current_bubble)
		current_bubble.global_position = Vector2(location.coordinates.x - 100, location.coordinates.y)
		current_bubble.connect("bubble_sent", on_bubble_sent)


func on_fish_clicked(fish_clicked : Fish) -> void: 
	#print(fish_clicked.fish_type.name + " was clicked! [Level]")
	
	if bubble_active_location == fish_clicked.route.start: 
		var fish_duplicate := fish.instantiate() as Fish
		fish_duplicate.load_fish_type(fish_clicked.fish_type)
		fish_duplicate.load_route(fish_clicked.route)
		fish_duplicate.connect("fish_clicked", on_fish_clicked)
		
		if fish_clicked.get_parent().name == "GridContainerLocation":
			if current_bubble.fish_inside.size() < current_bubble.max_size:
				if not current_bubble.fish_inside.is_empty():
					if current_bubble.fish_inside[0].route != fish_clicked.route:
						return
						
				fish_clicked.route.start.remove_fish(fish_clicked)
				fish_clicked.queue_free()
				current_bubble.add_fish(fish_duplicate)
			
		elif fish_clicked.get_parent().name == "GridContainerBubble":
			current_bubble.remove_fish(fish_clicked)
			fish_clicked.queue_free()
			fish_clicked.route.start.add_fish(fish_duplicate)


func on_bubble_spawned(coral_spawned_from : Coral) -> void:
	var new_bubble := bubble_floating.instantiate() as BubbleFloating
	navigation_region.add_child(new_bubble)
	var random_x := randf_range(-80.0, 80.0)
	new_bubble.global_position.x = coral_spawned_from.global_position.x + random_x
	new_bubble.global_position.y = coral_spawned_from.global_position.y - 100
	

func on_bubble_sent() -> void:
	bubble_active_location = null
	current_bubble = null
