extends Node

@export var game_scene = "res://scenes/game.tscn"
var game_world:Node2D

func _on_start_game_pressed():
	
	game_world=load(game_scene).instantiate()
	add_child(game_world)
	#game_world.end_game.connect(open_main_menu)


func open_main_menu():
	
	game_world.queue_free()
	get_tree().paused=false
	
	var main_menu=load("res://scenes/menu/main_menu.tscn").instantiate()
	add_child(main_menu)
	main_menu.starting.connect(_on_start_game_pressed)
