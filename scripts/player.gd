extends CharacterBody2D
@export var health = global.playerHealth;
@export var isAttacking = false;
@export var SPEED = 300.0
var enemyinRange = false
var enemyCooldown = true
var deflectCooldown = true
@export var worldscene ="res://scenes://game.tscn"
var current_level:Node2D
var playerCam = Camera2D
var worldcamera =Node2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal playerDeath

	
	
	
func _physics_process(delta):
	if health <= 0 and global.isAlive:
		global.isAlive = false
		print(global.isAlive)
		health = 0
		$AnimatedSprite2D.play("death")
		print("player death") #End Screend
		emit_signal("playerDeath")
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta


	var x_direction = Input.get_axis("ui_left", "ui_right")
	if x_direction and global.isPlayerAttacking== false and global.isDeflecting== false and global.isAlive:
		velocity.x = x_direction * SPEED
	else:
		if global.isAlive:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var y_direction = Input.get_axis("ui_up", "ui_down")
	if y_direction and global.isPlayerAttacking== false and global.isDeflecting== false and global.isAlive :
		velocity.y = y_direction * SPEED
		
	else:
		if global.isAlive:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.x !=0 and global.isPlayerAttacking ==false and global.isDeflecting==false and global.isAlive:
		$AnimatedSprite2D.play("walk")
		
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif velocity.y != 0 and global.isPlayerAttacking==false and global.isDeflecting==false and global.isAlive:
		$AnimatedSprite2D.play("walk")
	else:
		if global.isPlayerAttacking == false and global.isDeflecting ==false and global.isAlive:
			$AnimatedSprite2D.play("idle")
	
	
	if Input.is_action_just_pressed("attack") and not isAttacking and global.isDeflecting ==false and global.isAlive:
		global.isPlayerAttacking = true;
		$AnimatedSprite2D.play("attack")	
	
	if Input.is_action_just_pressed("deflect") and global.isDeflecting ==false and deflectCooldown ==true and isAttacking ==false and global.isAlive:
		global.isDeflecting = true;
		print("Deflecting: ", global.isDeflecting)
		deflectCooldown = false
		$AnimatedSprite2D.play("deflect")	
		$deflectFrames.start()
		
		
	
	move_and_slide()





func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		global.isPlayerAttacking = false
	elif $AnimatedSprite2D.animation == "deflect":
		global.isDeflecting = false
	elif $AnimatedSprite2D.animation == "death":
		self.queue_free()
		#change scene
		
	
func refreshHealth():
	print("refresh health")
	health = global.playerHealth
	$CanvasLayer.set_current_health(global.playerHealth)


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


func set_rm(remote_path : String):
	$rm.remote_path = remote_path


func _on_enemy_do_damage():
	
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)			
			health -= 20
			$CanvasLayer.take_damage(20)
			print("Health not deflected: ",health)
			player_damaged()
		elif(global.isDeflecting):
			deflectColor()
		enemyCooldown = false
		$attackcooldown.start()
		print(health)


func _on_deflectcooldown_timeout():
	deflectCooldown = true # Replace with function body.
	





func _on_goblin_goblin_damage():
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 30
			$CanvasLayer.take_damage(30)
			player_damaged()
			print("Health not deflected: ",health)
		elif(global.isDeflecting):
			deflectColor()
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
			$CanvasLayer.take_damage(20)
			print("Health not deflected: ",health)
			player_damaged()
		elif(global.isDeflecting):
			deflectColor()
		enemyCooldown = false
		
		$attackcooldown.start()
		print(health) # Replace with function body.


func _on_golem_golem_do_damage():
	print("work")
	print("inrange: ", enemyinRange)
	print("cooldown: ", enemyCooldown)
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 50
			$CanvasLayer.take_damage(50)
			print("Health not deflected: ",health)
			player_damaged()
			
			
		elif(global.isDeflecting):
			deflectColor()
		enemyCooldown = false
		$attackcooldown.start()
		print(health) # Replace with function body. # Replace with function body.


func _on_deflect_frames_timeout():
	global.isDeflecting = false # Replace with function body.
	print("Deflecting: ", global.isDeflecting)
	$deflectcooldown.start()

func deflectColor():
	$AnimatedSprite2D.modulate = Color(0,1,0,0.5)
	$perfectDeflect.start()
func _on_perfect_deflect_timeout():
	$AnimatedSprite2D.modulate = Color(1,1,1) # Replace with function body.




func _ready():
	
	#worldcamera = worldscene.get_node("WorldCamera")
	#playerCam = get_node("Camera2D")
	#playerCam.transform = worldcamera.global_transform # Replace with function body. # Replace with function body.
	pass



func _on_swordsman_swordsman_damage():
	if enemyinRange and enemyCooldown == true:
		if global.isDeflecting == false:
			print("Health: ",health)
			health -= 30
			print("Health not deflected: ",health)
			player_damaged()
		elif(global.isDeflecting):
			deflectColor()
		enemyCooldown = false
		$attackcooldown.start()
		print(health) # Replace with function body. # Replace with function body. # Replace with function body.
