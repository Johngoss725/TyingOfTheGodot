shader_type spatial;
render_mode unshaded;

uniform vec3 wood_color : source_color = vec3(0.4, 0.25, 0.1);
uniform vec3 ring_color : source_color = vec3(0.3, 0.15, 0.05);
uniform float ring_scale = 12.0;
uniform float noise_strength = 0.2;
uniform float distortion_scale = 5.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);
	f = f * f * (3.0 - 2.0 * f);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	vec2 uv = UV;

	// Distort UVs
	float distortion = noise(uv * distortion_scale) * noise_strength;
	float rings = sin((uv.x + distortion) * ring_scale);

	// Simulate wood rings with banding
	float pattern = smoothstep(0.0, 0.05, fract(rings));

	ALBEDO = mix(ring_color, wood_color, pattern);
}
