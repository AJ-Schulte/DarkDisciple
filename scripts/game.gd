extends Node2D

@export var start_scene = "res://scenes/level_1.tscn"
var current_level:Node2D
var old_level:Node2D

#This runs as soon as an instance of "game.tscn" enters the scene tree, which means whenever you add it with "add_child()"
func _ready():
	#This is how we enter the first scene. It will be loaded and added as soon as we start the game.
	#	You can change the starting scene by setting a different scene file in the editor.
	current_level=load(start_scene).instantiate()
	$Levels.add_child(current_level)
	current_level.goto_room.connect(_on_goto_room)
	current_level.goto_main.connect(_on_goto_main)
	

func _on_goto_room(scene:PackedScene):
	#If we instance the new level insted of using change_scene(), we can do our setup in between. 
	#like using a tween to slowly move the camera to the new area.
	get_tree().paused=true
	
	var new_level=scene.instantiate()
	$Levels.add_child(new_level)
	
	
	new_level.goto_room.connect(_on_goto_room)
	new_level.goto_main.connect(_on_goto_main)
	old_level=current_level
	current_level=new_level
	$Levels.remove_child(old_level)
	
	get_tree().paused=false
	
func _on_goto_main():
	get_tree().paused=true
	emit_signal("end_game")
	
func _on_transition_faded_out():
	old_level.queue_free()
