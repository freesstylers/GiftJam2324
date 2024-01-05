extends Node

const ATTACK_COLOR = Color.AQUA
const DEFEND_COLOR = Color.CRIMSON

enum NoteType { NONE, UP, DOWN, LEFT, RIGHT }
enum NoteHitStatus { NONE, MISS, OK, GREAT, PERFECT}

const NoteSprites = ["res://Assets/Sprites/Notas/Arriba.png",
					"res://Assets/Sprites/Notas/Abajo.png",
					"res://Assets/Sprites/Notas/Izquierda.png",
					"res://Assets/Sprites/Notas/Derecha.png"]

enum Battle { NONE, G, P, C }

signal BPM_Notification()
signal To_G_Battle()
signal To_P_Battle()
signal To_P_Presentation()
signal To_C_Battle()
signal FromBattleToMainMenu()
signal Fight_Start()
signal Note_Hit_Result(result : NoteHitStatus, dir : NoteType) 

enum characterHit {Ragnahilda, Enemy}
signal LifeChanged(who : characterHit, quantity : int)

