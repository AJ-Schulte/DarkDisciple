extends CharacterBody2D
var health = 100
var playerinAttZone = false
var speed = 50
var playerChase = false
var player = null
var isAttacking = false
var damagecooldown = true
var attackcooldown = true
@onready var softcollision = $SoftCollision
signal doDamage

func _physics_process(delta):
	
	dealwithDamage()
	if playerChase==true and isAttacking ==false and playerinAttZone==false:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x < 0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		if playerChase==false and isAttacking ==false and playerinAttZone==false:
			$AnimatedSprite2D.play("idle")
	
	if playerinAttZone ==true and isAttacking ==false and attackcooldown==true:
			attackcooldown = false
			$AnimatedSprite2D.play("attack")
			isAttacking = true
			$attackcooldown.start()
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = true    # disable
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = false   # enable
			emit_signal("doDamage")
			
	if softcollision.is_colliding():
		position += softcollision.get_push_vector() * delta * 1000
		
			

	
func _on_detection_area_body_entered(body):
	player = body
	playerChase = true


func _on_detection_area_body_exited(body):
	player = null
	playerChase = false

func enemy():
	pass



func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		playerinAttZone = true
		
		
		
		
	
		


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		playerinAttZone = false
		isAttacking = false
	
	
func dealwithDamage():
	if playerinAttZone and global.isPlayerAttacking == true:
		if damagecooldown == true:
			health = health - 20
			damagecooldown = false
			print("Rogue Health: ", health)
			$damagecooldown.start()
			
		if health <= 0:
			self.queue_free()
		



	

	

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		isAttacking = false
	
	



func _on_damagecooldown_timeout():
	damagecooldown = true # Replace with function body.


func _on_attackcooldown_timeout():
	attackcooldown = true # Replace with function body.
