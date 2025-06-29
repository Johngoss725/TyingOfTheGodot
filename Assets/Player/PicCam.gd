extends Camera3D

func _ready() -> void:
	
	await get_tree().create_timer(3).timeout
	get_viewport().get_texture().get_image().save_png(r'C:\Users\John\Documents\typingofthegodot\myimag.webp')
