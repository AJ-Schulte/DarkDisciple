extends Node2D

var wallremove = false
var cwall = false
signal goto_room(room)
signal goto_main
func _ready():
	pass # Replace with function body.
func _process(_delta):
	if global.golemDead == true and wallremove==false:
		remove_child($Wall)
		wallremove = true
	if global.skeletonDead == true and cwall== false:
		remove_child($CWall)		
		cwall = true
	if global.swordsmanDead == true:
		global.swordsmanDead = false
		
func _on_transition_entered(_body : PhysicsBody2D, target_scene_path:String, location_entered:String):
	emit_signal("goto_room", load(target_scene_path), location_entered)

func _on_quit_entered(_body : PhysicsBody2D):
	emit_signal("goto_main")
