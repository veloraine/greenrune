class_name ToolFeedback
extends Node3D

var _popup_tween: Tween

@onready var _dust: GPUParticles3D = $Dust
@onready var _dust_material: ParticleProcessMaterial = _dust.process_material
# One player per sound, because assigning a player's stream stops every voice it is playing.
@onready var _impact: AudioStreamPlayer3D = $Impact
@onready var _refill: AudioStreamPlayer3D = $Refill
@onready var _no_effect: AudioStreamPlayer3D = $NoEffect
@onready var _cue: AudioStreamPlayer = $Cue
@onready var _popup: Label3D = $RpPopup


func _ready() -> void:
	var feel: ToolFeelDef = Game.tool_feel
	_refill.stream = feel.refill_sound
	_refill.pitch_scale = feel.refill_pitch
	_no_effect.stream = feel.no_effect_sound
	_no_effect.pitch_scale = feel.no_effect_pitch
	_no_effect.volume_db = feel.no_effect_volume_db


## The "pop" on every tool hit: sound and hit-stop now, then a dust burst.
func play(at: Vector3, tool: ToolDef) -> void:
	global_position = at
	if tool.impact_sound:
		if _impact.stream != tool.impact_sound:
			_impact.stream = tool.impact_sound
		_impact.play()
	_dust_material.color = tool.dust_color
	if tool.hit_stop > 0.0:
		await HitStop.freeze(tool.hit_stop)
	# A particle restart during a zero-delta (frozen) frame loses the whole burst.
	_dust.restart()


## The can filling at water: the refill sound and a splash.
func refill(at: Vector3, tool: ToolDef) -> void:
	global_position = at
	_refill.play()
	_dust_material.color = tool.dust_color
	_dust.restart()


## A swing that changes nothing: a dull thud, and no dust.
func no_effect(at: Vector3) -> void:
	global_position = at
	_no_effect.play()


## The rising tone on reaching a charge level.
func charge_cue(level: int) -> void:
	var pitches: Array[float] = Game.tool_feel.charge_pitches
	_cue.stream = Game.tool_feel.charge_sound
	_cue.pitch_scale = pitches[mini(level, pitches.size()) - 1]
	_cue.play()


## "-N RP" rising and fading over the player.
func rp_popup(player: Vector3, spent: int) -> void:
	var feel: ToolFeelDef = Game.tool_feel
	_popup.text = "-%d RP" % spent
	_popup.modulate = feel.rp_popup_color
	_popup.outline_modulate.a = 1.0
	_popup.global_position = player + Vector3.UP * feel.rp_popup_height
	_popup.visible = true
	if _popup_tween:
		_popup_tween.kill()
	_popup_tween = _popup.create_tween()
	_popup_tween.tween_property(_popup, "global_position:y", _popup.global_position.y + feel.rp_popup_rise, feel.rp_popup_seconds)
	_popup_tween.parallel().tween_property(_popup, "modulate:a", 0.0, feel.rp_popup_seconds)
	_popup_tween.parallel().tween_property(_popup, "outline_modulate:a", 0.0, feel.rp_popup_seconds)
	_popup_tween.tween_callback(_popup.hide)
