extends Node3D

@export var shop: ShopDef

@onready var _player: Player = $Player
@onready var _shopkeeper: Node3D = $Shopkeeper
@onready var _shop_reach: Area3D = $Shopkeeper/Reach
@onready var _shop_screen: ShopScreen = $HUD/ShopScreen


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _player.is_idle() and _shop_reach.overlaps_body(_player) and _faces(_shopkeeper):
		_shop_screen.open(shop)


## True when the player looks within 60 degrees of target.
func _faces(target: Node3D) -> bool:
	var to: Vector3 = target.global_position - _player.global_position
	var forward: Vector3 = -_player.global_basis.z
	return Vector2(forward.x, forward.z).normalized().dot(Vector2(to.x, to.z).normalized()) > 0.5
