extends Node3D

@onready var level = $"../"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta
	#if position.x < (GameEvents.sister.position.x -15):
	if position.x < -15:
		level.spawn_module(position.x+(level.amount*level.offset))
		#if GameEvents.head_module.global_position.x >= self.global_position.x + GameEvents.initial_offset:
			#print('new head powsition - ', GameEvents.head_position)
			#GameEvents.head_module = level.spawn_module()
			#print('new head powsition - ', GameEvents.head_position)
		queue_free()
