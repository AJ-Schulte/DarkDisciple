extends Node

@export var game_scene = "res://scenes/game.tscn"
var game_world:Node2D
var credits:Control


func _on_start_game_pressed():
	game_world=load(game_scene).instantiate()
	add_child(game_world)
	$StartGame.disabled = true 
	$Quit.disabled = true
	$CreditsButton.disabled = true 
	

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
	


