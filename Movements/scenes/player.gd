extends KinematicBody2D


enum{
	BASIC
	LEDGE_HANGING
}


var state = BASIC
var dead = false
var on_ground = false 
var was_on_ground = false 
var motion = Vector2()
var gravity = 80
var high_fall = false
var acceleration = 100
var air_acceleration = 60
var max_speed = 120
var friction = 250
var jump_power = 5000

onready var ground_cast1 = $ground_cast1/ground_cast1
onready var ground_cast2 = $ground_cast2/ground_cast2
onready var ground_cast3 = $ground_cast3/ground_cast3


onready var jump_time = $timers/jump_time


func _physics_process(delta):
	if dead == false:
#GRAVITY CONTROL 
		if on_ground == true:
			gravity = 80
		else:
			if gravity < 150:
				gravity += 2 
#STATE CONTROL
		match state:
			BASIC:
				update_left_right_motion(delta)
				update_on_ground()
				update_jumping(delta)
				motion.y += gravity * delta
			LEDGE_HANGING:
				pass

		motion.y += gravity * delta
		motion.x = clamp(motion.x, -max_speed, max_speed )
		motion = move_and_slide(motion, Vector2(0,-1))
		
		
#KEYBOARD DETECTS KEY PRESSED
func update_left_right_motion(delta):
	if Input.is_action_just_pressed("ui_left"):
		motion.x -= acceleration * delta
	if Input.is_action_just_pressed("ui_right"):
		motion.x += acceleration * delta
	if Input.is_action_just_pressed("ui_left") == false and Input.is_action_just_pressed("ui_right") == false:
		if motion.x < 0:
			motion.x += friction * delta
		elif motion.x > 0:
			motion.x -= friction * delta
		if motion.x < 10 and motion.x > -10 :
			motion.x = 0
			
func update_on_ground():
	if ground_cast1.is_colliding() or ground_cast2.is_colliding() or ground_cast3.is_colliding():
# warning-ignore:standalone_expression
		on_ground = true
	else:
# warning-ignore:standalone_expression
		on_ground = false
			
			
func update_jumping(delta):
	if on_ground == true and Input.is_action_just_pressed("ui_up"):
		jump_time.start()
	
	if jump_time.is_stopped() == false:
		motion.y += jump_power * delta
			
		
			
			
	
	
	
	
	
