shader_type spatial;

// dynamics
uniform float amplitude = 0.2;
uniform float frequency = 1.0;

void vertex() {
	VERTEX.x = amplitude * sin(-TIME * frequency + VERTEX.z) * VERTEX.z;
}

void fragment() {
	ALBEDO = vec3(0.9, 0.2, 0.2);
}
