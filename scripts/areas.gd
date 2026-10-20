class_name Areas
extends RefCounted

## The places the player can be, one scene each. A save stores the lowercase name.
enum Id { FARM, TOWN }

const SCENES: Dictionary[Id, String] = {
	Id.FARM: "res://scenes/farm.tscn",
	Id.TOWN: "res://scenes/town.tscn",
}
