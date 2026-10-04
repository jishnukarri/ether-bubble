shader_type spatial;

uniform vec3 slime_color : source_color = vec3(0.1, 1.0, 0.2);
uniform float shine = 3.0;

void fragment() {
	float rim = 1.0 - abs(dot(NORMAL, VIEW));
	rim = pow(rim, 3.0);

	ALBEDO = slime_color + vec3(rim) * shine;

	ROUGHNESS = 0.15;
	SPECULAR = 1.0;
}