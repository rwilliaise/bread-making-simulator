shader_type spatial;
render_mode unshaded, cull_back, alpha_to_coverage_and_one;

void vertex() {
	VERTEX *= 1.01;
}

void fragment() {
	ALPHA = sin(UV.x * 10.f + UV.y * 10.f + TIME * 10.f);
	ALBEDO = vec3(1.f, 0.f, 0.f);
}
