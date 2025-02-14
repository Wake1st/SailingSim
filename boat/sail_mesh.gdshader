shader_type spatial;

// static
uniform float height = 3.0;
uniform float offset = 2.25;

// dynamic
uniform float x_amplitude = 0.0;


void vertex() {
	VERTEX.x = x_amplitude * (offset - pow(VERTEX.y - height/2.0, 2));
}

void fragment() {
	ALBEDO = vec3(0.0, 0.7, 0.8);
}
