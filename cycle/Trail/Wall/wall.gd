extends Area2D
class_name Wall

var collision_shape: CollisionShape2D
var shape: RectangleShape2D

static var WALL_WIDTH: float = 5

var a: Vector2
var b: Vector2

var init_timeout: int = 2

func _physics_process(_delta: float) -> void:
	if init_timeout != 0: init_timeout -= 1
	
func _init(point_a: Vector2, point_b: Vector2, rot: float) -> void:
	
	a = point_a
	b = point_b
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	init_collider(rot)

func init_collider(rot: float) -> void:
	
	var diff := b-a
	var diffl := diff.length()
	
	collision_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	
	shape.size = Vector2(WALL_WIDTH, diffl)
	collision_shape.position = a + diff/2
	collision_shape.rotation = rot
	
	collision_shape.shape = shape
	
	add_child(collision_shape)

func shorten(shorten_amount: float) -> void:
	var new_length: float = shape.size.y - shorten_amount
	shape.size.y = max(new_length, 0) #to prevent setting length to below 0
	
	position -= (a-b).normalized()*shorten_amount/2

func extend(extend_vector: Vector2) -> void:
	shape.size.y += extend_vector.length()
	position += extend_vector/2


func _on_body_entered(body: Node2D) -> void:
	if body is not Cycle: return
	body.on_wall_approached(self)


func _on_body_exited(body: Node2D) -> void:
	if body is not Cycle: return
	
	body.on_wall_left(self)
