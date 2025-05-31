extends CharacterBody2D

const MAX_SPEED := 30000.0
var speed := MAX_SPEED

func _physics_process(delta):
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
	
	if horizontal_direction and vertical_direction :
		speed = MAX_SPEED * sin(deg_to_rad(45))
	else: 
		speed = MAX_SPEED
		
	velocity.x = horizontal_direction * speed * delta
	velocity.y = vertical_direction * speed * delta
	
	print(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)));

	move_and_slide()
