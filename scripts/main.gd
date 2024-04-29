extends Node

@export var game_scene = "res://scenes/game.tscn"
var game_world:Node2D
var credits:Control


func _on_start_game_pressed():
	game_world=load(game_scene).instantiate()
	add_child(game_world)
	$VBoxContainer/StartGame.disabled = true 
	$VBoxContainer/Quit.disabled = true
	$VBoxContainer/CreditsButton.disabled = true 
	game_world.deathScreen.connect(Callable(self, "open_death_screen"))

func open_death_screen():
	game_world.queue_free()
	get_tree().paused = false
	
	var deathScreen = load("res://scenes/death_screen.tscn").instantiate()
	add_child(deathScreen)
	deathScreen.restart.connect(Callable(self, "restart"))
	print("restart signal connected")

func restart():
	print("restart")
	game_world=load(game_scene).instantiate()
	add_child(game_world)
	game_world.deathScreen.connect(Callable(self, "open_death_screen"))
	remove_child(get_node("death screen"))

func open_main_menu():
	
	game_world.queue_free()
	get_tree().paused=false
	
	var main_menu=load("res://scenes/menu/main_menu.tscn").instantiate()
	add_child(main_menu)
	main_menu.starting.connect(_on_start_game_pressed)

func quit_game():
	get_tree().quit()

func _on_quit_pressed():
	call_deferred("quit_game")



func _on_credits_pressed():
	credits = load("res://scenes/credits.tscn").instantiate()
	add_child(credits)
	$Timer.start()


func _on_timer_timeout():
	call_deferred("remove_child", $Credits)
	$Timer.stop()
	


func open_victory_screen():
	game_world.queue_free()
	get_tree().paused = false
	
	var victoryScreen = load("res://scenes/victory_screen.tscn").instantiate()
	add_child(victoryScreen)
	victoryScreen.restart.connect(Callable(self, "restart"))
	print("restart signal connected")
