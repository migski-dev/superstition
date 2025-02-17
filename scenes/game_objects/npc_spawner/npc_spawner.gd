extends Node3D

@export var npc_type_array: Array[PackedScene] = []
@export var npc_scene: PackedScene 
@export var right_side: bool = true
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var min_time: int = 1
var max_time: int = 2
var spawn_interval = 1.0



func _ready():
	get_tree().create_timer(rng.randi_range(min_time,max_time)).timeout.connect(_spawn_npc)
	

func _spawn_npc():
	var npc = npc_type_array[rng.randi_range(0,npc_type_array.size()-1)].instantiate()
	npc.position = Vector3.ZERO
	npc.speed = rng.randi_range(2,5)
	npc.is_going_right = right_side
	add_child(npc)
	get_tree().create_timer(rng.randi_range(min_time,max_time)).timeout.connect(_spawn_npc)

	
