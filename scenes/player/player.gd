extends KinematicBody2D

var life=3
var currentWeapon="Nothing"

var vectorVelocity=Vector2()
var aimDistance=18

var speedMultiplier=1
var weaponWeight=1
const minimumAimDistance=50
var speed=175
const maximumSpeed=175

var anim="idle"

var lance=preload("res://scenes/attacks/lanceAttack.tscn")
var axe=preload("res://scenes/attacks/axeAttack.tscn")
var sword=preload("res://scenes/attacks/swordAttack.tscn")
var katana=preload("res://scenes/attacks/katanaAttack.tscn")
var dagger=preload("res://scenes/attacks/daggerAttack.tscn")
var morningStar=preload("res://scenes/attacks/morningStarAttack.tscn")

func _ready():
	global.player=self
	self.add_to_group("Player")
	set_physics_process(true)
	
func _draw():
	var angleDeg=rad2deg((get_global_mouse_position()-self.global_position).angle())+90
	draw_circle_arc_poly(Vector2(),50,-45+angleDeg,45+angleDeg,Color("#80ffadad"))
	
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	#Yeah, this is a shameless copypaste from here: http://docs.godotengine.org/en/latest/tutorials/2d/custom_drawing_in_2d.html
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)
	
func _physics_process(delta):
	update()
	if life<=0:print("u ded")
	
	if $animationPlayer.name!=anim:$animationPlayer.play(anim)
	
	var vectorInput=Vector2()
	vectorInput.x=1 if Input.is_action_pressed('ui_right') else -1 if Input.is_action_pressed("ui_left") else 0
	vectorInput.y=1 if Input.is_action_pressed('ui_down') else -1 if Input.is_action_pressed("ui_up") else 0
	var movement=vectorInput.normalized()

	aimDistance=lerp(aimDistance,minimumAimDistance,0.1)
	if Input.is_action_just_pressed('ui_attack'):
		aimDistance=1.5*minimumAimDistance
		if self.currentWeapon!="Nothing":
			if self.currentWeapon=="Lance":
				self.changeWeapon("Attacking")
				var i=lance.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Axe":
				self.changeWeapon("Attacking")
				var i=axe.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Sword":
				self.changeWeapon("Attacking")
				var i=sword.instance()
				i.position=Vector2()
				add_child(i)
			elif self.currentWeapon=="Katana":
				self.changeWeapon("Attacking")
				var i=katana.instance()
				i.position=Vector2()
				add_child(i)
				movement=(get_global_mouse_position()-self.global_position).normalized()
				speedMultiplier=5
			elif self.currentWeapon=="Dagger":
				self.changeWeapon("Nothing")
				var i=dagger.instance()
				i.global_position=self.global_position
				i.vectorDirection=(get_global_mouse_position()-self.global_position).normalized()
				get_parent().add_child(i)
			elif self.currentWeapon=="MorningStar":
				self.changeWeapon("Attacking")
				var i=morningStar.instance()
				i.position=Vector2()
				add_child(i)
#			self.changeWeapon("Nothing")
	
	if Input.is_action_just_pressed("ui_rmb"):
		global.minorShake()
	
	$sprite.flip_h=true if vectorInput.x<0 else false if vectorInput.x>0 else $sprite.flip_h
	anim="idle" if vectorInput==Vector2() else "walk" if currentWeapon=="Nothing" else "walkWithWeapon"
	
	if vectorInput!=Vector2():speed=lerp(speed,maximumSpeed,0.1)
	else:speed=lerp(speed,0,0.1)
	
	var A=0.66
	var weaponWeightMultiplier=(1/4.0)*(5 - A - weaponWeight*(1 - A))
	vectorVelocity=movement*speed*speedMultiplier*weaponWeightMultiplier if vectorInput!=Vector2() else Vector2(lerp(vectorVelocity.x,0,0.2),lerp(vectorVelocity.y,0,0.2)) #Lerp stuff should be added around here
	vectorVelocity=move_and_slide(vectorVelocity)
	speedMultiplier=lerp(speedMultiplier,1,0.1)
	$sprite2.position=aimDistance*(get_global_mouse_position()-self.global_position).normalized()

func changeWeapon(weapon):
	self.currentWeapon=weapon
	
	if self.currentWeapon=="Nothing":weaponWeight=1
	elif self.currentWeapon=="Lance":weaponWeight=3
	elif self.currentWeapon=="Axe":weaponWeight=5
	elif self.currentWeapon=="Sword":weaponWeight=2
	elif self.currentWeapon=="Katana":weaponWeight=3
	elif self.currentWeapon=="Dagger":weaponWeight=1
	elif self.currentWeapon=="MorningStar":weaponWeight=5
	
func takeDamage(amount):
	self.life-=amount
	if life<=0:
		print("Dead")
	elif life<=1:
		$"hearts/3".frame=1
		$"hearts/2".frame=1
	elif life<=2:
		$"hearts/3".frame=1
	elif life<=3: #???
		pass