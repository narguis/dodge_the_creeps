extends Node

@export var mob_scene : PackedScene
var score

func _ready():
	pass
	
func game_over():
	#Shows the game over screen
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	

func new_game():
	#Restarts the position, HUD, timers and score
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	#This function forces all the mobs from your last game to
	#Delete themselves (free the queue) when a new game starts
	get_tree().call_group("mobs", "queue_free")


func _on_score_timer_timeout():
	#Updates the score
	score += 1
	
	$HUD.update_score(score)


func _on_start_timer_timeout():
	#This starts the score counter and makes mobs start spawning
	#When the start timer hits zero
	$MobTimer.start()
	$ScoreTimer.start()
	


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	#The mob_spawn_location is randomized on every instance
	mob_spawn_location.progress_ratio = randf()
	
	#The mobs are rotated inwards (towards the player)
	var direction = mob_spawn_location.rotation + PI / 2
	
	#They are then positioned on the random position from before
	mob.position = mob_spawn_location.position
	
	#The mobs are rotated by a random angle (while still pointing inwards)
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	#Their velocity is also random and they can only go on a
	#straight line based on their direction and rotation
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#After all this processing, the mob is spawned on the mob_scene
	add_child(mob)
