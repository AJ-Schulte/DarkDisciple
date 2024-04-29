extends Sprite2D

@export var checkpoint:String
signal refreshHealth

func _on_checkpoint_entered(_body):
	print("checkpoint updated")
	global.currentCheckpoint = checkpoint
	global.playerHealth = 100
	print(global.playerHealth)
	emit_signal("refreshHealth")

