shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	ALPHA *= albedo.a * albedo_tex.a;
}

uniform float waveHeightMultiplier = 0.9; // Adjust overall wave height

void vertex() {
    float t = TIME * 2.0;

    // Small, frequent waves (choppy surface)
    float small1 = sin(VERTEX.x * 12.0 + t * 2.0) * 0.02;
    float small2 = sin(VERTEX.z * 14.0 + t * 1.8) * 0.015;
    float small3 = sin((VERTEX.x + VERTEX.z) * 10.0 + t * 2.5) * 0.012;
    float small4 = sin((VERTEX.x - VERTEX.z) * 11.0 + t * 2.2) * 0.01;

    // Medium waves (visible undulations)
    float med1 = sin(VERTEX.x * 4.0 + VERTEX.z * 3.0 + t * 1.5) * 0.05;
    float med2 = sin((VERTEX.x - VERTEX.z) * 3.5 + t * 1.2) * 0.04;

    // Big swell waves (slow, large undulations)
    float swell1 = sin((VERTEX.x + VERTEX.z) * 1.0 + t * 0.5) * 0.15;
    float swell2 = sin((VERTEX.x - VERTEX.z) * 0.8 + t * 0.6) * 0.12;

    // Combine waves and apply height multiplier
    VERTEX.y += waveHeightMultiplier * (small1 + small2 + small3 + small4 + med1 + med2 + swell1 + swell2);
}




