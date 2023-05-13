# Simple enemy movement implementation with 2 modes
# 1. If follow is commanded - will follow and wait when in range
# 2. Is not following - wait
extends CharacterBody3D
class_name EnemyMovement

@export var speed = 3
@export var target: Node3D
@export var is_flying:= false
@export var is_following:= false
@export var fly_height:= 0

@export var anim_idle = "idle"
@export var anim_walk = "walk"
@export var anim_attack = "attack"
@export var anim_die = "die"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var in_range = false
var is_attacking = false
var is_dead = false

func _ready():
	$AnimatedSprite3D.play(anim_idle)

# This function will be called from the Main scene.
func follow(node: Node3D, position: Vector3):
	if is_dead:
		return false
	
	is_following = true
	target = node
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(position, target.position, Vector3.UP)
	# We calculate a forward velocity that represents the speed.
	return true

func _physics_process(delta):
	if is_flying:
		# Check if flying the correct distance
		var floor_ray_cast: RayCast3D = $FloorRayCast
		var origin = floor_ray_cast.global_transform.origin
		var collision_point = floor_ray_cast.get_collision_point()
		var distance = origin.distance_to(collision_point)
		if distance > fly_height:
			velocity.y -= gravity * delta
		elif distance < fly_height:
			velocity.y += gravity * delta
	else:
		if not is_on_floor():
			velocity.y -= gravity * delta
		else:
			velocity.y = 0
	
	if is_dead:
		return
	if target:
		look_at(target.position, Vector3.UP)
	
	if not _is_busy():
		if target:
			if in_range:
				_attack_target()
			elif is_following:
				_seek_target()
			else:
				_wait()
		else:
			_wait()
	
	move_and_slide()

func _is_busy():
	return $AnimatedSprite3D.is_playing() and $AnimatedSprite3D.animation != anim_idle and $AnimatedSprite3D.animation != anim_walk

func _seek_target():
	if $AnimatedSprite3D.animation != anim_walk or not $AnimatedSprite3D.is_playing():
		$AnimatedSprite3D.play(anim_walk)
	
	var dir = position.direction_to(target.position)
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

func _attack_target():
	_wait()

func _wait():
	velocity.x = 0
	velocity.z = 0
	if $AnimatedSprite3D.animation != anim_idle or not $AnimatedSprite3D.is_playing():
		$AnimatedSprite3D.play(anim_idle)

func _on_area_3d_body_entered(body):
	if is_dead:
		return
	if target and target != body:
		return
	elif target and target == body:
		in_range = true
	else:
		target = body
		in_range = true

func _on_area_3d_body_exited(body):
	if target and target == body:
		in_range = false
		if not is_following:
			target = null

func _on_animated_sprite_3d_animation_finished():
	if is_dead:
		return

func _die():
	is_dead = true
	$DeathTimer.start()

func _on_death_timer_timeout():
	queue_free()
