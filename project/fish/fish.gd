@icon("res://fish/fish.png")
class_name Fish
extends CharacterBody2D

signal received_type
signal fish_clicked (fish : Fish)

var fish_type : FishType = null
var route : Route = null
var is_hovered := false

@onready var fish_sprite := %FishSprite as Sprite2D
@onready var destination_sprite := %DestinationSprite as Sprite2D

func _physics_process(_delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			fish_sprite.scale = Vector2(1.0, 1.0)
			fish_clicked.emit(self)
			
		if Input.is_action_just_released("click"):
			fish_sprite.scale = Vector2(1.5, 1.5)

func load_fish_type(new_type : FishType) -> void:
	fish_type = new_type
	fish_sprite.texture = fish_type.icon
	print("I am a " + fish_type.name + " [Fish]")
	received_type.emit()


func load_route(new_route : Route) -> void:
	route = new_route
	destination_sprite.texture = route.destination.speech_icon
	received_type.emit()


func _on_received_type() -> void:
	if fish_type != null and route != null:
		print(fish_type.name + " is going from " + route.start.name + " to " + route.destination.name + " [Route]")
		global_position = Vector2(route.start.coordinates.x + 50, route.start.coordinates.y)


func _on_mouse_entered() -> void:
	is_hovered = true
	fish_sprite.scale = Vector2(1.5, 1.5)


func _on_mouse_exited() -> void:
	is_hovered = false
	fish_sprite.scale = Vector2(1.0, 1.0)
