extends DirectionalLight3D

## The sun rises in the east at sunrise_hour and sets in the west at sunset_hour.
## These hours and the colours below are a design default: no RF4 source gives its lighting phases.
@export_range(0.0, 24.0) var sunrise_hour: float = 0.0
@export_range(0.0, 24.0) var sunset_hour: float = 0.0
## How far the sun's path leans south. At 0 the noon sun is straight overhead.
@export_range(0.0, 80.0) var tilt_degrees: float = 0.0
@export var environment: Environment
@export_group("Colours over the day (left edge 00:00, right edge 24:00)")
@export var light_over_day: Gradient
@export var ambient_over_day: Gradient
@export var sky_top_over_day: Gradient
@export var sky_horizon_over_day: Gradient

@onready var _sky: ProceduralSkyMaterial = environment.sky.sky_material


func _process(_delta: float) -> void:
	# An all-nighter runs the clock past 24:00, so wrap it to keep the dawn light in the east.
	var hour: float = fposmod(Game.minute / 60.0, 24.0)
	# Outside sunrise to sunset the light rests on a horizon; the night colours do the rest.
	var arc: float = clampf((hour - sunrise_hour) / (sunset_hour - sunrise_hour), 0.0, 1.0) * PI
	# The light shines along its -Z: point it west at sunrise, swing it over the top, lean the path south.
	basis = Basis(Vector3.RIGHT, deg_to_rad(tilt_degrees)) * Basis(Vector3.BACK, arc) * Basis(Vector3.UP, PI / 2.0)
	var t: float = hour / 24.0
	light_color = light_over_day.sample(t)
	environment.ambient_light_color = ambient_over_day.sample(t)
	_sky.sky_top_color = sky_top_over_day.sample(t)
	_sky.sky_horizon_color = sky_horizon_over_day.sample(t)
	_sky.ground_bottom_color = _sky.sky_top_color
	_sky.ground_horizon_color = _sky.sky_horizon_color
