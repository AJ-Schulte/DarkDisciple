extends Node2D


signal goto_room(room)
signal goto_main

func _on_transition_entered(_body : PhysicsBody2D, target_scene_path:String):
	emit_signal("goto_room", load(target_scene_path))

func _on_quit_entered(_body : PhysicsBody2D):
	emit_signal("goto_main")
