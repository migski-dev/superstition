extends CharacterBody3D

@export var friend: CharacterBody3D
@export var knockback_strength: float = 6.0  # Adjust the knockback force
@export var knockback_duration: float = 0.3  # How long the knockback lasts
var knockback_velocity: Vector3 = Vector3.ZERO
var is_knocked_back: bool = false
var knockback_timer: float = 0.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var pole_raycast: RayCast3D = $RayCast3D

func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta # Match the speed of the moving modules
	
	if is_knocked_back:
		velocity = knockback_velocity
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			is_knocked_back = false
			knockback_velocity = Vector3.ZERO
	else:
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		var input_dir = Input.get_vector( "ui_down", "ui_up", "ui_left", "ui_right")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		check_collisions()

	move_and_slide()
	detect_pole_split()
	
	
func check_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider:
			if is_instance_of(collider, BlackCat):
				GameEvents.game_over_reason = "YOU CROSSED PATH WITH A BLACK CAT"
				GameEvents.on_game_over.emit()
				print('HIT BLACK CAT - GAME OVER')
			elif is_instance_of(collider, NPC):
				apply_knockback(collider)
				print('HIT NPC - KNOCKBACK')
		
func apply_knockback(npc: NPC) -> void:
	var direction: Vector3 = (global_transform.origin - npc.global_transform.origin).normalized()
	knockback_velocity = direction * knockback_strength
	is_knocked_back = true
	knockback_timer = knockback_duration
	
func detect_pole_split() -> void:
	pole_raycast.target_position = friend.raycast_target.global_transform.origin - pole_raycast.global_transform.origin
	pole_raycast.force_raycast_update()
	
	if pole_raycast.is_colliding():
		var collider = pole_raycast.get_collider()
		if collider and not is_instance_of(collider, Friend):
			GameEvents.game_over_reason = "YOU SPLIT THE POLE"
			GameEvents.on_game_over.emit()
	
	


func _on_visible_on_screen_notifier_3d_screen_exited():
	GameEvents.game_over_reason = "YOU LOST YOUR FRIEND!"
	GameEvents.on_game_over.emit()
	
