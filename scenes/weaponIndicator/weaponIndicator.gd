extends Node2D
var player
const duration=0.3
var currentWeapon="Nothing"
func _ready():
	player=global.player
	set_physics_process(true)
func _physics_process(delta):
	if player.currentWeapon!=self.currentWeapon:
		if player.currentWeapon=="Nothing":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionOut.position.y,duration/2,Tween.TRANS_BACK,Tween.EASE_IN)
			self.currentWeapon="Nothing"
		elif player.currentWeapon=="Sword":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=0
			self.currentWeapon="Sword"
		elif player.currentWeapon=="Lance":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=1
			self.currentWeapon="Lance"
		elif player.currentWeapon=="Axe":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=2
			self.currentWeapon="Axe"
		elif player.currentWeapon=="Katana":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=3
			self.currentWeapon="Katana"
		elif player.currentWeapon=="Dagger":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=4
			self.currentWeapon="Dagger"
		elif player.currentWeapon=="MorningStar":
			$twnPosition.interpolate_property($sprite,"position:y",$sprite.position.y,$positionIn.position.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
			$sprite.frame=5
			self.currentWeapon="MorningStar"
		$twnPosition.start()