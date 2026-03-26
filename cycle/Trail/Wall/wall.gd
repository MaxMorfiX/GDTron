extends CollisionShape2D
class_name Wall

static var WALL_WIDTH: float = 0.1

var a: Vector2
var b: Vector2

func _init(point_a: Vector2, point_b: Vector2, rot: float) -> void:
	
	a = point_a
	b = point_b
	
	var diff := b-a
	var diffl := diff.length()
	
	shape = RectangleShape2D.new()
	shape.size = Vector2(diffl, WALL_WIDTH)
	position = a + diff/2
	rotation = rot

func shorten(shorten_amount: float) -> void:
	var new_length: float = shape.size.y - shorten_amount
	shape.size.y = max(new_length, 0) #to prevent setting length to below 0
	
	position -= (a-b).normalized()*shorten_amount

func extend(extend_vector: Vector2) -> void:
	shape.size.y += extend_vector.length()
	position += extend_vector/2
