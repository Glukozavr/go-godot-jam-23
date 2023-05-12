extends Node3D

signal ammo_update

@export_node_path("Camera3D") var cam_path := NodePath("Camera")
@onready var cam: Camera3D = get_node(cam_path)

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0
@export var weapon: Node3D
var weapon_ready: Node3D
var mouse_axis := Vector2()
var rot := Vector3()

func _ready():
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)
	$Guns/Gun.visible = false
	$Guns/Sword.visible = false

func _process(delta):
	if Input.is_action_pressed("fire") and weapon:
		# Check for bullets, but genuinly shoot
		print("Attack is in order")
		weapon.play_shoot()

func get_ammo():
	if weapon:
		return weapon.ammo
	return 0
func get_current_load():
	if weapon:
		return weapon.current_load
	return 0
func get_load():
	if weapon:
		return weapon.load
	return 0

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	var joystick_axis := Input.get_vector(&"look_left", &"look_right",
			&"look_down", &"look_up")
	
	if joystick_axis != Vector2.ZERO:
		mouse_axis = joystick_axis * 1000.0 * delta
		camera_rotation()


func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x

func use_weapon(weapon_str):
	if weapon_str == "sword":
		if weapon and weapon != $Guns/Sword:
			weapon.play_hide()
			weapon_ready = $Guns/Sword
		else:
			weapon = $Guns/Sword
			weapon.visible = true
			weapon.play_show()
	elif weapon_str == "gun":
		if weapon and weapon != $Guns/Gun:
			weapon.play_hide()
			weapon_ready = $Guns/Gun
		else:
			weapon = $Guns/Gun
			weapon.visible = true
			weapon.play_show()
			

func _on_start_timer_timeout():
	if weapon:
		weapon.play_show()


func _on_gun_on_ammo_update(ammo, current_load, load):
	ammo_update.emit(ammo, current_load, load)


func _on_hidden():
	if weapon_ready:
		weapon.visible = false
		weapon = weapon_ready
		weapon.visible = true
		weapon.play_show()


func _on_sword_on_ammo_update(ammo, current_load, load):
	ammo_update.emit(ammo, current_load, load)
