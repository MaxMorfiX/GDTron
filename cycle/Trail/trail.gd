extends Line2D
class_name Trail

@onready var walls_container := $Walls

var last_rotation: float = 0
var walls: Array[Wall] = []
var max_length: float = 1500

var length: float = 0

var last_wall: Wall
#var last_wall: Wall:
	#get:
		#if walls.size() < 1: return null
		#return walls[walls.size()-1]

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
	
	start_new_wall(pos, rot)

func extend_last_point_to(pos: Vector2) -> void:
	
	var p_size: int = points.size()
	
	var diff := pos - points[p_size-1]
	
	points[p_size-1] = pos
	
	walls[p_size-2].extend(diff)
	
	var diffl := diff.length()
	handle_length(diffl)

func start_new_wall(pos: Vector2, rot: float) -> void:
	
	add_point(pos)
	last_rotation = rot
	
	#collision logic
	
	if points.size() < 2: return
	
	var p1 := points[points.size() - 2]
	var p2 := pos
	var diff := p2-p1
	var diffl := diff.length()
	
	handle_length(diffl)
	
	create_wall(p1, p2, rot)

func create_wall(p1: Vector2, p2: Vector2, rot: float) -> void:
	var wall := Wall.new(p1, p2, rot)
	
	walls_container.add_child(wall)
	walls.push_back(wall)
	
	last_wall = wall

func handle_length(add_value: float = 0) -> void:
	
	length += add_value
	#print("l: ", length)
	if length < max_length: return
	
	var shorten_amount := length - max_length
	var vec2 := points[1] - points[0]
	var l := vec2.length()
	#print("p1: ", points[1], "p2: ", points[2])
	#print("l: ", l, ", shorten_amount: ", shorten_amount, "vec2: ", vec2)
	if l <= shorten_amount:
		remove_point(0)
		
		length -= l
		
		walls[0].queue_free()
		walls.remove_at(0)
		
		handle_length()
		return
	
	#print("moving toward; initial: ", points[0])
	points[0] = points[0].move_toward(points[1], shorten_amount)
	length -= shorten_amount
	
	walls[0].shorten(shorten_amount)
	
	#print("moving toward; after: ", points[0])
