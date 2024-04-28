extends Control

signal restart

func _on_respawn_pressed():
	print("emitting restart")
	global.playerHealth = 100
	global.isAlive = true
	emit_signal("restart")


func _on_quit_pressed():
	get_tree().quit()
