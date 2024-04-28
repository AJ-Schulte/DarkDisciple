extends CharacterBody2D
var health = 100
var playerinAttZone = false
var speed = 150
var playerChase = false
var player = null
var isAttacking = false
var damagecooldown = true
var attackcooldown = true
var isAlive = true
@onready var softcollision = $SoftCollision
signal GolemDoDamage

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
		if playerChase==false and isAttacking ==false and isAlive:
			$AnimatedSprite2D.play("idle")
	
	
			
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
			health = health - 10
			damagecooldown = false
			$AnimatedSprite2D.modulate = Color(1,0,1)
			$hit.start()
			print("Golem Health: ", health)
			$damage_cooldown.start()
			
	if health <= 0 and isAlive == true:
		$AnimatedSprite2D.play("death")
		isAlive = false
		global.golemDead = true
		

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		isAttacking = false
		if playerinAttZone:
			emit_signal("GolemDoDamage")
	if $AnimatedSprite2D.animation == "death":
		self.queue_free()
		isAlive = false
		
	
func attackcheck():
	if playerinAttZone ==true and isAttacking ==false and attackcooldown==true and isAlive:
		attackcooldown = false
		$AnimatedSprite2D.play("attack")
		isAttacking = true
		
		$attack_cooldown.start()
		
		


func _on_attack_cooldown_timeout():
	attackcooldown = true  # Replace with function body.


func _on_damage_cooldown_timeout():
	damagecooldown = true # Replace with function body.


func _on_hit_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1) # Replace with function body.
