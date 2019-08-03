extends KinematicBody2D

var vectorVelocity=Vector2()
var aimDistance=100

const minimumAimDistance=100
const speed=300

func _ready():set_physics_process(true)
func _physics_process(delta):
	var vectorInput=Vector2()
	vectorInput.x=1 if Input.is_action_pressed('ui_right') else -1 if Input.is_action_pressed("ui_left") else 0
	vectorInput.y=1 if Input.is_action_pressed('ui_down') else -1 if Input.is_action_pressed("ui_up") else 0
	var movement=vectorInput.normalized()
	vectorVelocity=movement*speed #Lerp stuff should be added around here
	vectorVelocity=move_and_slide(vectorVelocity)
	
	aimDistance=lerp(aimDistance,minimumAimDistance,0.1)
	if Input.is_action_just_pressed('ui_attack'):aimDistance=1.5*minimumAimDistance
	$sprite2.position=aimDistance*(get_global_mouse_position()-self.global_position).normalized()