shader_type canvas_item;

uniform float hegiht = 3.0;
uniform float frecuency = 10.0;
uniform float speed = 0.1;

void vertex() {
	VERTEX.y += hegiht * sin(UV.x * speed*TIME);
	
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
