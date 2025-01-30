class_name Title
extends Node2D

var big := Vector2(1.2, 1.2)
var normal := Vector2(1.0, 1.0)

@onready var tutorial: Sprite2D = %Tutorial
@onready var back_button: Button = %BackButton
@onready var credits: Sprite2D = %Credits

@onready var play_button: Button = %PlayButton
@onready var tutorial_button: Button = %TutorialButton
@onready var credits_button: Button = %CreditsButton


func _ready() -> void:
	tutorial.hide()
	credits.hide()
	back_button.hide()


func _on_play_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	get_tree().change_scene_to_packed(preload("res://level/level.tscn"))


func _on_tutorial_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	tutorial.show()
	back_button.show()


func _on_credits_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	credits.show()
	back_button.show()


func _on_back_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	tutorial.hide()
	credits.hide()
	back_button.hide()


func _on_play_button_mouse_entered() -> void:
	play_button.scale = big


func _on_play_button_mouse_exited() -> void:
	play_button.scale = normal


func _on_tutorial_button_mouse_entered() -> void:
	tutorial_button.scale = big


func _on_tutorial_button_mouse_exited() -> void:
	tutorial_button.scale = normal



func _on_credits_button_mouse_entered() -> void:
	credits_button.scale = big


func _on_credits_button_mouse_exited() -> void:
	credits_button.scale = normal


func _on_back_button_mouse_entered() -> void:
	back_button.scale = big


func _on_back_button_mouse_exited() -> void:
	back_button.scale = normal
