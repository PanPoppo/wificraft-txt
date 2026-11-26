#version 150
#define VSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define IS_SEE_THROUGH
#define SHADER_VERSION 3
#define IS_1_21_6
// WifiCraft text shader - to samo co see_through, ale dla fontow TTF / unifont

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform sampler2D Sampler0;

out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <chaliu_effects.glsl>
#moj_import <blockly_effects.glsl>

void main() {
    baseColor = Color;
    lightColor = vec4(1.0); // see-through: bez lightmapy (jak w vanilli)

    // 1) efekty WifiCraft  (text_effects_config.glsl)
    if(applyChaliuEffects()) return;
    // 2) efekty z Blockly  (blockly_effects_config.glsl)
    if(applyBlocklyEffects()) return;

    // 3) zwykly tekst
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = Color;
    texCoord0 = UV0;
}
