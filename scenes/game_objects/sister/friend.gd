extends CharacterBody3D
class_name Friend

const SPEED = 4
const JUMP_VELOCITY = 4.5
@onready var raycast_target: Marker3D = $Marker3D
@onready var anim_player = $SUPERSTITION_SISTER/AnimationPlayer
@onready var deadzone = $PlayerDeadzone

func _ready() -> void:
	anim_player.play("RUN",-1,1.0)

func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity = Vector3.RIGHT * GameEvents.game_speed#SPEED
	move_and_slide()


func _on_player_deadzone_body_entered(body):
	if body is Player:
		GameEvents.on_sister_lost.emit()
