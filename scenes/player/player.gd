extends KinematicBody2D

var currentWeapon="Nothing"

var vectorVelocity=Vector2()
var aimDistance=100

var speedMultiplier=1

const minimumAimDistance=100
const speed=300

var lance=preload("res://scenes/attacks/lanceAttack.tscn")
var axe=preload("res://scenes/attacks/axeAttack.tscn")
var sword=preload("res://scenes/attacks/swordAttack.tscn")
var katana=preload("res://scenes/attacks/katanaAttack.tscn")
func _ready():
	self.add_to_group("Player")
	set_physics_process(true)
func _physics_process(delta):
	var vectorInput=Vector2()
	vectorInput.x=1 if Input.is_action_pressed('ui_right') else -1 if Input.is_action_pressed("ui_left") else 0
	vectorInput.y=1 if Input.is_action_pressed('ui_down') else -1 if Input.is_action_pressed("ui_up") else 0
	var movement=vectorInput.normalized()

	aimDistance=lerp(aimDistance,minimumAimDistance,0.1)
	if Input.is_action_just_pressed('ui_attack'):
		aimDistance=1.5*minimumAimDistance
		if self.currentWeapon!="Nothing":
			if self.currentWeapon=="Lance":
				var i=lance.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Axe":
				var i=axe.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Sword":
				var i=sword.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Katana":
				var i=katana.instance()
				i.position=Vector2()
				add_child(i)
				speedMultiplier=2
			self.changeWeapon("Nothing")
	
	vectorVelocity=movement*speed*speedMultiplier #Lerp stuff should be added around here
	vectorVelocity=move_and_slide(vectorVelocity)
	speedMultiplier=lerp(speedMultiplier,1,0.1)
	$sprite2.position=aimDistance*(get_global_mouse_position()-self.global_position).normalized()
func changeWeapon(weapon):
	self.currentWeapon=weapon
	$label.text=weapon
	