@icon("res://fish/fish.png")
class_name Fish
extends TextureRect

signal fish_clicked (fish : Fish)

var fish_type : FishType = null
var route : Route = null
var is_hovered := false

@onready var fish_sprite := %FishSprite as TextureRect
@onready var destination_sprite := %DestinationSprite as TextureRect


func _physics_process(_delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			fish_sprite.scale = Vector2(1.0, 1.0)
			fish_clicked.emit(self)
			
		if Input.is_action_just_released("click"):
			fish_sprite.scale = Vector2(1.5, 1.5)


func load_fish_type(new_type : FishType) -> void:
	fish_type = new_type
	print("I am a " + fish_type.name + " [Fish]")
	
	if fish_type != null and route != null:
		route.start.add_fish(self)
		
		print(fish_type.name + " is going from " + route.start.name + " to " + route.destination.name + " [Route]")
		fish_sprite.texture = fish_type.icon
		destination_sprite.texture = route.destination.speech_icon
		fish_sprite.pivot_offset.x = fish_sprite.size.x/2.0
		fish_sprite.pivot_offset.y = fish_sprite.size.y/2.0
		
		custom_minimum_size = fish_sprite.size


func load_route(new_route : Route) -> void:
	route = new_route
	
	if fish_type != null and route != null:
		route.start.add_fish(self)
		
		print(fish_type.name + " is going from " + route.start.name + " to " + route.destination.name + " [Route]")
		fish_sprite.texture = fish_type.icon
		destination_sprite.texture = route.destination.speech_icon
		fish_sprite.pivot_offset.x = fish_sprite.size.x/2.0
		fish_sprite.pivot_offset.y = fish_sprite.size.y/2.0


func _on_mouse_entered() -> void:
	is_hovered = true
	fish_sprite.scale = Vector2(1.5, 1.5)


func _on_mouse_exited() -> void:
	is_hovered = false
	fish_sprite.scale = Vector2(1.0, 1.0)
