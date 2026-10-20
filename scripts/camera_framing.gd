class_name CameraFraming
extends Resource

## Degrees the camera looks down from the horizon.
@export_range(0.0, 90.0) var pitch_degrees: float = 0.0
## Metres from the player to the camera along the spring arm.
@export_range(1.0, 50.0) var arm_length: float = 1.0
## Vertical field of view in degrees. Narrower flattens the perspective.
@export_range(1.0, 179.0) var fov: float = 75.0
