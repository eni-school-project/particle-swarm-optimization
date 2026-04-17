shader_type canvas_item;
render_mode blend_mix;

uniform vec4 background_color : source_color = vec4(0.5, 0.5, 0.5157, 1.0);
uniform vec4 line_color : source_color = vec4(0.65, 0.65, 0.65, 1.0);
uniform vec2 grid_offset = vec2(0.0, 0.0);
uniform float grid_spacing : hint_range(20.0, 200.0) = 40.0;
uniform float line_thickness : hint_range(0.1, 3.0) = 0.3;

void fragment() {
    vec2 pos = FRAGCOORD.xy + grid_offset;
    vec2 r = mod(pos, grid_spacing);

    vec2 away = smoothstep(vec2(0.0), vec2(line_thickness), r) *
                smoothstep(vec2(grid_spacing), vec2(grid_spacing - line_thickness), r);

    float line_alpha = 1.0 - min(away.x, away.y);

    COLOR = mix(background_color, line_color, line_alpha);
}