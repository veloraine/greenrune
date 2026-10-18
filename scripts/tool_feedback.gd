class_name ToolFeedback
extends Node3D

@onready var _dust: GPUParticles3D = $Dust
@onready var _dust_material: ParticleProcessMaterial = _dust.process_material
@onready var _sound: AudioStreamPlayer3D = $Sound


## The "pop" on every tool hit: sound and hit-stop now, then a dust burst.
func play(at: Vector3, tool: ToolDef) -> void:
	global_position = at
	if tool.impact_sound:
		_sound.stream = tool.impact_sound
		_sound.play()
	_dust_material.color = tool.dust_color
	if tool.hit_stop > 0.0:
		await HitStop.freeze(tool.hit_stop)
	# A particle restart during a zero-delta (frozen) frame loses the whole burst.
	_dust.restart()
