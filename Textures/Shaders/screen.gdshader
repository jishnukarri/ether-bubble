shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float pixel_size = 4.0;

void fragment() {
	vec2 uv = SCREEN_UV;

	vec2 pixels = 1.0 / SCREEN_PIXEL_SIZE;

	uv = floor(uv * pixels / pixel_size) * pixel_size / pixels;

	COLOR = texture(screen_texture, uv);
}