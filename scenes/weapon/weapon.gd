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
	self.type=types[5]#randi()%types.size()]
	$label.text=self.type

func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		if body.currentWeapon=="Nothing":
			body.changeWeapon(self.type)
			self.queue_free()
