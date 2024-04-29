extends Node2D

@export var start_scene = "res://scenes/level_1.tscn"
var current_level:Node
var old_level:Node
var player:Node2D
var remoteTransform: Node2D
var goblins = 5
var skeleton = 5
var rogue = 5

signal deathScreen

#This runs as soon as an instance of "game.tscn" enters the scene tree, which means whenever you add it with "add_child()"
func _ready():
	#This is how we enter the first scene. It will be loaded and added as soon as we start the game.
	#	You can change the starting scene by setting a different scene file in the editor.
	
	current_level=load(start_scene).instantiate()
	current_level.add_child(load("res://scenes/player.tscn").instantiate())
	player = current_level.get_node("Player")
	
	$Levels.add_child(current_level)
	$Levels/"Level 1"/Camera2D.limit_left =0
	$Levels/"Level 1"/Camera2D.limit_right = 6888
	$Levels/"Level 1"/Camera2D.limit_top =0
	$Levels/"Level 1"/Camera2D.limit_bottom = 2952
	current_level.goto_room.connect(_on_goto_room)
	current_level.goto_main.connect(_on_goto_main)
	player.set_position(Vector2(522,364))
	player.set_rm("/root/Main/Game/Levels/Level 1/Camera2D")
	player.playerDeath.connect(Callable(self, "moveToDeath"))
	$Levels/"Level 1"/Bed.refreshHealth.connect(Callable(self, "refreshHealth"))
	call_deferred('setDamage')

func refreshHealth():
	player.refreshHealth()

func moveToDeath():
	get_tree().paused = true
	emit_signal("deathScreen")

func setDamage():
	if(current_level.get_node("rogue") != null):
		current_level.get_node("rogue").doDamage.connect(Callable(player, "_on_enemy_do_damage"))
		current_level.get_node("rogue2").doDamage.connect(Callable(player, "_on_enemy_do_damage"))
		current_level.get_node("rogue3").doDamage.connect(Callable(player, "_on_enemy_do_damage"))
		current_level.get_node("rogue4").doDamage.connect(Callable(player, "_on_enemy_do_damage"))
		current_level.get_node("rogue5").doDamage.connect(Callable(player, "_on_enemy_do_damage"))
	elif(current_level.get_node("goblin") != null):
		current_level.get_node("goblin").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
		current_level.get_node("goblin2").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
		current_level.get_node("goblin3").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
		current_level.get_node("goblin4").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
	elif(current_level.get_node("cgoblin") != null):
		current_level.get_node("cgoblin").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
		current_level.get_node("cgoblin2").goblinDamage.connect(Callable(player, "_on_goblin_goblin_damage"))
	elif(current_level.get_node("Golem") != null):
		current_level.get_node("Golem").GolemDoDamage.connect(Callable(player, "_on_golem_golem_do_damage"))
	elif(current_level.get_node("bigskeleton") != null):
		current_level.get_node("bigskeleton").skeletonDamage.connect(Callable(player, "_on_bigskeleton_skeleton_damage"))
	elif(current_level.get_node("cskeleton") != null):
		print("WOW")
		current_level.get_node("cskeleton2").skeletonDamage.connect(Callable(player, "_on_skeleton_skeleton_damage"))
		current_level.get_node("cskeleton").skeletonDamage.connect(Callable(player, "_on_skeleton_skeleton_damage"))
		current_level.get_node("cskeleton3").skeletonDamage.connect(Callable(player, "_on_skeleton_skeleton_damage"))
		current_level.get_node("cskeleton4").skeletonDamage.connect(Callable(player, "_on_skeleton_skeleton_damage"))
	elif(current_level.get_node("swordsman") != null):
		print("NOT NULL")
		current_level.get_node("swordsman").swordsmanDamage.connect(Callable(player, "_on_swordsman_swordsman_damage"))
		
		
func _on_goto_room(scene:PackedScene, location):
	#If we instance the new level insted of using change_scene(), we can do our setup in between. 
	#like using a tween to slowly move the camera to the new area.
	get_tree().paused=true
	
	var new_level=scene.instantiate()
	$Levels.call_deferred("add_child", new_level)
	player.reparent(new_level)
	
	if(location == 'Castle'):
		player.set_rm("/root/Main/Game/Levels/Castle/Camera2D")
		new_level.get_node("Camera2D").limit_left =-442
		new_level.get_node("Camera2D").limit_right = 2288
		new_level.get_node("Camera2D").limit_top = -265
		new_level.get_node("Camera2D").limit_bottom = 1296
		player.set_position(Vector2(900,900))
		player.set_scale(Vector2(1, 1))
		
		call_deferred('setDamage')
	elif (location == 'Church'):
		player.set_rm("/root/Main/Game/Levels/Church/Camera2D")
		new_level.get_node("Camera2D").limit_left =0
		new_level.get_node("Camera2D").limit_right = 3792
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 2570
		new_level.get_node("Camera2D").set_zoom(Vector2(0.8, 0.8))
		player.set_position(Vector2(2300,2100))
		player.set_scale(Vector2(2, 2))
		call_deferred('setDamage')
	elif(location == 'Level 1'):
		player.set_rm("/root/Main/Game/Levels/Level 1/Camera2D")
		new_level.get_node("Camera2D").limit_left =0
		new_level.get_node("Camera2D").limit_right = 6888
		new_level.get_node("Camera2D").limit_top =0
		new_level.get_node("Camera2D").limit_bottom = 2952
		new_level.get_node("Camera2D").set_zoom(Vector2(1,1))
		player.set_scale(Vector2(1, 1))
		if(current_level == $Levels/Castle):
			player.set_position(Vector2(522,364))
		elif(current_level == $Levels/Church):
			player.set_position(Vector2(5944, 2112))
		new_level.get_node("Bed").refreshHealth.connect(Callable(self, "refreshHealth"))
		call_deferred('setDamage')
	elif(location == 'Colosseum'):
		player.set_rm("null")
		player.set_rm("root/Main/Game/Levels/Colosseum/Camera2D")
		new_level.get_node("Camera2D").limit_left = 0
		new_level.get_node("Camera2D").limit_right = 6800
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 4560
		new_level.get_node("Camera2D").set_zoom(Vector2(0.4, 0.3))
		player.set_position(Vector2(4560,3968))
		player.set_scale(Vector2(3,3))
	elif(location == 'House'):
		player.set_rm("/root/Main/Game/Levels/House/Camera2D")
		new_level.get_node("Camera2D").limit_left = 0
		new_level.get_node("Camera2D").limit_right = 576
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 383
		new_level.get_node("Camera2D").set_zoom(Vector2(2,2))
		player.set_position(Vector2(272, 296))
		player.set_scale(Vector2(0.8,0.8))
		player.SPEED = 160.0
		new_level.get_node("Bed").refreshHealth.connect(Callable(self, "refreshHealth"))
		call_deferred('setDamage')
	if(location == 'Level 2'):
		print(player.position)
		
		player.set_rm("/root/Main/Game/Levels/Level 2/Camera2D")
		new_level.get_node("Camera2D").limit_left = -1035
		new_level.get_node("Camera2D").limit_right = 8950.5
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 5255
		new_level.get_node("Camera2D").set_zoom(Vector2(1,1))
		player.set_scale(Vector2(1, 1))
		if(current_level == $Levels/House):
			player.set_position(Vector2(-1526,758))
			player.SPEED = 320.0
		elif(current_level == $Levels/Church):
			player.set_position(Vector2(3950, 1408))
		new_level.get_node("Bed").refreshHealth.connect(Callable(self, "refreshHealth"))
		new_level.get_node("Bed2").refreshHealth.connect(Callable(self, "refreshHealth"))
		call_deferred('setDamage')
	elif(location == 'Final Boss Area'):
		player.set_rm("/root/Main/Game/Levels/Final Boss Area/Camera2D")
		new_level.get_node("Camera2D").limit_left = 0
		new_level.get_node("Camera2D").limit_right = 1925
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 1296
		new_level.get_node("Camera2D").set_zoom(Vector2(1.2, 1.2))
		player.set_position(Vector2(1025,1060))
		call_deferred('setDamage')
	elif(location == 'Level 3'):
		player.set_rm("/root/Main/Game/Levels/Level 3/Camera2D")
		new_level.get_node("Camera2D").limit_left = 0
		new_level.get_node("Camera2D").limit_right = 3552
		new_level.get_node("Camera2D").limit_top = 0
		new_level.get_node("Camera2D").limit_bottom = 2136
		new_level.get_node("Camera2D").set_zoom(Vector2(1.5,1.5))
		player.set_scale(Vector2(1, 1))
		player.set_position(Vector2(2314,42))
		new_level.get_node("Bed").refreshHealth.connect(Callable(self, "refreshHealth"))
		new_level.get_node("Bed2").refreshHealth.connect(Callable(self, "refreshHealth"))
		new_level.get_node("Bed3").refreshHealth.connect(Callable(self, "refreshHealth"))
		call_deferred('setDamage')
		
	new_level.goto_room.connect(_on_goto_room)
	#new_level.goto_main.connect(_on_goto_main)
	old_level=current_level
	current_level=new_level
	$Levels.call_deferred("remove_child", old_level)
	
	get_tree().paused=false

func checkpoint_entered(checkpoint : String):
	player.currentCheckpoint = checkpoint

func _on_goto_main():
	get_tree().paused=true
	emit_signal("end_game")
	
func _on_transition_faded_out():
	old_level.queue_free()



