shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled;

uniform sampler2D noise_map : hint_default_white;
uniform float rainbow_scale : hint_range(0.1, 5.0) = 1.2;
uniform float animation_speed : hint_range(0.0, 2.0) = 0.05;

vec3 thickness_to_rainbow(float thickness) {
    float r = sin(thickness * 6.28318 + 0.0) * 0.5 + 0.5;
    float g = sin(thickness * 6.28318 + 2.0) * 0.5 + 0.5;
    float b = sin(thickness * 6.28318 + 4.0) * 0.5 + 0.5;
    return vec3(r, g, b);
}

void fragment() {
    ROUGHNESS = 0.015;
    METALLIC = 0.0;
    
    vec2 moving_uv = UV + vec2(TIME * animation_speed, TIME * (animation_speed * 0.5));
    float noise_val = texture(noise_map, moving_uv).r;
    
    float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
    
    float phase = (noise_val * rainbow_scale) + fresnel;
    vec3 rainbow = thickness_to_rainbow(phase);
    
    ALBEDO = rainbow;
    EMISSION = rainbow * 0.25;
    ALPHA = clamp(fresnel + 0.05, 0.0, 1.0);
}