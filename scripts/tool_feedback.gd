class_name ToolFeedback
extends Node3D

var _popup_tween: Tween

@onready var _dust: GPUParticles3D = $Dust
@onready var _dust_material: ParticleProcessMaterial = _dust.process_material
@onready var _sound: AudioStreamPlayer3D = $Sound
@onready var _cue: AudioStreamPlayer = $Cue
@onready var _popup: Label3D = $RpPopup


## The "pop" on every tool hit: sound and hit-stop now, then a dust burst.
func play(at: Vector3, tool: ToolDef) -> void:
	global_position = at
	if tool.impact_sound:
		_play(tool.impact_sound, 1.0, 0.0)
	_dust_material.color = tool.dust_color
	if tool.hit_stop > 0.0:
		await HitStop.freeze(tool.hit_stop)
	# A particle restart during a zero-delta (frozen) frame loses the whole burst.
	_dust.restart()


## The can filling at water: the refill sound and a splash.
func refill(at: Vector3, tool: ToolDef) -> void:
	global_position = at
	_play(Game.tool_feel.refill_sound, Game.tool_feel.refill_pitch, 0.0)
	_dust_material.color = tool.dust_color
	_dust.restart()


## A swing that changes nothing: a dull thud, and no dust.
func no_effect(at: Vector3) -> void:
	global_position = at
	_play(Game.tool_feel.no_effect_sound, Game.tool_feel.no_effect_pitch, Game.tool_feel.no_effect_volume_db)


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
	_popup.global_position = player + Vector3.UP * feel.rp_popup_height
	_popup.transparency = 0.0
	_popup.visible = true
	if _popup_tween:
		_popup_tween.kill()
	_popup_tween = _popup.create_tween()
	_popup_tween.tween_property(_popup, "global_position:y", _popup.global_position.y + feel.rp_popup_rise, feel.rp_popup_seconds)
	_popup_tween.parallel().tween_property(_popup, "transparency", 1.0, feel.rp_popup_seconds)
	_popup_tween.tween_callback(_popup.hide)


func _play(stream: AudioStream, pitch: float, volume_db: float) -> void:
	_sound.stream = stream
	_sound.pitch_scale = pitch
	_sound.volume_db = volume_db
	_sound.play()
