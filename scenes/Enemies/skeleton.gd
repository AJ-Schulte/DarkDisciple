extends CharacterBody2D
var health = 100
var playerinAttZone = false
var player = null
var playerChase = false
const speed = 70
var isAttacking = false
var damagecooldown = true
var attackcooldown = true
var isDead = false
@onready var softcollision = $SoftCollision
signal skeletonDamage
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	dealwithDamage()
	attackcheck()
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
	move_and_slide()


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playerChase = true # Replace with function body.


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		playerChase = false # Replace with function body.


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		playerinAttZone = true # Replace with function body.


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		playerinAttZone = false
		isAttacking = false # Replace with function body.


func _on_damage_cooldown_timeout():
	damagecooldown = true 


func _on_attack_cooldown_timeout():
	attackcooldown = true # Replace with function body.
	


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		isAttacking = false # Replace with function body. # Replace with function body.
		
	if $AnimatedSprite2D.animation == "death":
		self.queue_free()

func attackcheck():
	if playerinAttZone ==true and attackcooldown==true:
			attackcooldown = false
			$AnimatedSprite2D.play("attack")
			isAttacking = true
			$attack_cooldown.start()
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = true    # disable
		#	get_node("enemy_hitbox/CollisionShape2D").disabled = false   # enable
			emit_signal("skeletonDamage")

func enemy():
	pass

func dealwithDamage():
	
	if playerinAttZone and global.isPlayerAttacking == true:
		if damagecooldown == true:
			health = health - 20
			damagecooldown = false
			attackcooldown = false
			$attack_cooldown.start()
			$AnimatedSprite2D.play("idle")
			$AnimatedSprite2D.modulate = Color(1,0,0)
			$hit.start()
			print("Skeleton Health: ", health)
			$damage_cooldown.start()
			
	if health <= 0 and isDead == false:
		$AnimatedSprite2D.play("death")
		isDead = true
		

func _on_hit_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1) # Replace with function body.


	
