extends Node2D
class_name MovingPlatform

## Allow movement on the X plane
@export var x_movement: bool = false
## Allow movement on the Y plane
@export var y_movement: bool = false
## Movement speed to engage on X and/or Y plane
@export var move_speed: float
## Maximum length the platform will move
## Example: if var set to 100, platform will move starting position + 100 (X and/or Y)
@export var move_distance: int
## Check if the platform should try to fall away when touched
@export var collapse: bool = false
