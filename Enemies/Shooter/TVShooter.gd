extends CharacterBody3D

@export var bullet_scene: PackedScene
# Minimum speed of the mob in meters per second.
@export var speed = 3
@export var health = 40

@export var player: Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var in_range = false
var in_attack = false

func _ready():
	$AnimatedSprite3D.play("idle")

func receive_damage(dmg):
	health = health - dmg
	if health <= 0:
		health = 0
		$AnimatedSprite3D.play("die")

# This function will be called from the Main scene.
func follow(node: Node3D, position: Vector3):
	player = node
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(position, player.position, Vector3.UP)
	# We calculate a forward velocity that represents the speed.

func attack():
	if in_attack:
		return
		
	print("ATTACK!")
	in_attack = true
	shoot()
	
func is_shooting():
	return $AnimatedSprite3D.is_playing() and $AnimatedSprite3D.animation == "shoot"

func shoot():
	if $AnimatedSprite3D.is_playing() or $AnimatedSprite3D.animation != "shoot":
		$AnimatedSprite3D.play("shoot")
		print("Sending plasma!", position, player.position)
		var bullet = bullet_scene.instantiate()
		bullet.fly_from_to(to_global($LaunchMarker.position), player.position)
		get_tree().current_scene.add_child(bullet)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	if player and not in_range and not is_shooting():
		in_attack = false
		if $AnimatedSprite3D.is_playing() or $AnimatedSprite3D.animation != "walk":
			$AnimatedSprite3D.play("walk")
		look_at(player.position, Vector3.UP)
		var direction_to_player = position.direction_to(player.position)
		velocity.x = direction_to_player.x * speed
		velocity.z = direction_to_player.z * speed
	elif in_range:
		if player:
			look_at(player.position, Vector3.UP)
		velocity.x = 0
		velocity.z = 0
		if not in_attack:
			attack()
	elif not is_shooting():
		in_attack = false
	
	move_and_slide()



func _on_area_3d_body_entered(body):
	print("Player found!")
	in_range = true
	player = body


func _on_animated_sprite_3d_animation_looped():
	print("AGAIN!")
	if in_attack:
		shoot()
	else:
		$AnimatedSprite3D.play("idle")


func _on_area_3d_body_exited(body):
	in_range = false


func _on_animated_sprite_3d_animation_finished():
	if $AnimatedSprite3D.animation == "shoot()":	
		print("AGAIN!")
		if in_attack:
			shoot()
		else:
			$AnimatedSprite3D.play("idle")
	elif $AnimatedSprite3D.animation == "die":
		queue_free()
