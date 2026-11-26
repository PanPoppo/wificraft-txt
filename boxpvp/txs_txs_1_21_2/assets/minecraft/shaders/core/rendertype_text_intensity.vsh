#version 150
#define VSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define SHADER_VERSION 2
// WifiCraft text shader - fonty TTF i unifont (atlas R8 - pokrycie w kanale .r)

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform sampler2D Sampler2;
uniform sampler2D Sampler0;
uniform float GameTime;

out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <chaliu_effects.glsl>
#moj_import <blockly_effects.glsl>

void main() {
    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    if(applyChaliuEffects()) return;
    if(applyBlocklyEffects()) return;

    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);

    vertexColor = data.color * lightColor;
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);

    vec4 viewPos = ModelViewMat * vec4(data.position, 1.0);
    vertexDistance = FogShape == 0 ? length(viewPos.xyz) : max(length(viewPos.xz), abs(viewPos.y));

    texCoord0 = data.uv0;
}
