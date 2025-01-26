@icon("res://location/graphics/ON_MAP/map_location_1.png")
class_name Location
extends Area2D

signal location_clicked (location : LocationType)

@export var location_type : LocationType
var is_hovered := false

@onready var sprite := %Sprite as Sprite2D
@onready var grid_container := %GridContainerLocation as GridContainer
@onready var panel_container := %PanelContainer as PanelContainer

func _ready() -> void:
	location_type.fish_at_location.clear()
	panel_container.hide()
	sprite.texture = location_type.map_icon
	#print("I am a " + location_type.name + " [Location]")
	location_type.coordinates = global_position
	location_type.connect("fish_added", on_fish_added)
	location_type.connect("fish_removed", on_fish_removed)


func _physics_process(_delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			sprite.scale = Vector2(1.0, 1.0)
			location_clicked.emit(location_type)
			
		if Input.is_action_just_released("click"):
			sprite.scale = Vector2(1.5, 1.5)
	
	if location_type.fish_at_location.is_empty():
		panel_container.hide()
	else:
		panel_container.show()


func on_fish_added(new_fish : Fish) -> void:
	grid_container.add_child(new_fish)
	#print("Fish added: " + new_fish.fish_type.name + " [Location]")


func on_fish_removed(fish_removed : Fish) -> void:
	fish_removed.queue_free()


func _on_mouse_entered() -> void:
	is_hovered = true
	sprite.scale = Vector2(1.5, 1.5)


func _on_mouse_exited() -> void:
	is_hovered = false
	sprite.scale = Vector2(1.0, 1.0)
