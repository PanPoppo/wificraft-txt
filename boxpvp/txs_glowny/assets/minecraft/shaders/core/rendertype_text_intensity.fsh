#version 150
#define FSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define SHADER_VERSION 3
#define IS_1_21_6
// WifiCraft text shader - fonty TTF i unifont (atlas R8 - pokrycie w kanale .r)

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
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

    vec4 color = fx_glyph(texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
