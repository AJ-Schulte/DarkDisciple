extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	

	move_and_slide()


func _on_damage_cooldown_timeout():
	pass # Replace with function body.


func _on_attack_cooldown_timeout():
	pass # Replace with function body.


func _on_enemy_hitbox_body_entered(body):
	pass # Replace with function body.


func _on_enemy_hitbox_body_exited(body):
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	pass # Replace with function body.


func _on_detection_area_body_exited(body):
	pass # Replace with function body.
