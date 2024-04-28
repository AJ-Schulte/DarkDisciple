extends CharacterBody2D
var health = 100
var playerinAttZone = false
var speed = 50
var playerChase = false
var player = null
var isAttacking = false
var damagecooldown = true
var attackcooldown = true
var isAlive = true
@onready var softcollision = $SoftCollision
signal doDamage

func _physics_process(delta):
	attackcheck()
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
	
	
			
	if softcollision.is_colliding():
		position += softcollision.get_push_vector() * delta * 1000
		
			

	
func _on_detection_area_body_entered(body):
	player = body
	playerChase = true


func _on_detection_area_body_exited(_body):
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
			$AnimatedSprite2D.modulate = Color(1,0,0)
			$hit.start()
			$damagecooldown.start()
			
		if health <= 0 and isAlive:
			self.queue_free()
		



	

	

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		isAttacking = false
		if playerinAttZone:
			emit_signal("doDamage")
	



func _on_damagecooldown_timeout():
	damagecooldown = true # Replace with function body.


func _on_attackcooldown_timeout():
	attackcooldown = true # Replace with function body.

func attackcheck():
	if playerinAttZone ==true and isAttacking ==false and attackcooldown==true:
		attackcooldown = false
		$AnimatedSprite2D.play("attack")
		isAttacking = true
		$attackcooldown.start()
		


func _on_hit_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1) # Replace with function body.
