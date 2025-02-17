extends CharacterBody3D
class_name Friend

const SPEED = 4
const JUMP_VELOCITY = 4.5
@onready var raycast_target: Marker3D = $Marker3D

func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity = Vector3.RIGHT * SPEED
	move_and_slide()
