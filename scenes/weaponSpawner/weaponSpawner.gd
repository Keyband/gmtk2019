extends Node2D

#Weapons:
var weapon=preload("res://scenes/weapon/weapon.tscn")

func _ready():pass


func _on_timer_timeout():
	$timer.wait_time=rand_range(1.0,2.0)
	var i=weapon.instance()
	i.global_position.x=rand_range(0,OS.window_size.x)
	i.global_position.y=rand_range(0,OS.window_size.y)
	get_parent().add_child(i)