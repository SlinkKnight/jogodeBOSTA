extends Area3D
signal refil;

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is PlayerCharacter:
			refil.emit()
