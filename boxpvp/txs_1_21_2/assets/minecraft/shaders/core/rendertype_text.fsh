#version 150
#define FSH
#define RENDERTYPE_TEXT
#define SHADER_VERSION 2
// WifiCraft text shader - zwykle fonty bitmapowe (vanilla / HD z texturepacka)

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;
uniform vec4 ColorModulator;
uniform float GameTime;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

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
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
