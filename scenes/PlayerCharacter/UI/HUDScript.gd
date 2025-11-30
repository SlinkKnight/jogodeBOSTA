extends CanvasLayer

class_name HUD

#label references variables
@onready var currentStateLT = %CurrentStateLabelText
@onready var framesPerSecondLT = %FramesPerSecondLabelText
@onready var ammoLT: Label = %AMMOLabelText

func _process(_delta):
	displayCurrentFPS()

func displayCurrentFPS():
	framesPerSecondLT.set_text(str(Engine.get_frames_per_second()))
	
func displayAMMO(ammo):
	ammoLT.set_text(str(ammo));
