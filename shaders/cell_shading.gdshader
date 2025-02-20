shader_type spatial;

uniform vec4 albedo_color : source_color;
uniform vec3 light_direction = vec3(0.5, -1.0, 0.5);
uniform int steps = 4; // Number of shading levels

void fragment() {
    vec3 norm = normalize(NORMAL);
    vec3 lightDir = normalize(light_direction);
    float intensity = clamp(dot(norm, lightDir), 0.0, 1.0);
    intensity = floor(intensity * float(steps)) / float(steps);
    ALBEDO = albedo_color.rgb * intensity;
}