extends Node2D

const margin=30
var weapon=preload("res://scenes/weapon/weapon.tscn")

func _ready():randomize()
func _on_timer_timeout():
	$timer.wait_time=rand_range(1.0,2.0)
	var i=weapon.instance()
	i.global_position.x=rand_range(margin,120) if randi()%2==0 else rand_range(120,320-margin)
	i.global_position.y=rand_range(2*margin,120) if randi()%2==0 else rand_range(120,320-2*margin)
	get_parent().add_child(i)