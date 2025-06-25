shader_type spatial;


uniform sampler2D noise_tex;

uniform vec3 base_brick_color : source_color = vec3(0.6, 0.2, 0.1);
uniform vec3 mortar_color : source_color = vec3(0.8);

uniform float brick_width = 0.3;
uniform float brick_height = 0.15;
uniform float mortar_thickness = 0.015;
uniform float smoothness = 0.005;
uniform float noise_strength = 0.1;
uniform float noise_scale = 4.0;


void fragment() {
    vec2 uv = UV;

    // Offset every other row
    float row = floor(uv.y / brick_height);
    float offset = mod(row, 2.0) * (brick_width * 0.5);
    uv.x += offset;

    // Brick shape calculation
    vec2 brick = vec2(
        mod(uv.x, brick_width),
        mod(uv.y, brick_height)
    );

    // Mortar area
    float in_mortar = step(brick.x, mortar_thickness) +
                      step(brick_width - brick.x, mortar_thickness) +
                      step(brick.y, mortar_thickness) +
                      step(brick_height - brick.y, mortar_thickness);

    float mortar_mask = smoothstep(0.0, smoothness, in_mortar);

    // Sample noise texture
    float n = texture(noise_tex, UV * noise_scale).r;

    // Add noise to brick color
    vec3 noisy_brick = base_brick_color + n * noise_strength;

    // Blend mortar and brick
    vec3 color = mix(noisy_brick, mortar_color, mortar_mask);
    ALBEDO = color;
}
