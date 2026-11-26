#version 150
#define FSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define IS_SEE_THROUGH
#define SHADER_VERSION 3
#define IS_1_21_6
// WifiCraft text shader - to samo co see_through, ale dla fontow TTF / unifont

#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in vec4 baseColor;
in vec4 lightColor;
in vec4 vertexColor;
in vec2 texCoord0;
out vec4 fragColor;

#moj_import <chaliu_effects.glsl>
#moj_import <blockly_effects.glsl>

void main() {
    if(applyChaliuEffects()) return;
    if(applyBlocklyFragment()) return;

    vec4 color = fx_glyph(texCoord0) * vertexColor;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = color * ColorModulator;
}
