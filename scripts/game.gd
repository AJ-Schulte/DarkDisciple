extends Node2D

@export var start_scene = "res://scenes/level_1.tscn"
var current_level:Node2D
var old_level:Node2D
var player:Node2D
var remoteTransform: Node2D
#This runs as soon as an instance of "game.tscn" enters the scene tree, which means whenever you add it with "add_child()"
func _ready():
	#This is how we enter the first scene. It will be loaded and added as soon as we start the game.
	#	You can change the starting scene by setting a different scene file in the editor.
	
	current_level=load(start_scene).instantiate()
	player = current_level.get_node("Player")
	
	$Levels.add_child(current_level)
	$WorldCamera.limit_left =0
	$WorldCamera.limit_right = 6888
	$WorldCamera.limit_top =0
	$WorldCamera.limit_bottom = 2952
	current_level.goto_room.connect(_on_goto_room)
	current_level.goto_main.connect(_on_goto_main)
	

func _on_goto_room(scene:PackedScene, location):
	#If we instance the new level insted of using change_scene(), we can do our setup in between. 
	#like using a tween to slowly move the camera to the new area.
	get_tree().paused=true
	
	var new_level=scene.instantiate()
	$Levels.call_deferred("add_child", new_level)
	if(location == 'Castle'):
		$WorldCamera.limit_left =-442
		$WorldCamera.limit_right = 2288
		$WorldCamera.limit_top = -265
		$WorldCamera.limit_bottom = 1296
		player.set_position(Vector2(900,900))
		player.set_scale(Vector2(1, 1))
	elif (location == 'Church'):
		$WorldCamera.limit_left =0
		$WorldCamera.limit_right = 3792
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 2570
		$WorldCamera.set_zoom(Vector2(0.8, 0.8))
		player.set_position(Vector2(2300,2100))
		player.set_scale(Vector2(2, 2))
	elif(location == 'Level 1'):
		$WorldCamera.limit_left =0
		$WorldCamera.limit_right = 6888
		$WorldCamera.limit_top =0
		$WorldCamera.limit_bottom = 2952
		$WorldCamera.set_zoom(Vector2(1,1))
		player.set_scale(Vector2(1.3, 1.3))
		if(current_level == $Levels/Castle):
			player.set_position(Vector2(784,460))
		elif(current_level == $Levels/Church):
			player.set_position(Vector2(5944, 2112))
	elif(location == 'Colosseum'):
		$WorldCamera.limit_left = 0
		$WorldCamera.limit_right = 2816
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 2560
		$WorldCamera.set_zoom(Vector2(0.8, 0.8))
		player.set_position(Vector2(1696,2112))
		player.set_scale(Vector2(1.5,1.5))
	elif(location == 'House'):
		$WorldCamera.limit_left = 0
		$WorldCamera.limit_right = 576
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 383
		$WorldCamera.set_zoom(Vector2(2,2))
		player.set_position(Vector2(272, 296))
		player.set_scale(Vector2(0.8,0.8))
		player.SPEED = 160.0
	elif(location == 'Level 2'):
		$WorldCamera.limit_left = -1035
		$WorldCamera.limit_right = 8950.5
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 5255
		$WorldCamera.set_zoom(Vector2(1,1))
		player.set_scale(Vector2(1.3, 1.3))
		if(current_level == $Levels/House):
			player.set_position(Vector2(-225,1100))
			player.SPEED = 320.0
		elif(current_level == $Levels/Church):
			player.set_position(Vector2(8000, 2100))
	elif(location == 'Final Boss Area'):
		$WorldCamera.limit_left = 0
		$WorldCamera.limit_right = 1925
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 1296
		$WorldCamera.set_zoom(Vector2(1.2, 1.2))
		player.set_position(Vector2(1025,1060))
	elif(location == 'Level 3'):
		$WorldCamera.limit_left = 0
		$WorldCamera.limit_right = 3552
		$WorldCamera.limit_top = 0
		$WorldCamera.limit_bottom = 2136
		$WorldCamera.set_zoom(Vector2(1.5,1.5))
		player.set_scale(Vector2(1, 1))
		player.set_position(Vector2(2314,42))
		
	new_level.goto_room.connect(_on_goto_room)
	#new_level.goto_main.connect(_on_goto_main)
	old_level=current_level
	current_level=new_level
	$Levels.call_deferred("remove_child", old_level)
	
	get_tree().paused=false

func checkpoint_entered(checkpoint : String):
	player.currentCheckpoint = checkpoint

func _on_goto_main():
	get_tree().paused=true
	emit_signal("end_game")
	
func _on_transition_faded_out():
	old_level.queue_free()
