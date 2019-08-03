extends Area2D

export (String,"Lance","Axe","Sword") var type="Lance"
var types=[
	"Lance",
	"Axe",
	"Sword",
	"Katana",
	"Dagger"
]

func _ready():
	randomize()
	self.type=types[randi()%types.size()]
	$label.text=self.type

func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		if body.currentWeapon=="Nothing":
			body.changeWeapon(self.type)
			self.queue_free()
