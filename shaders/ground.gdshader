shader_type spatial;

render_mode unshaded;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D noise : source_color;

void fragment() {
	float noise_val = texture(noise, UV).r;
    ALBEDO = base_color.rgb;
    ALPHA = base_color.a * noise_val;
}