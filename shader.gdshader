shader_type canvas_item;

uniform bool set_colour_manually = false;

uniform bool animate = false;

uniform float u_line_width: hint_range(0.0, 0.1) = 0.02;
uniform float u_line_stretch_x: hint_range(0.0, 10.0) = 3.0;
uniform float u_line_stretch_y: hint_range(0.0, 10.0) = 1.0;
uniform float u_line_translate_x: hint_range(-10.0, 10.0) = 0.0;
uniform float u_line_translate_y: hint_range(-10.0, 10.0) = 0.0;
uniform vec3 u_line_colour = vec3(1.0);





float swirl(vec2 uv, float size, int n_arms, bool is_animated) {
	float animation = is_animated ? TIME : 0.0;
	float angle = atan(-uv.y + 0.5, uv.x - 0.5);
	float len = length(uv - vec2(0.5, 0.5));

	return sin(len * size + angle * float(n_arms) + animation);
}

vec4 generate_white_sine_line(float x, float y, float width, float stretch_x, float stretch_y, float translate_x, float translate_y) {
	// smoothstep(edge_0, edge_1, input) clamps values outside its range, and interpolates values within its range.
	// For x < edge_0, x is 0 (black), and for x > edge_1, x is 1 (white), if edge_0 < x < edge_1
	// The reverse is true if edge_1 < x < edge_0, and hence a white line of width "2 * width" is formed due to the abs(), which is a reflection

	// Applying stretch to the sin(x) argument stretches or shrinks the wave.
	// Applying translate to sin(x) - y can translate in either the x or y axis.
	return vec4(vec3(smoothstep(width, 0.0, abs(sin(((stretch_x * 2.0 * PI * x) + translate_x)) * stretch_y - y + translate_y))), 1.0);
}



void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	COLOR = generate_white_sine_line(UV.x, UV.y, u_line_width, u_line_stretch_x, u_line_stretch_y, u_line_translate_x, u_line_translate_y);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
