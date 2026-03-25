extends Line2D
class_name Trail

@onready var body = $StaticBody2D

var last_rotation = 0
var shapes: Array[CollisionShape2D] = []

func _ready() -> void:
	width = 2
	z_index = -10

func update(pos: Vector2, rot: float) -> void:
	#print("trail: ", points)
	
	var p_size = points.size()
	
	if rot == last_rotation and p_size > 1:
		var diff := pos - points[p_size-1]
		
		points[p_size-1] = pos
		
		print(diff.length())
		
		shapes[p_size-2].shape.size.y += diff.length()
		shapes[p_size-2].position += diff/2
		
		return
	
	add_point(pos)
	p_size += 1
	
	last_rotation = rot
	
	#collision logic
	
	if p_size < 2: return
	
	var p1 := points[points.size() - 2]
	var p2 := pos
	var diff = p2-p1
	
	var shape := CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(diff.length(), 0.1)
	shape.position = p1 + diff/2
	shape.rotation = rot
	body.add_child(shape)
	shapes.push_back(shape)
	
