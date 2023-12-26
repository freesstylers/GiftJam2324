extends Node

enum NoteType { UP, DOWN, LEFT, RIGHT }
enum NoteHitStatus { NONE, MISS, OK, GREAT, PERFECT}
var GIFJAM_BPM : int = 130
var GIFJAM_BPM_IN_SECONDS = 60.0 / 130.0 

const NoteSprites = ["res://Assets/Sprites/Notas/Arriba.png",
					"res://Assets/Sprites/Notas/Abajo.png",
					"res://Assets/Sprites/Notas/Izquierda.png",
					"res://Assets/Sprites/Notas/Derecha.png"]

signal BPM_Notification()
signal Fight_Start()
signal Note_Hit_Result(result : NoteHitStatus) 
