extends Node

var cursor_texture: Texture2D = preload("res://assets/sprites/ui/cursor.png");
var hover_texture: Texture2D = preload("res://assets/sprites/ui/cursor_hover.png");
var grab_texture: Texture2D = preload("res://assets/sprites/ui/cursor_grab.png");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_cursor(cursor_texture, Input.CURSOR_ARROW, 0);
	update_cursor(hover_texture, Input.CURSOR_POINTING_HAND, 3);
	update_cursor(grab_texture, Input.CURSOR_DRAG, 3);


func update_cursor(tex: Texture2D, shape, hotspot_ratio: float) -> void:
	var scale_factor: float = float(DisplayServer.window_get_size().y) / get_viewport().get_visible_rect().size.y;
	var image: Image = tex.get_image();


	image.resize(
		roundi(image.get_width() * scale_factor),
		roundi(image.get_height() * scale_factor),
		Image.INTERPOLATE_NEAREST
	);

	Input.set_custom_mouse_cursor(ImageTexture.create_from_image(image), shape, Vector2(image.get_width() / hotspot_ratio, image.get_height() / hotspot_ratio));
