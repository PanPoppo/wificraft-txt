#version 330

#define VSH
#define RENDERTYPE_TEXT
#define SHADER_VERSION 3
#define IS_1_21_6

#ifdef IS_GRAYSCALE
#define RENDERTYPE_TEXT_INTENSITY
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

uniform sampler2D Sampler0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <chaliu_effects.glsl>
#moj_import <blockly_effects.glsl>

void main() {
    baseColor = Color;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    lightColor = sample_lightmap(Sampler2, UV2);
#else
    lightColor = vec4(1.0);
#endif

    // 1) efekty WifiCraft (text_effects_config.glsl)
    if(applyChaliuEffects()) return;
    // 2) efekty z Blockly (blockly_effects_config.glsl)
    if(applyBlocklyEffects()) return;

#if defined(IS_GUI) || defined(IS_SEE_THROUGH)
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = Color;
    texCoord0 = UV0;
#else
    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);

    vertexColor = data.color * lightColor;
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);

    texCoord0 = data.uv0;
#endif
}
