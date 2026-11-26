#version 150
#define VSH
#define RENDERTYPE_TEXT
#define RENDERTYPE_TEXT_INTENSITY
#define IS_SEE_THROUGH
#define SHADER_VERSION 2
// WifiCraft text shader - to samo co see_through, ale dla fontow TTF / unifont

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
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
    lightColor = vec4(1.0); // see-through: bez lightmapy (jak w vanilli)

    if(applyChaliuEffects()) return;
    if(applyBlocklyEffects()) return;

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = Color;
    texCoord0 = UV0;
}
