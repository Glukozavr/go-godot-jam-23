extends CharacterBody3D

@export var damage := 10
@export var speed := 1


func fly_from_to(start_pos, dir_pos):
	look_at_from_position(start_pos, dir_pos, Vector3.UP)
	velocity = position.direction_to(dir_pos) * speed


func _physics_process(delta):
	# Iterate through all collisions that occurred this frame
	# in C this would be for(int i = 0; i < collisions.Count; i++)
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if (collision.get_collider() == null):
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("Enemies"):
			var enemy = collision.get_collider()
			print("Got you, enemy!")
			enemy.receive_damage(damage)
			queue_free()
		if collision.get_collider().is_in_group("Player"):
			var player = collision.get_collider()
			print("Got you, player!")
			player.receive_damage(damage)
			queue_free()
		else:
			print("Hit something different!")
			queue_free()
			
	
	move_and_slide()


func _on_timer_timeout():
	print("Times out!")
	queue_free()
