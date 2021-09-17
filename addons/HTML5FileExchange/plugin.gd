tool
extends EditorPlugin

# this doesnt seem to be working so I made a node for HTML5FileExchange.gd myself
func _enter_tree():
	add_autoload_singleton("HTML5File", "res://addons/HTML5FileExchange/HTML5FileExchange.gd")


func _exit_tree():
	remove_autoload_singleton("HTML5File")
