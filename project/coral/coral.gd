@icon("res://coral/Graphics/Coral_Medium.png")
class_name Coral
extends StaticBody2D

signal bubble_spawned (coral_spawned_from : Coral)

var is_alive := true

@onready var bubble_spawn_timer := %BubbleSpawnTimer as Timer
@onready var sprite_alive := %SpriteAlive as Sprite2D
@onready var sprite_dead := %SpriteDead as Sprite2D
@export var is_decoration : bool


func _ready() -> void:
	if not is_decoration:
		revive_coral()
	else:
		sprite_alive.show()
		sprite_dead.hide()


func kill_coral() -> void:
	is_alive = false
	bubble_spawn_timer.stop()
	sprite_alive.hide()
	sprite_dead.show()


func revive_coral() -> void:
	is_alive = true
	sprite_alive.show()
	sprite_dead.hide()
	restart_timer()
	

func restart_timer() -> void:
	var min_sec := 1.0
	var max_sec := 5.0
	var chosen_sec := randf_range(min_sec, max_sec)
	bubble_spawn_timer.start(chosen_sec)


func _on_timer_timeout() -> void:
	bubble_spawned.emit(self)
	restart_timer()
