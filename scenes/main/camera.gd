extends Camera3D
@export var period = 0.3
@export var magnitude = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("on_crack_step", _shake_camera )
	GameEvents.connect("on_ladder_step", _shake_camera )
	GameEvents.connect("on_sister_lost", _shake_camera )
	GameEvents.connect("on_pole_split", _shake_camera )
	

func _shake_camera():
	if GameEvents.player.game_over:
		return
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform
	
