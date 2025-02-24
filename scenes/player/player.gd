extends CharacterBody3D
class_name Player

@export var friend: CharacterBody3D
@export var knockback_strength: float = 6.0  # Adjust the knockback force
@export var knockback_duration: float = 0.3  # How long the knockback lasts
var knockback_velocity: Vector3 = Vector3.ZERO
var is_knocked_back: bool = false
var knockback_timer: float = 0.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var game_over: bool = false
@onready var pole_raycast: RayCast3D = $RayCast3D
@onready var anim_player = $SUPERSTITION_PLAYER_FIX/AnimationPlayer

func _ready() -> void:
	GameEvents.connect("on_crack_step",_on_crack_gameover);
	GameEvents.connect("on_ladder_step",_on_ladder_gameover);
	GameEvents.connect("on_sister_lost", _on_sister_lost)
	anim_player.play("Run", -1, 1.5)

func _physics_process(delta):
	position.x -= GameEvents.game_speed * delta # Match the speed of the moving modules
	
	if(game_over):
		$CurseVfx.position.x -= GameEvents.game_speed * delta
		return
	
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
	if game_over:
		return
	for i in range(get_slide_collision_count()-1):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider:
			if is_instance_of(collider, BlackCat):
				if game_over:
					return
				var cat = collider as BlackCat
				game_over = true
				cat.speed = 0
				GameEvents.game_over_reason = "YOU CROSSED PATHS WITH A BLACK CAT"
				GameEvents.on_black_cat.emit()
				await play_curse_vfx()
				GameEvents.on_game_over.emit()
				
			elif is_instance_of(collider, NPC):
				apply_knockback(collider)
				
		
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
			if game_over:
				return
			GameEvents.on_pole_split.emit()
			GameEvents.game_over_reason = "YOU SPLIT THE POLE"
			await play_curse_vfx()
			#GameEvents.on_game_over.emit()
	
func _on_crack_gameover():
	if game_over:
		return
	GameEvents.game_over_reason = "YOU STEPPED ON A CRACK"
	await play_curse_vfx()
	#GameEvents.on_game_over.emit()
	print('HIT CRACKS - GAME OVER')

func _on_ladder_gameover():
	if game_over:
		return
	GameEvents.game_over_reason = "YOU WENT UNDER A LADDER"
	await play_curse_vfx()
	#GameEvents.on_game_over.emit()
	print('PASSED UNDER A LADDER - LUCK LOSS')
	
func _on_sister_lost():
	if game_over:
		return
	GameEvents.game_over_reason = "YOU LOST YOUR SISTER"
	await play_curse_vfx()
	#GameEvents.on_game_over.emit()

func play_curse_vfx():
	velocity = Vector3.ZERO
	game_over = true
	$CurseVfx.emitting = true
	$DeathSFX.play()
	anim_player.play("Death")
	GameEvents.stop_game()
	await $CurseVfx.finished
	
