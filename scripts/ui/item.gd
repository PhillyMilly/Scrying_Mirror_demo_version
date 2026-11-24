extends Sprite2D
class_name  Item

var is_hovering : bool = false;
var is_grabbing : bool = false;
var on_inventory: bool = false;
var current_slot: StringName;
var new_slot: StringName;
@onready var tex_path: String = texture.resource_path.get_basename();
@onready var anchor_position: Vector2 = position;
@onready var anchor_position_temp: Vector2 = position;
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if (is_hovering):
		texture = load(tex_path + "_hover.png");
		offset.y = -3;
	
	if (!is_grabbing && !Globals.holding_item && is_hovering && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		is_grabbing = true;
		Globals.holding_item = true;
	if (is_grabbing && Input.is_action_just_released("mouse_left")):
		if on_inventory && Inventory.slots[new_slot] == "empty":
			position = anchor_position;
			anchor_position_temp = anchor_position;
			if (current_slot):
				Inventory.remove_item(current_slot);
			Inventory.add_item(new_slot, name);
			current_slot = new_slot;
		else:
			position = anchor_position_temp;
		is_grabbing = false;
		Globals.holding_item = false;
		if (is_hovering):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND);
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW);
	
	if (is_grabbing):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG);
		position.x = get_global_mouse_position().x;
		position.y = get_global_mouse_position().y + 6;
		offset.y = 1;


func _on_sprite_2d_mouse_entered() -> void:
	is_hovering = true;
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND);


func _on_sprite_2d_mouse_exited() -> void:
	is_hovering = false;
	Input.set_default_cursor_shape(Input.CURSOR_ARROW);
	texture = load(tex_path + ".png");
	offset.y = 0;


func _on_inventory_area_entered(area: Area2D) -> void:
	on_inventory = true;


func _on_inventory_area_exited(area: Area2D) -> void:
	on_inventory = false;
