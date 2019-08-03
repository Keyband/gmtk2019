extends Area2D

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
	randomize()
	var index=randi()%types.size()
	self.type=types[index]
	if index==0:$sprite.frame=1
	elif index==1:$sprite.frame=2
	elif index==2:$sprite.frame=0
	elif index==3:$sprite.frame=3
	elif index==4:$sprite.frame=4
	elif index==5:$sprite.frame=5
	$sprite.rotation=rand_range(-PI/5,PI/5)
	$label.text=self.type

func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		if body.currentWeapon=="Nothing":
			body.changeWeapon(self.type)
			self.queue_free()
