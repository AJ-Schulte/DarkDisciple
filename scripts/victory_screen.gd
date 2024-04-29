extends Control

signal returnToMenu





func _on_main_menu_pressed():
	print("resetting globals")
	global.skeletonDead = false
	global.isPlayerAttacking = false
	global.playerHealth = 100
	global.isDeflecting = false
	global.isAlive = true
	global.golemDead = false
	global.swordsmanDead = false
	global.currentCheckpoint = "Level1Checkpoint1"
	emit_signal("returnToMenu")
