shader_type canvas_item;

uniform float blur_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec4 shadow_color : source_color = vec4(0.2, 0.2, 0.2, 0.3);

void fragment() { 
    vec4 original = texture(TEXTURE, UV);
    vec4 shadow = vec4(0.0);

    for (int i = 0; i < 10; i++) {
        float step = float(i) * 0.02;
        shadow += texture(TEXTURE, UV + vec2(0.0, step)) * shadow_color;
    }

    shadow /= 5.0;
    COLOR = original + shadow;
}
