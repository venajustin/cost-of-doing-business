extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 2.0
const angular_speed := 5.0
var angular_delta := 0.0



func _physics_process(delta: float) -> void:
	
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	angular_delta = delta
	
	nav_agent.set_velocity(new_velocity)


func update_target_location(target_location):
	nav_agent.target_position = target_location


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	var direction = velocity.normalized()
	var target_angle = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, angular_speed * angular_delta)
	move_and_slide()
