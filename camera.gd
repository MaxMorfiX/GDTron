extends Camera2D

@onready var cycle: Cycle = get_parent()

func _process(delta: float) -> void:
	var z: float = exp(cycle.base_speed/cycle.speed)*0.5
	
	zoom = Vector2(z, z)
