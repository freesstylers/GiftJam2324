shader_type canvas_item;

uniform float speedColor = 1;
uniform float colorH = 1;
uniform float hegiht = 3.0;
uniform float frecuency = 10.0;
uniform float speed = 0.1;

void vertex() {
	VERTEX.y += hegiht * sin(VERTEX.x*frecuency + speed*TIME);
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r = 1.0;
	COLOR.g += sin(sin(TIME * speedColor + UV.y * colorH)*0.8);
	COLOR.b = 0.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
