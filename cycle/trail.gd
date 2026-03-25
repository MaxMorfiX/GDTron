extends Line2D
class_name Trail

@onready var body = $StaticBody2D

var last_rotation = 0
var shapes: Array[CollisionShape2D] = []
var max_length: float = 1500

var length: float = 0

func _ready() -> void:
	width = 2
	z_index = -10

func update(pos: Vector2, rot: float) -> void:
	#print("trail: ", points)
	
	var p_size = points.size()
	
	if rot == last_rotation and p_size > 1:
		var diff := pos - points[p_size-1]
		var diffl = diff.length()
		
		points[p_size-1] = pos
		
		shapes[p_size-2].shape.size.y += diffl
		shapes[p_size-2].position += diff/2
		
		handle_length(diffl)
		
		return
	
	add_point(pos)
	p_size += 1
	
	last_rotation = rot
	
	#collision logic
	
	if p_size < 2: return
	
	var p1 := points[points.size() - 2]
	var p2 := pos
	var diff := p2-p1
	var diffl := diff.length()
	
	handle_length(diffl)
	
	var shape := CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(diffl, 0.1)
	shape.position = p1 + diff/2
	shape.rotation = rot
	body.add_child(shape)
	shapes.push_back(shape)

func handle_length(add_value: float = 0) -> void:
	
	length += add_value
	#print("l: ", length)
	if length < max_length: return
	
	var shorten_amount := length - max_length
	var vec2 := points[1] - points[0]
	var l = vec2.length()
	#print("p1: ", points[1], "p2: ", points[2])
	#print("l: ", l, ", shorten_amount: ", shorten_amount, "vec2: ", vec2)
	if l <= shorten_amount or shapes[0].shape.size.y <= shorten_amount: #very bad workaround that has to be implemented
		remove_point(0)
		
		length -= l
		
		shapes[0].queue_free()
		shapes.remove_at(0)
		
		handle_length()
		return
	
	#print("moving toward; initial: ", points[0])
	points[0] = points[0].move_toward(points[1], shorten_amount)
	length -= shorten_amount
	if shapes[0].shape.size.y - shorten_amount < 0:
		print(shapes[0].shape.size.y)
		
	shapes[0].shape.size.y -= shorten_amount
	shapes[0].position -= (points[0]-points[1]).normalized()*shorten_amount

	
	#print("moving toward; after: ", points[0])
