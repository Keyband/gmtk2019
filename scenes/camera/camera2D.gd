extends Camera2D

var amount=0

func _ready():
	global.camera=self
	set_physics_process(false)

func _physics_process(delta):
	self.offset=Vector2(sign(randf()-0.5)*amount,sign(randf()-0.5)*amount)

func minorShake():
	set_physics_process(true)
	if $twnShake.is_active():
		var initialAmount=clamp(amount+1,0,15)
		var duration=clamp($twnShake.get_runtime()+0.1,0,2)
		$twnShake.interpolate_property(self,"amount",initialAmount,0,duration,Tween.TRANS_EXPO,Tween.EASE_OUT)
		$twnShake.start()
	else:
		var initialAmount=3.5
		var duration=0.4
		$twnShake.interpolate_property(self,"amount",initialAmount,0,duration,Tween.TRANS_EXPO,Tween.EASE_OUT)
		$twnShake.start()

func _on_twnShake_tween_completed(object, key):self.set_physics_process(false)
