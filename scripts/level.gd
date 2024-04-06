extends Node2D


signal goto_room(room)
signal goto_main

func _on_transition_entered(_body : PhysicsBody2D, target_scene_path:String, location_entered:String):
	emit_signal("goto_room", load(target_scene_path), location_entered)

func _on_quit_entered(_body : PhysicsBody2D):
	emit_signal("goto_main")
