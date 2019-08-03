extends Node2D

const margin=64*1.25
var weapon=preload("res://scenes/weapon/weapon.tscn")

func _ready():randomize()
func _on_timer_timeout():
	$timer.wait_time=rand_range(1.0,2.0)
	var i=weapon.instance()
	i.global_position.x=rand_range(margin,OS.window_size.x-margin)
	i.global_position.y=rand_range(margin,OS.window_size.y-margin)
	get_parent().add_child(i)