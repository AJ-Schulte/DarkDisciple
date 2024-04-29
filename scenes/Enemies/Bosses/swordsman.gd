extends CharacterBody2D
var health = 150
var playerinAttZone = false
var player = null
var playerChase = false
const speed = 70
var isAttacking = false
var damagecooldown = true
var attackcooldown = true
var isAlive = true
@onready var softcollision = $SoftCollision
signal swordsmanDamage
signal victoryScreen

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	dealwithDamage()
	attackcheck()
	if playerChase==true and isAttacking ==false and playerinAttZone==false and isAlive:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x < 0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		if playerChase==false and isAttacking ==false and playerinAttZone==false and isAlive:
			$AnimatedSprite2D.play("idle")


	
	
	
	
	
	
	
	if softcollision.is_colliding():
		position += softcollision.get_push_vector() * delta * 1000

func _on_damage_cooldown_timeout():
	damagecooldown = true 


func _on_attack_cooldown_timeout():
	attackcooldown = true# Replace with function body.


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playerChase = true
	


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		playerChase = false


func dealwithDamage():
	
	if playerinAttZone and global.isPlayerAttacking == true:
		if damagecooldown == true:
			health = health - 20
			$hurt.play()
			damagecooldown = false
			attackcooldown = false
			$AnimatedSprite2D.modulate = Color(1,0,0)
			$hit.start()
			print("Swordsman Health: ", health)
			$damage_cooldown.start()
			
		if health <= 0 and isAlive:
			
			$AnimatedSprite2D.play("death")
			isAlive = false
			$death.play()
			
		



func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack1":
		isAttacking = false # Replace with function body.
		$attack_cooldown.start()
		if playerinAttZone:
			emit_signal("swordsmanDamage")
	elif $AnimatedSprite2D.animation == "attack2":
		isAttacking = false
		$attack_cooldown.start()
		if playerinAttZone:
			emit_signal("swordsmanDamage")
	
	if $AnimatedSprite2D.animation == "death":
		global.swordsmanDead = true
		self.queue_free()
		emit_signal("victoryScreen")
		#$screen.start()
		
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		playerinAttZone = true
		


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		playerinAttZone = false
		

func attackcheck():
	if playerinAttZone ==true and attackcooldown==true and isAlive:
		attackcooldown = false
		var num = randf()
		print(num)
		if num >=0.5:
			$AnimatedSprite2D.play("attack1")
		else:
			$AnimatedSprite2D.play("attack2")
		isAttacking = true
		
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = true    # disable
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = false   # enable
		


func _on_hit_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1) # Replace with function body.


func _on_screen_timeout():
	emit_signal("victoryScreen") # Replace with function body.
