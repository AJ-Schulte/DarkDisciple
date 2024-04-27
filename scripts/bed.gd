extends Sprite2D

@export var checkpoint:String

func _on_checkpoint_entered(_body):
	emit_signal('checkpoint_entered', checkpoint)

