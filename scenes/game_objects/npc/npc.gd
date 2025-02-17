extends CharacterBody3D
class_name NPC

var is_going_right: bool = true
var speed: int = 3

func _ready() -> void:
	apply_floor_snap() 

func _physics_process(delta):
	if is_going_right:
		#position.x += speed * delta
		velocity = Vector3.BACK * speed 
	else:
		velocity = Vector3.FORWARD * speed
		#position.x -= speed * delta
	move_and_slide()
