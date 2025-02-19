extends CharacterBody3D
class_name NPC

var is_going_right: bool = true
var speed: int = 3

var mesh_wrapper: Node3D 
var anim_player:AnimationPlayer 

func _ready() -> void:
	mesh_wrapper = $SUPERSTITION_NPC
	anim_player = $SUPERSTITION_NPC/AnimationPlayer
	apply_floor_snap() 
	anim_player.play("Walking", -1, 1.5)
	if(is_going_right):
		mesh_wrapper.rotate(Vector3.UP, PI)

func _physics_process(delta):
	if is_going_right:
		#position.x += speed * delta
		velocity = Vector3.BACK * speed 
	else:
		velocity = Vector3.FORWARD * speed
		#position.x -= speed * delta
	move_and_slide()
