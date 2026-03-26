extends Line2D
class_name Trail

@onready var body := $StaticBody2D

var last_rotation: float = 0
var shapes: Array[CollisionShape2D] = []
var max_length: float = 1500

var length: float = 0

func _ready() -> void:
	width = 2
	z_index = -10

func update(pos: Vector2, rot: float) -> void:
	#print("trail: ", points)
	
	#extend the last point
	if rot == last_rotation and points.size() > 1:
		extend_last_point_to(pos)
		return
	#else create a new point
	
	add_new_point(pos, rot)

func extend_last_point_to(pos: Vector2) -> void:
	
	var p_size: int = points.size()
	
	var diff := pos - points[p_size-1]
	var diffl := diff.length()
	
	points[p_size-1] = pos
	
	shapes[p_size-2].shape.size.y += diffl
	shapes[p_size-2].position += diff/2
	
	handle_length(diffl)

func  add_new_point(pos: Vector2, rot: float) -> void:
	
	add_point(pos)
	last_rotation = rot
	
	#collision logic
	
	if points.size() < 2: return
	
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
	var l := vec2.length()
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



func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body != Cycle: return
	
	body.wall_approached(body.shape_find_owner(local_shape_index))
