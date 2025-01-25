@icon("res://location/graphics/market.png")
class_name Location
extends Area2D

signal location_clicked (location_type : LocationType)

var location_type : LocationType
var is_hovered := false

@onready var sprite := %Sprite as Sprite2D

func _physics_process(_delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			sprite.scale = Vector2(1.0, 1.0)
			location_clicked.emit(location_type)
			
		if Input.is_action_just_released("click"):
			sprite.scale = Vector2(1.5, 1.5)


func load_location_type(new_type : LocationType) -> void:
	location_type = new_type
	sprite.texture = location_type.map_icon
	print("I am a " + location_type.name + " [Location]")
	location_type.coordinates = global_position


func _on_mouse_entered() -> void:
	is_hovered = true
	sprite.scale = Vector2(1.5, 1.5)


func _on_mouse_exited() -> void:
	is_hovered = false
	sprite.scale = Vector2(1.0, 1.0)
