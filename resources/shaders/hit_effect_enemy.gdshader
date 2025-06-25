shader_type canvas_item;

uniform bool effect_on = false;
uniform bool is_golden = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec4 modified_sprite_color = is_golden ? vec4(sprite_color.r * 0.843, sprite_color.g * 0.745, sprite_color.b * 0.0, sprite_color.a) : sprite_color;
	vec3 final_rgb = effect_on ? vec4(1.0, 1.0, 1.0, 1.0).rgb : modified_sprite_color.rgb;

	COLOR = vec4(final_rgb, modified_sprite_color.a);
}
