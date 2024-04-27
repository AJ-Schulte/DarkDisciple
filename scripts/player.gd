extends CharacterBody2D
@export var health = 100;
@export var isAttacking = false;
@export var SPEED = 300.0
var enemyinRange = false
var enemyCooldown = true
var deflectCooldown = true
var isAlive = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#enemy_attack()
	if health <= 0:
		isAlive = false
		health = 0
		print("player death") #End Screend
		
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction = Input.get_axis("ui_left", "ui_right")
	if x_direction and global.isPlayerAttacking== false and global.isDeflecting== false:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var y_direction = Input.get_axis("ui_up", "ui_down")
	if y_direction and global.isPlayerAttacking== false and global.isDeflecting== false :
		velocity.y = y_direction * SPEED
		
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.x !=0 and global.isPlayerAttacking ==false and global.isDeflecting==false :
		$AnimatedSprite2D.play("walk")
		
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif velocity.y != 0 and global.isPlayerAttacking==false and global.isDeflecting==false:
		$AnimatedSprite2D.play("walk")
	else:
		if global.isPlayerAttacking == false and global.isDeflecting ==false:
			$AnimatedSprite2D.play("idle")
	
	
	if Input.is_action_just_pressed("attack") and not isAttacking and global.isDeflecting ==false:
		global.isPlayerAttacking = true;
		$AnimatedSprite2D.play("attack")	
	
	if Input.is_action_just_pressed("deflect") and global.isDeflecting ==false and deflectCooldown ==true and isAttacking ==false:
		global.isDeflecting = true;
		print(global.isDeflecting)
		deflectCooldown = false
		$AnimatedSprite2D.play("deflect")	
		$deflectcooldown.start();
		
	
	move_and_slide()





func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		global.isPlayerAttacking = false
	elif $AnimatedSprite2D.animation == "deflect":
		global.isDeflecting = false

		
	


func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemyinRange = true


func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemyinRange = false
		
	
	
func player():
	pass


func _on_attackcooldown_timeout():
	enemyCooldown = true # Replace with function body.





func _on_enemy_do_damage():
	
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 20
			print("Health not deflected: ",health)
			player_damaged()
		enemyCooldown = false
		$attackcooldown.start()
		print(health)


func _on_deflectcooldown_timeout():
	deflectCooldown = true # Replace with function body.
	global.isDeflecting =false






func _on_goblin_goblin_damage():
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 30
			player_damaged()
			print("Health not deflected: ",health)
		
		enemyCooldown = false
		$attackcooldown.start()
		print(health)# Replace with function body.

func player_damaged():
	$AnimatedSprite2D.modulate = Color(1,0,0)
	$damaged.start()

func _on_damaged_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1)


func _on_skeleton_skeleton_damage():
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 20
			print("Health not deflected: ",health)
			player_damaged()
		enemyCooldown = false
		$attackcooldown.start()
		print(health) # Replace with function body.
