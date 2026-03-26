extends CharacterBody2D
class_name Cycle

@export var color: Color
@export var trail_length: float = 3000

var speed: float = 600
var min_timeout: float = 0.02
var max_turn_buffer_length: int = 4
var max_rubber: float = 10

var timeout: float = 0
var buffered_turns: Array[bool] = []

var rubber: float = 0

var trail_scene: PackedScene = preload('res://cycle/Trail/trail.tscn');
var trail: Trail = trail_scene.instantiate()

var nearby_walls: Array[Wall] = []

func _ready() -> void:
	self_modulate = color
	trail.max_length = trail_length
	%Trails.add_child(trail)

func _physics_process(delta: float) -> void:
	
	process_turns(delta)
	
	velocity = Vector2(0, -1).rotated(rotation)*speed
	move_and_slide()
	
	trail.update(position, rotation)
	#print("adding ", position, " to points")

func process_turns(delta: float) -> void:
	
	if Input.is_action_just_pressed("r1") or Input.is_action_just_pressed("r2") or Input.is_action_just_pressed("r3") or Input.is_action_just_pressed("r4"):
		buffered_turns.push_back(true)
	if Input.is_action_just_pressed("l1") or Input.is_action_just_pressed("l2") or Input.is_action_just_pressed("l3") or Input.is_action_just_pressed("l4"):
		buffered_turns.push_back(false)
	
	if timeout < min_timeout:
		timeout += delta
		return
	
	if buffered_turns.size() == 0: return
	
	if buffered_turns[0]: rotate_cycle(90)
	else: rotate_cycle(-90)
	
	buffered_turns.remove_at(0)
func buffer_turn(turn: bool) -> void:
	if buffered_turns.size() >= max_turn_buffer_length: return
	buffered_turns.push_back(turn)
func rotate_cycle(ang: float) -> void:
		rotation_degrees += ang
		timeout = 0

func on_wall_approached(wall: Wall) -> void:
	nearby_walls.push_back(wall)

func on_wall_left(wall: Wall) -> void:
	var i := nearby_walls.find(wall)
	nearby_walls.remove_at(i)
