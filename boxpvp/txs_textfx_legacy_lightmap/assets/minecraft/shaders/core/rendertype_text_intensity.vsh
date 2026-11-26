#version 150
#define VSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define SHADER_VERSION 3
#define IS_1_21_6
// WifiCraft text shader - fonty TTF i unifont (atlas R8 - pokrycie w kanale .r)

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <chaliu_effects.glsl>
#moj_import <blockly_effects.glsl>

void main() {
    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    // 1) efekty WifiCraft  (text_effects_config.glsl)
    if(applyChaliuEffects()) return;
    // 2) efekty z Blockly  (blockly_effects_config.glsl)
    if(applyBlocklyEffects()) return;

    // 3) zwykly tekst (+ customowe GUI z interfaces.glsl)
    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);

    vertexColor = data.color * lightColor;
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);

    texCoord0 = data.uv0;
}
