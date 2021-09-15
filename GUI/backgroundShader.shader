shader_type canvas_item;

const float aspect_ratio = 1024. / 600.;

void fragment() {
	vec2 uv_mod = UV;
    uv_mod.x = mix(0.5, uv_mod.x, aspect_ratio);
    uv_mod = mod(1.5 * uv_mod + 0.05 * TIME * vec2(1., -1.), 1.);
	if ((uv_mod.x > 0.5 && uv_mod.y > 0.5) || (uv_mod.x < 0.5 && uv_mod.y < 0.5)) {
		COLOR = vec4(48., 96., 130., 255.) / 255.;
	} else {
		COLOR = vec4(91., 110., 225., 255.) / 255.;
	}

}