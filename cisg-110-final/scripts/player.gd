extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -500.0

#float variable for max time kick is enabled
@export var _maxKickTime: float = 0.5
#float variable for kick timer
var _kickTimer: float = 0

@export var _kickRight: Node2D
@export var _kickLeft: Node2D

@export var _rightKickDir: Vector2 = Vector2.RIGHT
@export var _leftKickDir: Vector2 = Vector2.LEFT


var _facingRight: bool = true

func _enterTree() -> void:
	_disableKick()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction > 0:
		_facingRight = true
	elif direction < 0:
		_facingRight = false
		 
		#check if the timer is running (if the kick timer > 0)
		if _kickTimer > 0:
			# subtract delta from the timer
			_kickTimer -= delta
			#if timer has run out (timer < 0)
			if _kickTimer < 0:
				#call disable kick
				_disableKick()

	if Input.is_action_just_pressed("ui_accept"):
		_kick()

	move_and_slide()
	
func _kick() -> void:
	if _facingRight:
		print("kick right")
		_kickRight.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		print("kick left")
		_kickLeft.process_mode = Node.PROCESS_MODE_INHERIT
	#set kick timer to max
	_kickTimer = _maxKickTime

func _disableKick() -> void:
	_kickRight.process_mode = Node.PROCESS_MODE_DISABLED
	_kickLeft.process_mode = Node.PROCESS_MODE_DISABLED

func _on_kick_right_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("kick right")
	print(body.name)
	body.apply_central_impulse(_rightKickDir)


func _on_kick_left_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("kick left")
	print(body.name)
	body.apply_central_impulse(_leftKickDir)
