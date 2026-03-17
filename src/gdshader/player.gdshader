shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(1.0, 1.0, 1.0, 1);
uniform vec2 shadow_offset = vec2(5, 100); // pixels

void fragment() {
    vec4 original = texture(TEXTURE, UV);

    // offset shadow sample
    vec2 shadow_uv = UV + shadow_offset / TEXTURE_PIXEL_SIZE;
    vec4 shadow = texture(TEXTURE, shadow_uv) * shadow_color;

    COLOR = shadow + original;
}
