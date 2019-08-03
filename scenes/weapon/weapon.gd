extends Area2D

var type="Lance"

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weaponLance_body_entered(body):
	if body.is_in_group("Player"):
		body.changeWeapon(self.type)
		self.queue_free()
