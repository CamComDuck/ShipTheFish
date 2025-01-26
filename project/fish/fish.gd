@icon("res://fish/Graphics/70x45.png")
class_name Fish
extends TextureRect

signal fish_clicked (fish : Fish)

var fish_type : FishType = null
var route : Route = null
var is_hovered := false
var is_in_moving_bubble := false

@onready var fish_sprite := %FishSprite as TextureRect
@onready var speech_bubble_sprite := %SpeechBubbleSprite as TextureRect
@onready var destination_sprite := %DestinationSprite as TextureRect

func _ready() -> void:
	#print(fish_type.name + " is going from " + route.start.name + " to " + route.destination.name + " [Route]")
	fish_sprite.texture = fish_type.icon
	destination_sprite.texture = route.destination.speech_icon
	fish_sprite.pivot_offset.x = (fish_sprite.size.x/2.0) * (fish_sprite.scale.x)
	fish_sprite.pivot_offset.y = (fish_sprite.size.y/2.0) * (fish_sprite.scale.y)
	#custom_minimum_size = fish_sprite.size


func _physics_process(_delta: float) -> void:
	if is_in_moving_bubble:
		speech_bubble_sprite.hide()
		destination_sprite.hide()
	elif is_hovered:
		if Input.is_action_just_pressed("click"):
			fish_sprite.scale = Vector2(1.0, 1.0)
			fish_clicked.emit(self)
			
		if Input.is_action_just_released("click"):
			fish_sprite.scale = Vector2(1.25, 1.25)


func load_fish_type(new_type : FishType) -> void:
	fish_type = new_type


func load_route(new_route : Route) -> void:
	route = new_route


func _on_fish_sprite_mouse_entered() -> void:
	if not is_in_moving_bubble:
		is_hovered = true
		fish_sprite.scale = Vector2(1.25, 1.25)


func _on_fish_sprite_mouse_exited() -> void:
	if not is_in_moving_bubble:
		is_hovered = false
		fish_sprite.scale = Vector2(1.0, 1.0)
