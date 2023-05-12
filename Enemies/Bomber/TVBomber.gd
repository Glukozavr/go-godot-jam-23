extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var speed = 3
@export var health = 20
@export var damage = 20

# Distance from the floor for the flight
@export var fly_height = 2

@export var player: Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var frame_num = 0
@onready var last_frame = $Piviot/Character.hframes

func receive_damage(dmg):
	health = health - dmg
	if health <= 0:
		health = 0
		queue_free()

# This function will be called from the Main scene.
func follow(node: Node3D, position: Vector3):
	player = node
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(position, player.position, Vector3.UP)
	# We calculate a forward velocity that represents the speed.

func _physics_process(delta):
	# Check if flying the correct distance
	var floor_ray_cast: RayCast3D = $FloorRayCast
	var origin = floor_ray_cast.global_transform.origin
	var collision_point = floor_ray_cast.get_collision_point()
	var distance = origin.distance_to(collision_point)
	if distance > fly_height:
		velocity.y -= gravity * delta
	elif distance < fly_height:
		velocity.y += gravity * delta
	
	if player:
		look_at(player.position, Vector3.UP)
		var direction_to_player = position.direction_to(player.position)
		velocity.x = direction_to_player.x * speed
		velocity.z = direction_to_player.z * speed

	# Iterate through all collisions that occurred this frame
	# in C this would be for(int i = 0; i < collisions.Count; i++)
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if (collision.get_collider() == null):
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("Player"):
			var player = collision.get_collider()
			print("Reached player!")
			player.receive_damage(damage)
			queue_free()
	
	move_and_slide()

func _on_animation_timer_timeout():
	frame_num = frame_num + 1
	if frame_num > last_frame:
		frame_num = 0
	
	$Piviot/Character.frame = frame_num
