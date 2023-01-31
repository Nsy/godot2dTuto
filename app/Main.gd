extends Node

# dans l'inspector de "Main" on peut voir un "Mob Scene" et selectionner le Mob.tscn
export(PackedScene) var mob_scene # to allow us to choose the Mob scene we want to instance.
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$HUD.show_message("Dodge the\nCreeps!")
	randomize()

# lié au signal "hit" de la scene "Player" instancié dans la scene "Main"
func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	# The call_group() function calls the named function on every node in a group
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ScoreTimer_timeout():
	score = score + 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_start_game():
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	new_game();
