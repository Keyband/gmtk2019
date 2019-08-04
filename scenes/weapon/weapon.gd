extends Area2D
const scoreValue=50
export (String,"Lance","Axe","Sword") var type="Lance"
var types=[
	"Lance",		#0
	"Axe",			#1
	"Sword",		#2
	"Katana",		#3
	"Dagger",		#4
	"MorningStar"	#5
]

#-Chakram: projétil, quica nas paredes, pode matar o próprio player (ou não, a decidir)
#-Besta: projétil, perfurante, range grande
#-Javelin: projétil, perfurante, range menor mas hitbox maior
#-Porrete: tipo um machado, mas tem knockback elevado
#-Steel ball: projétil com hitbox e splash damage

func _ready():
	self.add_to_group("Weapon")
	$collisionShape2D.disabled=true
	#TODO:Add some rotation when the weapon is landing
	randomize()
	var index=randi()%types.size()
	self.type=types[index]
	if index==0:$sprite.frame=1
	elif index==1:$sprite.frame=2
	elif index==2:$sprite.frame=0
	elif index==3:$sprite.frame=3
	elif index==4:$sprite.frame=4
	elif index==5:$sprite.frame=5
#	$sprite.rotation=rand_range(-PI/5,PI/5)
#	$spriteShadow.rotation=$sprite.rotation
	
	var xx=-200 if self.global_position.x<160 else 200#-400 if randi()%2==0 else 400
	var vectorInitialPosition=Vector2(xx,rand_range(20,320-20))
	$sprite.global_position.x=vectorInitialPosition.x
	$sprite.position.y=-100
	$spriteShadow.global_position.x=vectorInitialPosition.x
	$spriteShadow.frame=$sprite.frame
	var duration=1.5
	var targetRotation=rand_range(PI,5*PI)
	targetRotation*=1 if randi()%2==0 else -1
	$twnEnter.interpolate_property($sprite,"position:x",$sprite.position.x,0,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.interpolate_property($sprite,"position:y",$sprite.position.y,0,duration,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$twnEnter.interpolate_property($sprite,"rotation",$sprite.rotation,targetRotation,1.1*duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$twnEnter.interpolate_property($spriteShadow,"rotation",$spriteShadow.rotation,targetRotation,1.1*duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$twnEnter.interpolate_property($spriteShadow,"position:x",$spriteShadow.position.x,0,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.start()
#	$sprite

func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		if body.currentWeapon=="Nothing":
			global.score+=self.scoreValue
			body.changeWeapon(self.type)
			self.queue_free()


func _on_twnEnter_tween_completed(object, key):
	$collisionShape2D.disabled=false
	$animationPlayer.play("animSize")
	$spriteShadow.visible=false
