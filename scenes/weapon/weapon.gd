extends Area2D

export (String,"Lance","Axe","Sword") var type="Lance"
var types=[
	"Lance",
	"Axe",
	"Sword",
	"Katana",
	"Dagger",
	"MorningStar"
]

#-Chakram: projétil, quica nas paredes, pode matar o próprio player (ou não, a decidir)
#-Morning star: dá uma volta ao redor do player
#-Besta: projétil, perfurante, range grande
#-Javelin: projétil, perfurante, range menor mas hitbox maior
#-Porrete: tipo um machado, mas tem knockback elevado
#-Steel ball: projétil com hitbox e splash damage

func _ready():
	randomize()
	self.type=types[randi()%types.size()]
	$label.text=self.type

func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		if body.currentWeapon=="Nothing":
			body.changeWeapon(self.type)
			self.queue_free()
