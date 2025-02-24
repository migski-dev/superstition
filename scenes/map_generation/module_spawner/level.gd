extends Node3D
class_name Level

@export var modules: Array[PackedScene] = []
var module_queue : Array[PackedScene] = []
var amount: int = 12
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var offset: float = 6.0 # How far each module is

var init_obs = 0

@export var level_segments1: Array[LevelSegment] = []

func _ready() -> void:
	print(level_segments1)
	for n in amount:
		spawn_module(n*offset)

func spawn_module(n: float) -> void:
	if init_obs > 4:
		#INITIAL BEHAVIOR - RANDOM SPAWN 
		#rng.randomize()
		#var num = rng.randi_range(1,modules.size()-1)
		#var instance:Node3D = modules[num].instantiate()
		#instance.position.x = n
		#add_child(instance)
		
		#TEST BEHAVIOR - BATCHED MODULES
		rng.randomize()
		var num = rng.randi_range(0,level_segments1.size()-1)
		var position2 : int = 0
		
		print(num)
		if module_queue.size() + level_segments1[num].scenes.size() <= amount:
			for seg in level_segments1[num].scenes:
				position2 += 1
				print(level_segments1[num].name + " " + str(position2))
				module_queue.append(seg)
			
		var instance:Node3D = module_queue.pop_front().instantiate()
		instance.position.x = n
		#instance.global_transform.origin.x = GameEvents.head_module.global_transform.origin.x 
		add_child(instance)
		
	#sets 3 starting modules at beginning
	else:
		var instance = modules[0].instantiate()
		instance.position.x = n
		#instance.position.x = GameEvents.head_position
		add_child(instance)
		
		init_obs += 1
