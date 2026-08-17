shader_type canvas_item;

uniform float speed = 0.3;
uniform float strength = 0.01;

void fragment() {
    vec2 uv = UV;

    uv.x += sin(uv.y * 20.0 + TIME * speed * 10.0) * strength;

    COLOR = texture(TEXTURE, uv);
}