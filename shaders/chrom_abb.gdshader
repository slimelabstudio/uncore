shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform bool active = false;
uniform float offset = 1.0;

void fragment(){
	if (active == true) { 
		vec4 green_channel = texture(screen_texture, SCREEN_UV);
		vec4 red_channel = texture(screen_texture, vec2(SCREEN_UV.x + (offset * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y + (offset * SCREEN_PIXEL_SIZE.y)));
		vec4 blue_channel = texture(screen_texture, vec2(SCREEN_UV.x - (offset * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y - (offset * SCREEN_PIXEL_SIZE.y)));
		
		COLOR = vec4(red_channel.r, green_channel.g, blue_channel.b, 1.0);
	} else {
		COLOR = textureLod(screen_texture, UV, 0.0);
	}
	
}