extends NPC
class_name BlackCat

func _ready() -> void:
	speed = 5
	mesh_wrapper = $Cat
	anim_player = $Cat/AnimationPlayer
	apply_floor_snap() 
	anim_player.play("Armature|ArmatureAction", -1, 1.5)
	if(is_going_right):
		mesh_wrapper.rotate(Vector3.UP, PI)

#func _physics_process(delta):
	#if is_going_right:
		#velocity = Vector3.BACK * speed 
	#else:
		#velocity = Vector3.FORWARD * speed
	#move_and_slide()
	#check_for_player_collision()
	#
#func check_for_player_collision():
	#for i in range(get_slide_collision_count()):
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
#
		#if collider and collider.is_in_group("player"):
			#GameEvents.on_game_over.emit()
			#print('HIT PLAYER')
