shader_type canvas_item;

uniform bool effect_on = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec3 final_rgb = effect_on ? vec4(1.0, 1.0, 1.0, 1.0).rgb : sprite_color.rgb;
	
	COLOR = vec4(final_rgb, sprite_color.a);
}

