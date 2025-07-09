shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float offset;

void fragment() {
	float actual_offset = offset / 500.0;
	
	vec4 color = vec4(1, 1, 1, 1);
	color.r = texture(screen_texture, vec2(SCREEN_UV.x + actual_offset, SCREEN_UV.y)).r;
	color.b = texture(screen_texture, vec2(SCREEN_UV.x, SCREEN_UV.y + actual_offset)).b;
	color.g = texture(screen_texture, vec2(SCREEN_UV.x - actual_offset, SCREEN_UV.y)).g;
	
	COLOR = color;
}

