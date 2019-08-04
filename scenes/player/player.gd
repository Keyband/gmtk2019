extends KinematicBody2D

var life=3
onready var currentWeapon="Nothing"

var vectorVelocity=Vector2()
var aimDistance=18

var speedMultiplier=1
var weaponWeight=1
const minimumAimDistance=50
var speed=175
const maximumSpeed=175
var invincible=false
var anim="idle"
var hitboxIndicatorProperties={"center":Vector2(),"radius":50,"angleRange":45,"color":Color("#00bd4882")}
var defaultHitboxColor=Color("#55bd4882")
var lance=preload("res://scenes/attacks/lanceAttack.tscn")
var axe=preload("res://scenes/attacks/axeAttack.tscn")
var sword=preload("res://scenes/attacks/swordAttack.tscn")
var katana=preload("res://scenes/attacks/katanaAttack.tscn")
var dagger=preload("res://scenes/attacks/daggerAttack.tscn")
var morningStar=preload("res://scenes/attacks/morningStarAttack.tscn")

func _ready():
	global.player=self
	self.global_position=Vector2(160,160)
	self.add_to_group("Player")
	set_physics_process(true)
	
func _draw():
	var angleDeg=rad2deg((get_global_mouse_position()-self.global_position).angle())+90
#	draw_circle_arc_poly(hitboxIndicatorProperties["center"],
#						1.1*hitboxIndicatorProperties["radius"],
#						-1.1*hitboxIndicatorProperties["angleRange"]+angleDeg,
#						1.1*hitboxIndicatorProperties["angleRange"]+angleDeg,
#						Color("#55000000"))
	draw_circle_arc_poly(hitboxIndicatorProperties["center"],
						hitboxIndicatorProperties["radius"],
						-hitboxIndicatorProperties["angleRange"]+angleDeg,
						hitboxIndicatorProperties["angleRange"]+angleDeg,
						hitboxIndicatorProperties["color"])
	
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
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_mute"):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),!AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
	
	update()
	
	if invincible:$sprite.visible=!$sprite.visible
	else: $sprite.visible=true
	
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
	if self.currentWeapon=="Nothing" and weapon!="Nothing":# and weapon!="Nothing" or weapon!="Attacking":
			$sfxPickup.pitch_scale=rand_range(0.7,0.9)
			$sfxPickup.play()
	self.currentWeapon=weapon
	var twnDuration=0.45
	if self.currentWeapon=="Nothing":
		weaponWeight=1
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#00bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="Lance":
#		$sfxPickup.play()
		weaponWeight=3
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],60,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],15,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="Axe":
#		$sfxPickup.play()
		weaponWeight=5
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],50,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],60,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="Sword":
#		$sfxPickup.play()
		weaponWeight=2
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],50,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],45,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="Katana":
#		$sfxPickup.play()
		weaponWeight=3
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],75,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],45,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="Dagger":
#		$sfxPickup.play()
		weaponWeight=1
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],300,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],0.5,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	elif self.currentWeapon=="MorningStar":
#		$sfxPickup.play()
		weaponWeight=5
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:color",self.hitboxIndicatorProperties['color'],Color("#55bd4882"),twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:radius",self.hitboxIndicatorProperties['radius'],50,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.interpolate_property(self,"hitboxIndicatorProperties:angleRange",self.hitboxIndicatorProperties['angleRange'],180,twnDuration,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnDraw.start()
	
func takeDamage(amount):
	self.life-=amount
	$sfxHurt.pitch_scale=rand_range(1.8,2.2)
	$sfxHurt.play()
	if not invincible:
		if life<=0:
			print("Dead")
			$"hearts/3".frame=1
			$"hearts/2".frame=1
			$"hearts/1".frame=1
			set_physics_process(false)
			self.pause_mode=Node.PAUSE_MODE_PROCESS
			get_tree().paused=true
			$animationPlayer.play("dead")
		elif life<=1:
			$"hearts/3".frame=1
			$"hearts/2".frame=1
		elif life<=2:
			$"hearts/3".frame=1
		elif life<=3: #???
			pass
	$tmrInvulnerability.start()
	self.invincible=true

func _on_tmrInvulnerability_timeout():
	invincible=false
