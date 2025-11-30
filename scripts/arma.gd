class_name weaponController extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_timer: Timer = $FireTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var barrel: Node3D = $"../../barrel"
@onready var ray: RayCast3D = $RayCast3D
@onready var arma: weaponController = $"."
@onready var hud: HUD = $"../../../../../HUD"

@export var fire_rate := 0.12   # tempo entre tiros (debounce)
@export var max_distance := 200.0

var can_shoot := true
var shoot_held := false

@export var ammo = 20;

signal gunFired

func _ready():
	for p in get_tree().get_nodes_in_group("pickups"):
		p.refil.connect(_on_refil)
	fire_timer.one_shot = true
	fire_timer.wait_time = fire_rate
	fire_timer.timeout.connect(_on_fire_timer_timeout)

	ray.target_position = Vector3.FORWARD * -1
	ray.enabled = true


func _physics_process(_delta):
	hud.displayAMMO(ammo);
	# Clique inicial
	if Input.is_action_just_pressed("shoot"):
		shoot_held = true
		try_shoot()
	
	shoot_held = Input.is_action_pressed("shoot")


func try_shoot():
	if not can_shoot:
		return
	if ammo > 0:
		shoot()
	can_shoot = false
	fire_timer.start()


func shoot():
	animation_player.play("gunRecoil")
	animation_player.seek(0, true)
	
	gunFired.emit()
	audio_player.play()
	perform_raycast()
	ammo = ammo - 1;

func _on_refil():
	ammo = 20;

func perform_raycast():
	ray.force_raycast_update()
	ray.global_transform = barrel.global_transform
	ray.target_position = Vector3(0, 0, -1) * 200
	ray.force_raycast_update()

	if ray.is_colliding():
		var obj = ray.get_collider()
		var point = ray.get_collision_point()
		var normal = ray.get_collision_normal()
		BulletDecalPool.spawn_bullet_decal(point, normal, obj, ray.global_basis)


func _on_fire_timer_timeout():
	can_shoot = true
	if shoot_held:
		try_shoot()
