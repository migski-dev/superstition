extends Node3D

@onready var level : Level = $"../"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta
	if position.x < -15:
		if(level.module_queue.size() < level.amount):
			level.spawn_module(position.x+(level.amount*level.offset))
		queue_free()
