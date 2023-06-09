# A simple projectile, that have configurable damage and speed.
# Depends on command from ouside and collisions with objects' groups.
extends CharacterBody3D

@export var damage : float = 10
@export var speed := 1
@export var debug := false

var player_vars: PlayerVariables
var done := false

func get_player_vars():
	if not player_vars:
		player_vars = get_node("/root/GameMehanics")
	return player_vars

# To start flight needs global start and global direction point (e.x. player position)
func fly_from_to(start_pos, dir_pos):
	if debug:
		print_debug("A Bullet with d = ", damage, " and speed = ", speed, " is launched.")
	look_at_from_position(start_pos, dir_pos, Vector3.UP)
	velocity = position.direction_to(dir_pos) * speed

func _physics_process(delta):
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if (collision.get_collider() == null) or done:
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("Enemies"):
			var enemy = collision.get_collider()
			if debug:
				print_debug("A Bullet with d = ", damage, " and speed = ", speed, " reached an enemy!")

			enemy.receive_damage(damage * get_player_vars().get_revenge())
			done = true
			queue_free()
		if collision.get_collider().is_in_group("Player"):
			var player = collision.get_collider()
			if debug:
				print_debug("A Bullet with d = ", damage, " and speed = ", speed, " reached a player!")
			player.receive_damage(damage)
			done = true
			queue_free()
		else:
			if debug:
				print_debug("A Bullet with d = ", damage, " and speed = ", speed, " destoryed on obstacle!", collision.get_collider())
			done = true
			queue_free()
			
	
	move_and_slide()


func _on_timer_timeout():
	done = true
	if debug:
		print_debug("A Bullet with d = ", damage, " and speed = ", speed, " destoryed on timeout! ", $Timer.wait_time)
	queue_free()
