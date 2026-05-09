extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export_category("Mouse Settings")
@export_range(0.001, 0.01) var Mouse_Sens : float = 0.01

@onready var anim_tree:AnimationTree = $Camera3D/hand/AnimationTree
@onready var anim_play:AnimationPlayer = $Camera3D/hand/AnimationPlayer

var buy_action: bool = true
var price_action: bool = true
var ten_x: bool = false
var plus_5: bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	if Input.is_action_pressed("0"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_0")
		pass
	elif Input.is_action_pressed("1"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_1")
		pass
	elif Input.is_action_pressed("2"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_2")
		pass
	elif Input.is_action_pressed("3"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_3")
		pass
	elif Input.is_action_pressed("4"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_4")
		pass
	elif Input.is_action_pressed("5"):
		anim_tree.set("parameters/Fingers/transition_request", "fingers_5")
		pass
	else:
		pass
	
	if Input.is_action_pressed("tilt"):
		anim_tree.set("parameters/tilton/add_amount", lerpf(anim_tree.get("parameters/tilton/add_amount"), 1.0, .5))
		plus_5 = true
	else:
		anim_tree.set("parameters/tilton/add_amount", lerpf(anim_tree.get("parameters/tilton/add_amount"), 0.0, .5))
		plus_5 = false
	
	if Input.is_action_just_pressed("buy"):
		buy_action = not buy_action
	
	if buy_action:
		anim_tree.set("parameters/direction/transition_request", "backhand")
	else:
		anim_tree.set("parameters/direction/transition_request", "palm")
	
	
	if Input.is_action_just_pressed("forhead"):
		if not price_action and ten_x:
			price_action = true
			ten_x = false
			anim_tree.set("parameters/Arm/transition_request", "out")
		else:
			price_action = false
			ten_x = true
			anim_tree.set("parameters/Arm/transition_request", "forhead")

	if Input.is_action_just_pressed("chin"):
		if not price_action and not ten_x:
			price_action = true
			ten_x = false
			anim_tree.set("parameters/Arm/transition_request", "out")
		else:
			price_action = false
			ten_x = false
			anim_tree.set("parameters/Arm/transition_request", "chin")
	
	if price_action:
		if buy_action:
			anim_tree.set("parameters/tilt/transition_request", "bhand_high")
		else:
			anim_tree.set("parameters/tilt/transition_request", "palm_high")
	else:
		if buy_action:
			anim_tree.set("parameters/tilt/transition_request", "bhand_low")
		else:
			anim_tree.set("parameters/tilt/transition_request", "palm_low")
	
	
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Mouse_Sens)
		$Camera3D.rotate_x(-event.relative.y * Mouse_Sens)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
