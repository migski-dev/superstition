extends Node3D

@export var modules: Array[PackedScene] = []
var amount: int = 12
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var offset: float = 6.0 # How far each module is

var init_obs = 0

func _ready() -> void:
	GameEvents.head_position = 0
	GameEvents.initial_offset = amount*offset
	for n in amount:
		spawn_module(n*offset)
		#spawn_module()

func spawn_module(n: float) -> void:
	if init_obs > 3:
		rng.randomize()
		var num = rng.randi_range(1,modules.size()-1)
		var instance:Node3D = modules[num].instantiate()
		instance.position.x = n
		#instance.global_transform.origin.x = GameEvents.head_module.global_transform.origin.x 
		add_child(instance)
		#GameEvents.head_module = instance

		
	else:
		var instance = modules[0].instantiate()
		instance.position.x = n
		#instance.position.x = GameEvents.head_position
		add_child(instance)
		#GameEvents.head_module = instance
		init_obs += 1
	
	GameEvents.head_position += GameEvents.module_offset
	
	
