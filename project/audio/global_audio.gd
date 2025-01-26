extends Node2D

func play_bubble_pop_sound() -> void:
	$BubblePop.play()
	
func play_button_sound() -> void:
	$Button.play()

func play_trash_pickup_sound() -> void:
	$TrashPickup.play()

func play_click_sound() -> void:
	$Click.play()
