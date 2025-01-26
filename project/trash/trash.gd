@icon("res://trash/Graphics/Trash1.png")
class_name Trash
extends StaticBody2D

var sprite_1 := preload("res://trash/Graphics/Trash1.png") as Texture2D
var sprite_2 := preload("res://trash/Graphics/Trash2.png") as Texture2D
var sprite_3 := preload("res://trash/Graphics/Trash3.png") as Texture2D
var sprite_4 := preload("res://trash/Graphics/Trash4.png") as Texture2D
var sprite_5 := preload("res://trash/Graphics/Trash5.png") as Texture2D
var sprite_6 := preload("res://trash/Graphics/Trash6.png") as Texture2D
var sprite_7 := preload("res://trash/Graphics/Trash7.png") as Texture2D
var sprite_8 := preload("res://trash/Graphics/Trash8.png") as Texture2D

@onready var sprite := $Sprite as Sprite2D

func _ready() -> void:
	var sprites : Array[Texture2D] = [sprite_1, sprite_2, sprite_3, sprite_4, sprite_5, sprite_6, sprite_7, sprite_8]
	sprite.texture = sprites.pick_random()
