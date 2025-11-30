extends Node3D

@export var amount : Vector2
@export var snap : float
@export var speed : float

var current_rotation : Vector3
var target_rotation : Vector3

@export var controller : weaponController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller.gunFired.connect(add_recoil)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap * delta)
	basis = Quaternion.from_euler(current_rotation)
	
func  add_recoil() -> void:
	target_rotation += Vector3(amount.x, randf_range(-amount.y, amount.y), 0)
