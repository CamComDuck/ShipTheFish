class_name Level
extends Node2D

var bubble_active_location : LocationType = null
var current_bubble : Bubble = null
var bubbles_available := 3
var game_over := false

var fish_needed_to_win := 25.0
var fish_delivered := 0.0

var all_coral_alive : Array[Coral]
var all_coral_dead : Array[Coral]
var trash_on_screen := 0

var all_fish_types : Array[FishType]
var all_routes : Array[Route]

var big := Vector2(1.2, 1.2)
var normal := Vector2(1.0, 1.0)

@onready var bubble := preload("res://bubble/bubble.tscn") as PackedScene
@onready var bubble_floating := preload("res://coral/bubble_floating.tscn") as PackedScene
@onready var bubble_icon := preload("res://level/bubble_icon.tscn") as PackedScene
@onready var fish := preload("res://fish/fish.tscn") as PackedScene
@onready var trash := preload("res://trash/trash.tscn") as PackedScene
@onready var bubble_pop_particles := preload("res://bubble/pop_particles.tscn") as PackedScene
@onready var trash_particles := preload("res://trash/trash_particles.tscn") as PackedScene
@onready var coral_particles := preload("res://coral/coral_particles.tscn") as PackedScene

@onready var navigation_region := %NavigationRegion as NavigationRegion2D
@onready var grid_container := %GridContainer as GridContainer
@onready var fish_spawn_timer := %FishSpawnTimer as Timer
@onready var trash_spawn_timer := %TrashSpawnTimer as Timer
@onready var win_progress_bar := %WinProgressBar as TextureProgressBar

@onready var end_screen: Control = %EndScreen
@onready var win_texture: TextureRect = %WinTexture
@onready var lose_texture: TextureRect = %LoseTexture
@onready var main_menu_button: Button = %MainMenuButton
@onready var play_again_button: Button = %PlayAgainButton



@export_category("Fish Types")
@export var blue_fish_type : FishType
@export var brown_fish_type : FishType
@export var green_fish_type : FishType
@export var orange_fish_type : FishType
@export var ray_fish_type : FishType
@export var teal_fish_type : FishType
@export var turtle_fish_type : FishType

@export_category("Routes")
@export var route_1 : Route
@export var route_2 : Route
@export var route_3 : Route
@export var route_4 : Route
@export var route_5 : Route
@export var route_6 : Route
@export var route_7 : Route
@export var route_8 : Route
@export var route_9 : Route
@export var route_10 : Route
@export var route_11 : Route
@export var route_12 : Route
@export var route_13 : Route
@export var route_14 : Route
@export var route_15 : Route
@export var route_16 : Route
@export var route_17 : Route
@export var route_18 : Route
@export var route_19 : Route
@export var route_20 : Route


func _ready() -> void:
	end_screen.hide()
	win_texture.hide()
	lose_texture.hide()
	
	all_fish_types = [blue_fish_type, brown_fish_type, green_fish_type, orange_fish_type, ray_fish_type, teal_fish_type, turtle_fish_type]
	all_routes = [route_1, route_2, route_3, route_4, route_5, route_6, route_7, route_8, route_9, route_10, route_11, route_12, route_13, route_14, route_15, route_16, route_17, route_18, route_19, route_20]
		
	for i in bubbles_available:
		var new_bubble_icon := bubble_icon.instantiate()
		grid_container.add_child(new_bubble_icon)
	
	for child in navigation_region.get_children():
		if child is Coral:
			child.connect("bubble_spawned", on_bubble_spawned)
			if not child.is_decoration:
				child.connect("coral_revived", on_coral_revived)
				all_coral_alive.append(child)
		elif child is Location:
			child.connect("location_clicked", on_location_clicked)

	navigation_region.bake_navigation_polygon()
	_on_fish_spawn_timer_timeout()
	
	

func on_location_clicked(location: LocationType) -> void:
	if bubble_active_location == null and bubbles_available > 0 and not game_over:
		GlobalAudio.play_click_sound()
		bubbles_available -= 1
		grid_container.get_child(0).queue_free()
		bubble_active_location = location
		current_bubble = bubble.instantiate() as Bubble
		navigation_region.add_child(current_bubble)
		current_bubble.global_position = Vector2(location.coordinates.x - 150, location.coordinates.y)
		current_bubble.connect("bubble_sent", on_bubble_sent)
		current_bubble.connect("bubble_reached_destination", on_bubble_reached_destination)
		
		await create_tween().tween_interval(0.5).finished
		if navigation_region.is_baking():
			await navigation_region.bake_finished
			
		navigation_region.bake_navigation_polygon()
		
	elif bubble_active_location == null and bubbles_available <= 0:
		# GAME LOSE
		GlobalAudio.play_click_sound()
		end_screen.show()
		lose_texture.show()
		fish_spawn_timer.stop()
		trash_spawn_timer.stop()
		game_over = true
		for child in navigation_region.get_children():
			if child is Coral:
				child.bubble_spawn_timer.stop()
				child.revive_timer.stop()
			
		for child in get_children():
			if child is Bubble:
				child.queue_free()


func on_fish_clicked(fish_clicked : Fish) -> void: 
	#print(fish_clicked.fish_type.name + " was clicked! [Level]")
	
	if bubble_active_location == fish_clicked.route.start and not game_over: 
		GlobalAudio.play_click_sound()
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
	
	await create_tween().tween_interval(0.5).finished
	if navigation_region.is_baking():
		await navigation_region.bake_finished
		
	navigation_region.bake_navigation_polygon()


func on_bubble_spawned(coral_spawned_from : Coral) -> void:
	var new_bubble := bubble_floating.instantiate() as BubbleFloating
	navigation_region.add_child(new_bubble)
	var random_x := randf_range(-80.0, 80.0)
	new_bubble.global_position.x = coral_spawned_from.global_position.x + random_x
	new_bubble.global_position.y = coral_spawned_from.global_position.y - 100
	new_bubble.connect("bubble_collected", on_bubble_collected)
	

func on_bubble_sent(has_fish : bool, bubble_position : Vector2) -> void:
	GlobalAudio.play_click_sound()
	bubble_active_location = null
	current_bubble = null
	
	if not has_fish:
		var new_particles := bubble_pop_particles.instantiate() as CPUParticles2D
		add_child(new_particles)
		new_particles.global_position = bubble_position
		new_particles.emitting = true
	else:
		await create_tween().tween_interval(0.5).finished
		if navigation_region.is_baking():
			await navigation_region.bake_finished
			
		navigation_region.bake_navigation_polygon()
	

func on_bubble_collected(bubble_position : Vector2) -> void:
	var new_particles := bubble_pop_particles.instantiate() as CPUParticles2D
	add_child(new_particles)
	new_particles.global_position = bubble_position
	new_particles.emitting = true
	
	if bubbles_available < 9 and not game_over:
		bubbles_available += 1
		var new_bubble_icon := bubble_icon.instantiate()
		grid_container.add_child(new_bubble_icon)
		
		
func on_bubble_reached_destination(num_of_fish : int, bubble_position : Vector2) -> void:
	fish_delivered += num_of_fish
	var percent := fish_delivered / fish_needed_to_win
	win_progress_bar.value = percent
	
	var new_particles := bubble_pop_particles.instantiate() as CPUParticles2D
	add_child(new_particles)
	new_particles.global_position = bubble_position
	new_particles.emitting = true
	
	if fish_delivered >= fish_needed_to_win:
		# GAME WIN
		end_screen.show()
		win_texture.show()
		fish_spawn_timer.stop()
		trash_spawn_timer.stop()
		game_over = true
		for child in navigation_region.get_children():
			if child is Coral:
				child.bubble_spawn_timer.stop()
				child.revive_timer.stop()
			
		for child in get_children():
			if child is Bubble:
				child.queue_free()


func on_trash_cleared(trash_cleared : Trash) -> void:
	trash_on_screen -= 1
	if trash_on_screen / 12.0 == 1 or trash_on_screen / 10.0 == 1 or trash_on_screen / 8.0 == 1 or trash_on_screen / 6.0 == 1 or trash_on_screen / 4.0 == 1 or trash_on_screen / 2.0 == 1 or trash_on_screen == 0:
		if not all_coral_dead.is_empty():
			var chosen_coral : Coral = all_coral_dead.pick_random()
			all_coral_dead.erase(chosen_coral)
			
			var min_sec := 2.0
			var max_sec := 4.0
			var random_time := randf_range(min_sec, max_sec)
			chosen_coral.revive_timer.start(random_time)
			
	var new_particles := trash_particles.instantiate() as CPUParticles2D
	add_child(new_particles)
	new_particles.global_position = trash_cleared.global_position
	new_particles.emitting = true
			
	trash_cleared.reparent(self)
	trash_cleared.queue_free()
	
	if navigation_region.is_baking():
		await navigation_region.bake_finished
		
	navigation_region.bake_navigation_polygon()


func on_coral_revived(coral_revived_from : Coral) -> void:
	all_coral_alive.append(coral_revived_from)
	
	var new_particles := coral_particles.instantiate() as CPUParticles2D
	add_child(new_particles)
	new_particles.global_position = coral_revived_from.global_position
	new_particles.color = Color.PINK
	new_particles.emitting = true
	

func _on_fish_spawn_timer_timeout() -> void:
	var new_fish := fish.instantiate() as Fish
	new_fish.load_fish_type(all_fish_types.pick_random())
	new_fish.load_route(all_routes.pick_random())
	new_fish.connect("fish_clicked", on_fish_clicked)
	new_fish.route.start.add_fish(new_fish)
	
	var min_sec := 3.5
	var max_sec := 5.5
	var rand_respawn := randf_range(min_sec, max_sec)
	fish_spawn_timer.start(rand_respawn)
	
	await create_tween().tween_interval(0.5).finished
	if navigation_region.is_baking():
		await navigation_region.bake_finished
		
	navigation_region.bake_navigation_polygon()
	

func _on_trash_spawn_timer_timeout() -> void:
	var new_trash := trash.instantiate() as Trash
	new_trash.connect("trash_cleared", on_trash_cleared)
	navigation_region.add_child(new_trash)
	
	var random_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_region.get_navigation_map(), 1, true)
	#new_trash.global_position = Vector2(randf_range(300, 1690), randf_range(90,715))
	new_trash.global_position = random_position
	
	trash_on_screen += 1
	if trash_on_screen % 2 == 0 and not all_coral_alive.is_empty():
		var chosen_coral : Coral = all_coral_alive.pick_random()
		chosen_coral.kill_coral()
		all_coral_dead.append(chosen_coral)
		all_coral_alive.erase(chosen_coral)
		
		var new_particles := coral_particles.instantiate() as CPUParticles2D
		add_child(new_particles)
		new_particles.global_position = chosen_coral.global_position
		new_particles.color = Color.BLACK
		new_particles.emitting = true
	
	var min_sec := 3.5
	var max_sec := 5.5
	var rand_respawn := randf_range(min_sec, max_sec)
	trash_spawn_timer.start(rand_respawn)
	
	if navigation_region.is_baking():
		await navigation_region.bake_finished
		
	
	navigation_region.bake_navigation_polygon()


func _on_play_again_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	get_tree().change_scene_to_packed(preload("res://level/level.tscn"))


func _on_main_menu_button_pressed() -> void:
	GlobalAudio.play_button_sound()
	get_tree().change_scene_to_file("res://title/title.tscn")


func _on_play_again_button_mouse_entered() -> void:
	play_again_button.scale = big


func _on_play_again_button_mouse_exited() -> void:
	play_again_button.scale = normal


func _on_main_menu_button_mouse_entered() -> void:
	main_menu_button.scale = big


func _on_main_menu_button_mouse_exited() -> void:
	main_menu_button.scale = normal
