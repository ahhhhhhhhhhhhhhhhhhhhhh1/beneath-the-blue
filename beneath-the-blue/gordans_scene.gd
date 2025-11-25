extends CharacterBody3D
const jumpvelocity = 1.0
@export var gravity = 9.8
var speed = 5.0
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if Input.is_action_pressed("ui_accept"):
		self.velocity.y += jumpvelocity
	move_and_slide()
