shader_type canvas_item;

uniform bool enabled = false;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	if (enabled == true) {
		COLOR = vec4(255,255,255,color.a);
	} else {
		COLOR = color;
	}
}
