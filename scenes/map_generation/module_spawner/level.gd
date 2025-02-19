extends Node3D

@export var modules: Array[PackedScene] = []
var amount: int = 50
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var offset: int = 6 # How far each module is

var init_obs = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for n in amount:
		spawn_module(n*offset)

func spawn_module(n: int) -> void:
	if init_obs > 3:
		rng.randomize()
		var num = rng.randi_range(1,modules.size()-1)
		var instance:Node3D = modules[num].instantiate()
		instance.position.x = n
		add_child(instance)
	else:
		var instance = modules[0].instantiate()
		instance.position.x = n
		add_child(instance)
		init_obs += 1
