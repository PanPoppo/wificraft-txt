// =====================================================================
//  BLOCKLY TEXT EFFECTS - przeniesione z paczki Blockly do WifiCraft
// =====================================================================
//  Kolor -> efekt ustawiasz w:  blockly_effects_config.glsl
//  (dokladnie ta sama skladnia co _config.glsl w Blockly).
//
//  Dziala RAZEM z efektami WifiCraft (text_effects_config.glsl):
//    1. najpierw sprawdzane sa kolory WifiCraft (Chaliu),
//    2. jesli zaden nie pasuje - kolory Blockly,
//    3. jesli nic nie pasuje - zwykly tekst.
//
//  Efekty "wierzcholkowe" (shake, wavy, rainbow, gradient, dynamic_gradient,
//  aurora, bouncy, jump, iterating, pulse, scale/offset, glitch, spin, fade,
//  blinking, color) przesuwaja rogi litery i ustawiaja kolor wierzcholka -
//  dlatego dzialaja z KAZDYM fontem (vanilla, HD, TTF z texturepacka).
//
//  Efekty "fragmentowe" (outline, hatch, neon, split, chromatic, extrude,
//  noise, liquid, water) czytaja teksture litery. Tu odczyt idzie przez
//  fx_glyph(), wiec dzialaja tez na fontach TTF (atlas R8), czego oryginalny
//  Blockly nie obslugiwal (na TTF caly prostokat litery byl wypelniony).
//
//  Dane do fragment shadera jada w tych samych "slotach" co efekty Chaliu
//  (vctfx_*), bo te sa wtedy nieuzywane - dzieki temu shader nie przekracza
//  limitu varyingow na slabszych kartach. vctfx_applyTextEffect == 2.0
//  oznacza, ze ten fragment nalezy do Blockly.
// =====================================================================

#ifndef PI
#define PI 3.14159265359
#endif

#ifndef TAU
#define TAU 6.28318530718
#endif

float bk_random(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
}

float bk_noise(float n) {
    float i = floor(n);
    float f = fract(n);
    return mix(bk_random(vec2(i, 0.0)), bk_random(vec2(i + 1.0, 0.0)), smoothstep(0.0, 1.0, f));
}

vec3 bk_hue(float t) {
    t = fract(t);
    float r = abs(t * 6.0 - 3.0) - 1.0;
    float g = 2.0 - abs(t * 6.0 - 2.0);
    float b = 2.0 - abs(t * 6.0 - 4.0);
    return clamp(vec3(r, g, b), 0.0, 1.0);
}

// =====================================================================
//  VERTEX SHADER
// =====================================================================
#ifdef VSH

// ------------------------------------------------------------ domyslne wartosci
#define BK_SHAKE_SPEED 1.0
#define BK_SHAKE_INTENSITY 1.0
#define BK_PULSE_SPEED 20.0
#define BK_PULSE_SIZE 0.4
#define BK_WAVE_SPEED 12000.0
#define BK_WAVE_AMPLITUDE 0.5
#define BK_WAVE_X_FREQUENCY 0.35
#define BK_RAINBOW_SPEED 500.0
#define BK_BOUNCE_SPEED 3000.0
#define BK_BOUNCE_AMPLITUDE 1.0
#define BK_BLINK_SPEED 0.5
#define BK_SPIN_SPEED 2500.0
#define BK_FADE_SPEED 1.0
#define BK_ITERATING_SPEED 1.0
#define BK_ITERATING_SPACE 1.0
#define BK_GLITCH_SPEED 1.0
#define BK_GLITCH_INTENSITY 2.0
#define BK_SCALE_FACTOR 1.5
#define BK_SCALE_OFFSET_X 0.0
#define BK_SCALE_OFFSET_Y 0.0
#define BK_GRADIENT_START vec3(1.0, 0.0, 0.0)
#define BK_GRADIENT_END vec3(0.0, 0.0, 1.0)
#define BK_GRADIENT_DIRECTION 0.0
#define BK_DYN_GRADIENT_START vec3(1.0, 0.0, 0.0)
#define BK_DYN_GRADIENT_END vec3(0.0, 0.0, 1.0)
#define BK_DYN_GRADIENT_DIRECTION 0.0
#define BK_DYN_GRADIENT_SPEED 500.0
#define BK_AURORA_SPEED 500.0
#define BK_AURORA_COLOR_1 vec3(1.0, 0.3, 0.7)
#define BK_AURORA_COLOR_2 vec3(0.3, 1.0, 0.6)
#define BK_AURORA_COLOR_3 vec3(0.4, 0.6, 1.0)
#define BK_SPLIT_INTENSITY 1.5
#define BK_SPLIT_SPEED 1.0
#define BK_OUTLINE_COLOR vec4(0.0, 0.0, 0.0, 1.0)
#define BK_OUTLINE_THICKNESS 1.0
#define BK_HATCH_COLOR vec4(1.0, 1.0, 1.0, 1.0)
#define BK_HATCH_SPEED 1000.0
#define BK_HATCH_DENSITY 1.5
#define BK_NEON_COLOR vec4(0.5, 0.9, 1.0, 1.0)
#define BK_NEON_INTENSITY 1.5
#define BK_NEON_SPEED 1.0
#define BK_CHROMATIC_INTENSITY 1.5
#define BK_CHROMATIC_SPEED 1.0
#define BK_EXTRUDE_DEPTH 1.0
#define BK_EXTRUDE_LAYERS 3.0
#define BK_EXTRUDE_COLOR vec4(0.0, 0.0, 0.0, 1.0)
#define BK_NOISE_INTENSITY 1.0
#define BK_NOISE_SPEED 1.0
#define BK_LIQUID_INTENSITY 1.0
#define BK_LIQUID_SPEED 1.0
#define BK_WATER_COLOR vec4(0.2, 0.6, 0.95, 1.0)
#define BK_WATER_LEVEL 0.55
#define BK_WATER_AMPLITUDE 1.0
#define BK_WATER_SPEED 1.0
#define BK_WATER_FREQUENCY 1.5

// ------------------------------------------------------------ stan
vec4 bk_currentBaseColor = vec4(1.0);
bool bk_currentIsShadow = false;
vec2 bk_currentOffset = vec2(0.0);
float bk_spinFlip = 0.0;
float bk_spinScale = 1.0;

bool bk_flagShake = false;
bool bk_flagWavy = false;
bool bk_flagRainbow = false;
bool bk_flagBouncy = false;
bool bk_flagBlinking = false;
bool bk_flagPulse = false;
bool bk_flagSpin = false;
bool bk_flagSequentialSpin = false;
bool bk_flagFade = false;
bool bk_flagIterating = false;
bool bk_flagGlitch = false;
bool bk_flagScale = false;
bool bk_flagGradient = false;
bool bk_flagDynamicGradient = false;
bool bk_flagAurora = false;
bool bk_flagAurora4 = false;
bool bk_flagSplit = false;
bool bk_flagOutline = false;
bool bk_flagHatch = false;
bool bk_flagNeon = false;
bool bk_flagColorOverride = false;
bool bk_flagChromatic = false;
bool bk_flagExtrude = false;
bool bk_flagNoise = false;
bool bk_flagLiquid = false;
bool bk_flagWater = false;
bool bk_flagJump = false;

float bk_paramShakeSpeed = BK_SHAKE_SPEED;
float bk_paramShakeIntensity = BK_SHAKE_INTENSITY;
float bk_paramWaveSpeed = BK_WAVE_SPEED;
float bk_paramWaveAmplitude = BK_WAVE_AMPLITUDE;
float bk_paramWaveXFrequency = BK_WAVE_X_FREQUENCY;
float bk_paramRainbowSpeed = BK_RAINBOW_SPEED;
float bk_paramBounceSpeed = BK_BOUNCE_SPEED;
float bk_paramBounceAmplitude = BK_BOUNCE_AMPLITUDE;
float bk_paramBlinkSpeed = BK_BLINK_SPEED;
float bk_paramPulseSpeed = BK_PULSE_SPEED;
float bk_paramPulseSize = BK_PULSE_SIZE;
float bk_paramSpinSpeed = BK_SPIN_SPEED;
float bk_paramFadeSpeed = BK_FADE_SPEED;
float bk_paramIteratingSpeed = BK_ITERATING_SPEED;
float bk_paramIteratingSpace = BK_ITERATING_SPACE;
float bk_paramGlitchSpeed = BK_GLITCH_SPEED;
float bk_paramGlitchIntensity = BK_GLITCH_INTENSITY;
float bk_paramScaleFactor = BK_SCALE_FACTOR;
float bk_paramScaleOffsetX = BK_SCALE_OFFSET_X;
float bk_paramScaleOffsetY = BK_SCALE_OFFSET_Y;
vec3 bk_paramGradientStart = BK_GRADIENT_START;
float bk_paramGradientStartA = 1.0;
vec3 bk_paramGradientEnd = BK_GRADIENT_END;
float bk_paramGradientEndA = 1.0;
float bk_paramGradientDirection = BK_GRADIENT_DIRECTION;
vec3 bk_paramDynGradientStart = BK_DYN_GRADIENT_START;
float bk_paramDynGradientStartA = 1.0;
vec3 bk_paramDynGradientEnd = BK_DYN_GRADIENT_END;
float bk_paramDynGradientEndA = 1.0;
float bk_paramDynGradientDirection = BK_DYN_GRADIENT_DIRECTION;
float bk_paramDynGradientSpeed = BK_DYN_GRADIENT_SPEED;
vec3 bk_paramAuroraColor1 = BK_AURORA_COLOR_1;
float bk_paramAuroraColor1A = 1.0;
vec3 bk_paramAuroraColor2 = BK_AURORA_COLOR_2;
float bk_paramAuroraColor2A = 1.0;
vec3 bk_paramAuroraColor3 = BK_AURORA_COLOR_3;
float bk_paramAuroraColor3A = 1.0;
vec3 bk_paramAuroraColor4 = vec3(0.0);
float bk_paramAuroraColor4A = 1.0;
float bk_paramAuroraSpeed = BK_AURORA_SPEED;
float bk_paramSplitIntensity = BK_SPLIT_INTENSITY;
float bk_paramSplitSpeed = BK_SPLIT_SPEED;
vec4 bk_paramOutlineColor = BK_OUTLINE_COLOR;
float bk_paramOutlineThickness = BK_OUTLINE_THICKNESS;
vec4 bk_paramHatchColor = BK_HATCH_COLOR;
float bk_paramHatchSpeed = BK_HATCH_SPEED;
float bk_paramHatchDensity = BK_HATCH_DENSITY;
vec4 bk_paramNeonColor = BK_NEON_COLOR;
float bk_paramNeonIntensity = BK_NEON_INTENSITY;
float bk_paramNeonSpeed = BK_NEON_SPEED;
float bk_paramChromaticIntensity = BK_CHROMATIC_INTENSITY;
float bk_paramChromaticSpeed = BK_CHROMATIC_SPEED;
float bk_paramExtrudeDepth = BK_EXTRUDE_DEPTH;
float bk_paramExtrudeLayers = BK_EXTRUDE_LAYERS;
vec4 bk_paramExtrudeColor = BK_EXTRUDE_COLOR;
vec4 bk_paramExtrudeColor2 = BK_EXTRUDE_COLOR;
vec4 bk_paramExtrudeColor3 = BK_EXTRUDE_COLOR;
float bk_paramExtrudeUseColor = 0.0;
float bk_paramNoiseIntensity = BK_NOISE_INTENSITY;
float bk_paramNoiseSpeed = BK_NOISE_SPEED;
float bk_paramLiquidIntensity = BK_LIQUID_INTENSITY;
float bk_paramLiquidSpeed = BK_LIQUID_SPEED;
vec4 bk_paramWaterColor = BK_WATER_COLOR;
float bk_paramWaterLevel = BK_WATER_LEVEL;
float bk_paramWaterAmplitude = BK_WATER_AMPLITUDE;
float bk_paramWaterSpeed = BK_WATER_SPEED;
float bk_paramWaterFrequency = BK_WATER_FREQUENCY;
float bk_paramJumpSpeed = 1.0;
float bk_paramJumpHeight = 3.0;

// ------------------------------------------------------------ kolory (skladnia Blockly)
vec3 bk_rgb(float r, float g, float b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}
vec3 bk_rgb(uint v) {
    return vec3(float((v >> 16) & 0xFFu), float((v >> 8) & 0xFFu), float(v & 0xFFu)) / 255.0;
}
vec3 bk_rgb(int v) {
    return bk_rgb(uint(v));
}
vec4 bk_rgba(float r, float g, float b, float a) {
    return vec4(r / 255.0, g / 255.0, b / 255.0, a);
}
vec4 bk_rgba(uint v) {
    return vec4(float((v >> 24) & 0xFFu), float((v >> 16) & 0xFFu), float((v >> 8) & 0xFFu), float(v & 0xFFu)) / 255.0;
}
vec4 bk_rgba(int v) {
    return bk_rgba(uint(v));
}
vec4 bk_argb(float a, float r, float g, float b) {
    return vec4(r / 255.0, g / 255.0, b / 255.0, a);
}
vec4 bk_argb(uint v) {
    float a = float((v >> 24) & 0xFFu) / 255.0;
    return vec4(float((v >> 16) & 0xFFu) / 255.0, float((v >> 8) & 0xFFu) / 255.0, float(v & 0xFFu) / 255.0, a);
}
vec4 bk_argb(int v) {
    return bk_argb(uint(v));
}

// porownanie koloru-wyzwalacza (0-255) z rgb()/rgba(); alfa ignorowana
bool bk_colorMatches(ivec3 c, vec3 target) {
    return c == ivec3(target * 255.0 + 0.5);
}
bool bk_colorMatches(ivec3 c, vec4 target) {
    return bk_colorMatches(c, target.rgb);
}
// kolor glowny ALBO jego cien (MC rysuje cien jako kolor * 0.25)
bool bk_checkAndSetShadow(ivec3 c, vec3 target) {
    ivec3 t = ivec3(target * 255.0 + 0.5);
    if (c == t) return true;
    if (c == t / 4) {
        bk_currentIsShadow = true;
        return true;
    }
    return false;
}
bool bk_checkAndSetShadow(ivec3 c, vec4 target) {
    return bk_checkAndSetShadow(c, target.rgb);
}

// ------------------------------------------------------------ API (apply_xxx w configu)
void bk_apply_color(vec3 color) { bk_currentBaseColor.rgb = color; bk_flagColorOverride = true; }
void bk_apply_color(vec4 color) { bk_currentBaseColor = color; bk_flagColorOverride = true; }

bool bk_hasAnyEffect() {
    return bk_flagShake || bk_flagWavy || bk_flagRainbow || bk_flagBouncy || bk_flagBlinking ||
           bk_flagPulse || bk_flagSpin || bk_flagSequentialSpin || bk_flagFade ||
           bk_flagIterating || bk_flagGlitch || bk_flagScale || bk_flagGradient || bk_flagDynamicGradient ||
           bk_flagAurora || bk_flagSplit || bk_flagOutline || bk_flagHatch || bk_flagNeon ||
           bk_flagColorOverride || bk_flagChromatic || bk_flagExtrude || bk_flagNoise || bk_flagLiquid ||
           bk_flagWater || bk_flagJump;
}

void bk_apply_shake() { bk_flagShake = true; }
void bk_apply_shake(float speed, float intensity) { bk_flagShake = true; bk_paramShakeSpeed = speed; bk_paramShakeIntensity = intensity; }

void bk_apply_wavy() { bk_flagWavy = true; }
void bk_apply_wavy(float speed) { bk_flagWavy = true; bk_paramWaveSpeed = speed; }
void bk_apply_wavy(float speed, float amplitude) { bk_flagWavy = true; bk_paramWaveSpeed = speed; bk_paramWaveAmplitude = amplitude; }
void bk_apply_wavy(float speed, float amplitude, float xFrequency) { bk_flagWavy = true; bk_paramWaveSpeed = speed; bk_paramWaveAmplitude = amplitude; bk_paramWaveXFrequency = xFrequency; }

void bk_apply_rainbow() { bk_flagRainbow = true; }
void bk_apply_rainbow(float speed) { bk_flagRainbow = true; bk_paramRainbowSpeed = speed; }

void bk_apply_bouncy() { bk_flagBouncy = true; }
void bk_apply_bouncy(float speed) { bk_flagBouncy = true; bk_paramBounceSpeed = speed; }
void bk_apply_bouncy(float speed, float amplitude) { bk_flagBouncy = true; bk_paramBounceSpeed = speed; bk_paramBounceAmplitude = amplitude; }

void bk_apply_blinking() { bk_flagBlinking = true; }
void bk_apply_blinking(float speed) { bk_flagBlinking = true; bk_paramBlinkSpeed = speed; }

void bk_apply_pulse() { bk_flagPulse = true; }
void bk_apply_pulse(float speed) { bk_flagPulse = true; bk_paramPulseSpeed = speed; }
void bk_apply_pulse(float speed, float size) { bk_flagPulse = true; bk_paramPulseSpeed = speed; bk_paramPulseSize = size; }

void bk_apply_spin() { bk_flagSpin = true; }
void bk_apply_spin(float speed) { bk_flagSpin = true; bk_paramSpinSpeed = speed; }

void bk_apply_sequential_spin() { bk_flagSequentialSpin = true; }
void bk_apply_sequential_spin(float speed) { bk_flagSequentialSpin = true; bk_paramSpinSpeed = speed; }

void bk_apply_fade() { bk_flagFade = true; }
void bk_apply_fade(float speed) { bk_flagFade = true; bk_paramFadeSpeed = speed; }

void bk_apply_iterating() { bk_flagIterating = true; }
void bk_apply_iterating(float speed) { bk_flagIterating = true; bk_paramIteratingSpeed = speed; }
void bk_apply_iterating(float speed, float space) { bk_flagIterating = true; bk_paramIteratingSpeed = speed; bk_paramIteratingSpace = space; }

void bk_apply_scale(float scale) { bk_flagScale = true; bk_paramScaleFactor = scale; }
void bk_apply_scale(float scale, float offsetX, float offsetY) { bk_flagScale = true; bk_paramScaleFactor = scale; bk_paramScaleOffsetX = offsetX; bk_paramScaleOffsetY = offsetY; }
void bk_apply_offset(float offsetX, float offsetY) { bk_flagScale = true; bk_paramScaleFactor = 0.0; bk_paramScaleOffsetX = offsetX; bk_paramScaleOffsetY = offsetY; }

void bk_apply_glitch() { bk_flagGlitch = true; }
void bk_apply_glitch(float speed, float intensity) { bk_flagGlitch = true; bk_paramGlitchSpeed = speed; bk_paramGlitchIntensity = intensity; }

void bk_apply_gradient(vec3 start, vec3 end, float direction) {
    bk_flagGradient = true; bk_paramGradientStart = start; bk_paramGradientEnd = end; bk_paramGradientDirection = direction;
}
void bk_apply_gradient(vec4 start, vec4 end, float direction) {
    bk_flagGradient = true;
    bk_paramGradientStart = start.rgb; bk_paramGradientStartA = start.a;
    bk_paramGradientEnd = end.rgb; bk_paramGradientEndA = end.a;
    bk_paramGradientDirection = direction;
}
void bk_apply_gradient(vec3 start, vec3 end) { bk_apply_gradient(start, end, BK_GRADIENT_DIRECTION); }
void bk_apply_gradient() { bk_flagGradient = true; }

void bk_apply_dynamic_gradient(vec3 start, vec3 end, float direction, float speed) {
    bk_flagDynamicGradient = true; bk_paramDynGradientStart = start; bk_paramDynGradientEnd = end;
    bk_paramDynGradientDirection = direction; bk_paramDynGradientSpeed = speed;
}
void bk_apply_dynamic_gradient(vec4 start, vec4 end, float direction, float speed) {
    bk_flagDynamicGradient = true;
    bk_paramDynGradientStart = start.rgb; bk_paramDynGradientStartA = start.a;
    bk_paramDynGradientEnd = end.rgb; bk_paramDynGradientEndA = end.a;
    bk_paramDynGradientDirection = direction; bk_paramDynGradientSpeed = speed;
}
void bk_apply_dynamic_gradient(vec3 start, vec3 end, float direction) { bk_apply_dynamic_gradient(start, end, direction, BK_DYN_GRADIENT_SPEED); }
void bk_apply_dynamic_gradient(vec3 start, vec3 end) { bk_apply_dynamic_gradient(start, end, BK_DYN_GRADIENT_DIRECTION, BK_DYN_GRADIENT_SPEED); }
void bk_apply_dynamic_gradient() { bk_flagDynamicGradient = true; }

void bk_apply_lava(float speed) { bk_apply_dynamic_gradient(bk_rgb(255.0, 20.0, 0.0), bk_rgb(255.0, 200.0, 0.0), 2.0, speed); }
void bk_apply_lava() { bk_apply_lava(300.0); }

void bk_apply_aurora(vec4 c1, vec4 c2, vec4 c3, float speed) {
    bk_flagAurora = true;
    bk_paramAuroraColor1 = c1.rgb; bk_paramAuroraColor1A = c1.a;
    bk_paramAuroraColor2 = c2.rgb; bk_paramAuroraColor2A = c2.a;
    bk_paramAuroraColor3 = c3.rgb; bk_paramAuroraColor3A = c3.a;
    bk_paramAuroraSpeed = speed;
}
void bk_apply_aurora(vec3 c1, vec3 c2, vec3 c3, float speed) {
    bk_flagAurora = true;
    bk_paramAuroraColor1 = c1; bk_paramAuroraColor2 = c2; bk_paramAuroraColor3 = c3;
    bk_paramAuroraSpeed = speed;
}
void bk_apply_aurora(vec3 c1, vec3 c2, vec3 c3, vec3 c4, float speed) {
    bk_flagAurora = true; bk_flagAurora4 = true;
    bk_paramAuroraColor1 = c1; bk_paramAuroraColor2 = c2; bk_paramAuroraColor3 = c3; bk_paramAuroraColor4 = c4;
    bk_paramAuroraSpeed = speed;
}
void bk_apply_aurora(vec4 c1, vec4 c2, vec4 c3, vec4 c4, float speed) {
    bk_flagAurora = true; bk_flagAurora4 = true;
    bk_paramAuroraColor1 = c1.rgb; bk_paramAuroraColor1A = c1.a;
    bk_paramAuroraColor2 = c2.rgb; bk_paramAuroraColor2A = c2.a;
    bk_paramAuroraColor3 = c3.rgb; bk_paramAuroraColor3A = c3.a;
    bk_paramAuroraColor4 = c4.rgb; bk_paramAuroraColor4A = c4.a;
    bk_paramAuroraSpeed = speed;
}
void bk_apply_aurora(float speed) { bk_flagAurora = true; bk_paramAuroraSpeed = speed; }
void bk_apply_aurora() { bk_flagAurora = true; }

void bk_apply_split(float intensity, float speed) { bk_flagSplit = true; bk_paramSplitIntensity = intensity; bk_paramSplitSpeed = speed; }
void bk_apply_split(float intensity) { bk_flagSplit = true; bk_paramSplitIntensity = intensity; }
void bk_apply_split() { bk_flagSplit = true; }

void bk_apply_outline(vec4 color, float thickness) { bk_flagOutline = true; bk_paramOutlineColor = color; bk_paramOutlineThickness = thickness; }
void bk_apply_outline(vec3 color, float thickness) { bk_flagOutline = true; bk_paramOutlineColor = vec4(color, 1.0); bk_paramOutlineThickness = thickness; }
void bk_apply_outline(vec3 color) { bk_flagOutline = true; bk_paramOutlineColor = vec4(color, 1.0); }
void bk_apply_outline() { bk_flagOutline = true; }

void bk_apply_hatch(vec4 color, float speed, float density) { bk_flagHatch = true; bk_paramHatchColor = color; bk_paramHatchSpeed = speed; bk_paramHatchDensity = density; }
void bk_apply_hatch(vec3 color, float speed, float density) { bk_flagHatch = true; bk_paramHatchColor = vec4(color, 1.0); bk_paramHatchSpeed = speed; bk_paramHatchDensity = density; }
void bk_apply_hatch(float speed) { bk_flagHatch = true; bk_paramHatchSpeed = speed; }
void bk_apply_hatch() { bk_flagHatch = true; }

void bk_apply_neon(vec4 color, float intensity, float speed) { bk_flagNeon = true; bk_paramNeonColor = color; bk_paramNeonIntensity = intensity; bk_paramNeonSpeed = speed; }
void bk_apply_neon(vec3 color, float intensity) { bk_flagNeon = true; bk_paramNeonColor = vec4(color, 1.0); bk_paramNeonIntensity = intensity; }
void bk_apply_neon(vec3 color) { bk_flagNeon = true; bk_paramNeonColor = vec4(color, 1.0); }
void bk_apply_neon() { bk_flagNeon = true; }

void bk_apply_chromatic() { bk_flagChromatic = true; }
void bk_apply_chromatic(float intensity) { bk_flagChromatic = true; bk_paramChromaticIntensity = intensity; }
void bk_apply_chromatic(float intensity, float speed) { bk_flagChromatic = true; bk_paramChromaticIntensity = intensity; bk_paramChromaticSpeed = speed; }

void bk_apply_extrude() { bk_flagExtrude = true; bk_paramExtrudeUseColor = 0.0; }
void bk_apply_extrude(float depth) { bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeUseColor = 0.0; }
void bk_apply_extrude(float depth, float layers) { bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeLayers = layers; bk_paramExtrudeUseColor = 0.0; }
void bk_apply_extrude(float depth, float layers, vec3 endColor) {
    bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeLayers = layers;
    bk_paramExtrudeColor = vec4(endColor, 1.0); bk_paramExtrudeUseColor = 1.0;
}
void bk_apply_extrude(float depth, float layers, vec4 endColor) {
    bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeLayers = layers;
    bk_paramExtrudeColor = endColor; bk_paramExtrudeUseColor = 1.0;
}
void bk_apply_extrude(float depth, float layers, vec3 c1, vec3 c2, vec3 c3) {
    bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeLayers = layers;
    bk_paramExtrudeColor = vec4(c1, 1.0); bk_paramExtrudeColor2 = vec4(c2, 1.0); bk_paramExtrudeColor3 = vec4(c3, 1.0);
    bk_paramExtrudeUseColor = 2.0;
}
void bk_apply_extrude(float depth, float layers, vec4 c1, vec4 c2, vec4 c3) {
    bk_flagExtrude = true; bk_paramExtrudeDepth = depth; bk_paramExtrudeLayers = layers;
    bk_paramExtrudeColor = c1; bk_paramExtrudeColor2 = c2; bk_paramExtrudeColor3 = c3;
    bk_paramExtrudeUseColor = 2.0;
}

void bk_apply_noise() { bk_flagNoise = true; }
void bk_apply_noise(float intensity) { bk_flagNoise = true; bk_paramNoiseIntensity = intensity; }
void bk_apply_noise(float intensity, float speed) { bk_flagNoise = true; bk_paramNoiseIntensity = intensity; bk_paramNoiseSpeed = speed; }

void bk_apply_liquid() { bk_flagLiquid = true; }
void bk_apply_liquid(float intensity) { bk_flagLiquid = true; bk_paramLiquidIntensity = intensity; }
void bk_apply_liquid(float intensity, float speed) { bk_flagLiquid = true; bk_paramLiquidIntensity = intensity; bk_paramLiquidSpeed = speed; }

void bk_apply_water() { bk_flagWater = true; }
void bk_apply_water(vec3 color) { bk_flagWater = true; bk_paramWaterColor = vec4(color, 1.0); }
void bk_apply_water(vec4 color) { bk_flagWater = true; bk_paramWaterColor = color; }
void bk_apply_water(vec3 color, float level) { bk_flagWater = true; bk_paramWaterColor = vec4(color, 1.0); bk_paramWaterLevel = level; }
void bk_apply_water(vec3 color, float level, float amplitude, float speed) {
    bk_flagWater = true; bk_paramWaterColor = vec4(color, 1.0); bk_paramWaterLevel = level;
    bk_paramWaterAmplitude = amplitude; bk_paramWaterSpeed = speed;
}
void bk_apply_water(vec4 color, float level, float amplitude, float speed) {
    bk_flagWater = true; bk_paramWaterColor = color; bk_paramWaterLevel = level;
    bk_paramWaterAmplitude = amplitude; bk_paramWaterSpeed = speed;
}
void bk_apply_water(vec3 color, float level, float amplitude, float speed, float frequency) {
    bk_flagWater = true; bk_paramWaterColor = vec4(color, 1.0); bk_paramWaterLevel = level;
    bk_paramWaterAmplitude = amplitude; bk_paramWaterSpeed = speed; bk_paramWaterFrequency = frequency;
}

void bk_apply_jump() { bk_flagJump = true; }
void bk_apply_jump(float speed) { bk_flagJump = true; bk_paramJumpSpeed = speed; }
void bk_apply_jump(float speed, float height) { bk_flagJump = true; bk_paramJumpSpeed = speed; bk_paramJumpHeight = height; }

// ------------------------------------------------------------ geometria
void bk_setOffset(float x, float y) {
    bk_currentOffset = vec2(x, y);
}

void bk_applyOffset(inout vec4 vertex) {
    if (ProjMat[3][3] != 0.0) {
        // GUI: 1 jednostka = 1 piksel GUI
        vertex.xy += bk_currentOffset;
    } else {
        // tekst w swiecie: przesuniecie w plaszczyznie kamery
        float worldScale = 0.05;
        vec3 cameraRight = vec3(ModelViewMat[0][0], ModelViewMat[1][0], ModelViewMat[2][0]);
        vec3 cameraUp    = vec3(ModelViewMat[0][1], ModelViewMat[1][1], ModelViewMat[2][1]);
        vertex.xyz += cameraRight * (bk_currentOffset.x * worldScale);
        vertex.xyz -= cameraUp * (bk_currentOffset.y * worldScale);
    }
}

void bk_applyProjection(vec4 vertex) {
    gl_Position = ProjMat * ModelViewMat * vertex;
}

void bk_processSpin(vec4 vertex, float speed) {
    if (speed <= 0.0) speed = 2500.0;
    float time = GameTime * speed;
    float period = PI * 2.0;
    float cycle = mod(time, period);
    float cosA = cos(cycle);
    bk_spinFlip = (cosA < 0.0) ? 1.0 : 0.0;
    bk_spinScale = abs(cosA);
    bk_applyProjection(vertex);
}

void bk_processSequentialSpin(vec4 vertex, float speed) {
    if (speed <= 0.0) speed = 2500.0;
    // GUI: indeks znaku z pozycji (stabilny przy przesuwaniu sie batcha), swiat: z gl_VertexID
    float charIndex = (ProjMat[3][3] != 0.0)
        ? floor(Position.x / 6.0)
        : floor(float(gl_VertexID) / 4.0);
    float t = mod((charIndex * 0.4 - GameTime * speed / TAU), 5.0);
    float cosA = (t > 1.0) ? 1.0 : cos(TAU * t);
    bk_spinFlip = (cosA < 0.0) ? 1.0 : 0.0;
    bk_spinScale = abs(cosA);
    bk_applyProjection(vertex);
}

void bk_applyHueColor(float speed, float xPos, float yPos, float alpha) {
    if (speed <= 0.0) speed = 1000.0;
    float spatial;
    if (ProjMat[3][3] != 0.0) {
        spatial = xPos + yPos;
    } else {
        float charId = floor(float(gl_VertexID) / 4.0);
        float vid = mod(float(gl_VertexID), 4.0);
        float x_t = (vid == 2.0 || vid == 3.0) ? 1.0 : 0.0;
        float y_t = (vid == 1.0 || vid == 2.0) ? 1.0 : 0.0;
        spatial = (charId + x_t) * 6.0 + y_t * 7.0;
    }
    vec3 rainbowColor = bk_hue((GameTime * speed) + spatial * 0.01);
    vertexColor = vec4(rainbowColor, alpha) * lightColor;
}

vec2 bk_cornerDir(float vid) {
    if      (vid < 0.5) return vec2(-1.0, -1.0);
    else if (vid < 1.5) return vec2(-1.0,  1.0);
    else if (vid < 2.5) return vec2( 1.0,  1.0);
    return vec2( 1.0, -1.0);
}

// ------------------------------------------------------------ glowny pipeline Blockly
void bk_applyEffect(vec4 vertex, vec4 baseCol, bool isShadow) {
    vec4 displayColor = isShadow ? vec4(baseCol.rgb * 0.25, baseCol.a) : baseCol;
    float vidf = mod(float(gl_VertexID), 4.0);

    // Phase 1: miganie (caly znak poza ekran)
    if (bk_flagBlinking) {
        float blink = step(0.5, fract(GameTime * bk_paramBlinkSpeed * 1200.0));
        if (blink < 0.5) {
            gl_Position = vec4(2.0, 2.0, 2.0, 1.0);
            vertexColor = vec4(0.0);
            return;
        }
    }

    // Phase 2: modyfikacje wierzcholkow przed projekcja
    if (bk_flagShake) {
        float charId = floor(float(gl_VertexID) / 4.0);
        float shakeTime = GameTime * 32000.0 * bk_paramShakeSpeed;
        float noiseX = bk_noise(charId * 10.0 + shakeTime) - 0.5;
        float noiseY = bk_noise(charId * 10.0 - shakeTime + 100.0) - 0.5;
        bk_setOffset(noiseX * bk_paramShakeIntensity, noiseY * bk_paramShakeIntensity);
        bk_applyOffset(vertex);
    }

    if (bk_flagBouncy) {
        float bounceTime = GameTime * bk_paramBounceSpeed;
        if (vidf == 3.0 || vidf == 0.0) {
            bk_setOffset(0.0, cos(bounceTime) * bk_paramBounceAmplitude + max(cos(bounceTime) * bk_paramBounceAmplitude, 0.0));
            bk_applyOffset(vertex);
        }
    }

    if (bk_flagJump) {
        float jSpeed = bk_paramJumpSpeed <= 0.0 ? 1.0 : bk_paramJumpSpeed;
        float jHeight = bk_paramJumpHeight <= 0.0 ? 3.0 : bk_paramJumpHeight;
        float jumpTime = fract(GameTime * 600.0 * jSpeed);
        if (jumpTime < 0.25) {
            float jumpProgress = jumpTime / 0.25;
            float jumpY = sin(jumpProgress * 3.14159265) * jHeight;
            bk_setOffset(0.0, -jumpY);
            bk_applyOffset(vertex);
        }
    }

    if (bk_flagPulse) {
        float pulseTime = GameTime * bk_paramPulseSpeed * 1000.0;
        float pulseFactor = (sin(pulseTime) * 0.5 + 0.5);
        float expansion = bk_paramPulseSize * 2.5 * pulseFactor;
        vec2 pulseOffset = bk_cornerDir(vidf) * vec2(0.7, 1.0) * expansion;
        bk_setOffset(pulseOffset.x, pulseOffset.y);
        bk_applyOffset(vertex);
    }

    if (bk_flagIterating) {
        float iterSpeed = bk_paramIteratingSpeed <= 0.0 ? 1.0 : bk_paramIteratingSpeed;
        float iterSpace = bk_paramIteratingSpace <= 0.0 ? 1.0 : bk_paramIteratingSpace;
        float charId = (ProjMat[3][3] != 0.0)
            ? floor(Position.x / 6.0)
            : floor(float(gl_VertexID) / 4.0);
        float iterTime = GameTime * 18000.0 * iterSpeed;
        float iterX = mod(charId * 0.4 - iterTime, (5.0 * iterSpace) * TAU);
        if (iterX > TAU) iterX = TAU;
        bk_setOffset(0.0, (-cos(iterX) * 0.5 + 0.5) * -2.0);
        bk_applyOffset(vertex);
    }

    if (bk_flagGlitch) {
        float gSpeed = bk_paramGlitchSpeed <= 0.0 ? 1.0 : bk_paramGlitchSpeed;
        float gIntensity = bk_paramGlitchIntensity <= 0.0 ? 2.0 : bk_paramGlitchIntensity;
        float glitchTime = floor(GameTime * 32000.0 * gSpeed);
        float glitchCharId = floor(float(gl_VertexID) / 4.0);
        float glitchTrigger = bk_random(vec2(glitchTime * 0.1, 0.0));
        float glitchOffX = 0.0;
        float glitchOffY = 0.0;
        if (glitchTrigger > 0.7) glitchOffX = (bk_random(vec2(glitchCharId + glitchTime, 1.0)) - 0.5) * gIntensity * 4.0;
        if (glitchTrigger > 0.85) glitchOffY = (bk_random(vec2(glitchCharId - glitchTime + 50.0, 2.0)) - 0.5) * gIntensity;
        bk_setOffset(glitchOffX, glitchOffY);
        bk_applyOffset(vertex);
    }

    if (bk_flagScale) {
        float actualExpansion = (bk_paramScaleFactor - 1.0) * 4.0;
        vec2 scaleOffset = bk_cornerDir(vidf) * vec2(0.7, 1.0) * actualExpansion + vec2(bk_paramScaleOffsetX, bk_paramScaleOffsetY);
        bk_setOffset(scaleOffset.x, scaleOffset.y);
        bk_applyOffset(vertex);
    }

    // efekty fragmentowe potrzebuja miejsca wokol litery (powiekszenie quada)
    if (bk_flagOutline) {
        vec2 outDir = bk_cornerDir(vidf);
        float pad = bk_paramOutlineThickness + 1.0;
        bk_setOffset(outDir.x * pad, outDir.y * pad);
        bk_applyOffset(vertex);
        texCoord0 += outDir * (pad / 256.0);
    }

    if (bk_flagSplit) {
        if (vidf == 0.0 || vidf == 1.0) {
            bk_setOffset(-bk_paramSplitIntensity * 1.6, 0.0);
            bk_applyOffset(vertex);
        }
    }

    if (bk_flagChromatic) {
        float dx = (vidf == 0.0 || vidf == 1.0) ? -1.0 : 1.0;
        float pad = bk_paramChromaticIntensity * 1.5;
        bk_setOffset(dx * pad, 0.0);
        bk_applyOffset(vertex);
        texCoord0.x += dx * pad / 256.0;
    }

    if (bk_flagExtrude) {
        bool isRight  = (vidf == 2.0 || vidf == 3.0);
        bool isBottom = (vidf == 1.0 || vidf == 2.0);
        float pad = bk_paramExtrudeDepth * bk_paramExtrudeLayers + 1.0;
        bk_setOffset(isRight ? pad : 0.0, isBottom ? pad : 0.0);
        bk_applyOffset(vertex);
        texCoord0 += vec2(isRight ? pad / 256.0 : 0.0, isBottom ? pad / 256.0 : 0.0);
    }

    if (bk_flagNoise) {
        vec2 outDir = bk_cornerDir(vidf);
        float pad = bk_paramNoiseIntensity + 1.0;
        bk_setOffset(outDir.x * pad, outDir.y * pad);
        bk_applyOffset(vertex);
        texCoord0 += outDir * (pad / 256.0);
    }

    if (bk_flagLiquid) {
        vec2 outDir = bk_cornerDir(vidf);
        float pad = bk_paramLiquidIntensity + 1.0;
        bk_setOffset(outDir.x * pad, outDir.y * pad);
        bk_applyOffset(vertex);
        texCoord0 += outDir * (pad / 256.0);
    }

    float preX = vertex.x;
    float preY = vertex.y;

    // Phase 3: projekcja (+ obrot)
    if (bk_flagSequentialSpin) {
        bk_processSequentialSpin(vertex, bk_paramSpinSpeed);
    } else if (bk_flagSpin) {
        bk_processSpin(vertex, bk_paramSpinSpeed);
    } else {
        bk_applyProjection(vertex);
    }

    // Phase 4: fala po projekcji
    if (bk_flagWavy) {
        if (ProjMat[3][3] != 0.0) {
            gl_Position.y += sin(GameTime * bk_paramWaveSpeed + (Position.x * bk_paramWaveXFrequency)) * (bk_paramWaveAmplitude / 150.0);
        } else {
            float charId = floor(float(gl_VertexID) / 4.0);
            float charX = charId + step(1.5, vidf);
            float wave = sin(GameTime * bk_paramWaveSpeed + charX * bk_paramWaveXFrequency * 6.0) * bk_paramWaveAmplitude * 0.05;
            gl_Position.y += ProjMat[1][1] * wave;
        }
    }

    // Phase 5: kolor (lightColor = lightmapa liczona w main(), 1.0 w GUI / see-through)
    if (bk_flagAurora) {
        float s = isShadow ? 0.25 : 1.0;
        float spatialAurora;
        if (ProjMat[3][3] != 0.0) {
            spatialAurora = preX + preY;
        } else {
            float aCharId = floor(float(gl_VertexID) / 4.0);
            float aXt = (vidf == 2.0 || vidf == 3.0) ? 1.0 : 0.0;
            float aYt = (vidf == 1.0 || vidf == 2.0) ? 1.0 : 0.0;
            spatialAurora = (aCharId + aXt) * 6.0 + aYt * 7.0;
        }
        float auroraT = fract(GameTime * bk_paramAuroraSpeed + spatialAurora * 0.01);
        vec3 auroraColor;
        float auroraAlpha;
        if (bk_flagAurora4) {
            float quarter = 0.25;
            if (auroraT < quarter) {
                float lt = auroraT / quarter;
                auroraColor = mix(bk_paramAuroraColor1, bk_paramAuroraColor2, lt);
                auroraAlpha = mix(bk_paramAuroraColor1A, bk_paramAuroraColor2A, lt);
            } else if (auroraT < 2.0 * quarter) {
                float lt = (auroraT - quarter) / quarter;
                auroraColor = mix(bk_paramAuroraColor2, bk_paramAuroraColor3, lt);
                auroraAlpha = mix(bk_paramAuroraColor2A, bk_paramAuroraColor3A, lt);
            } else if (auroraT < 3.0 * quarter) {
                float lt = (auroraT - 2.0 * quarter) / quarter;
                auroraColor = mix(bk_paramAuroraColor3, bk_paramAuroraColor4, lt);
                auroraAlpha = mix(bk_paramAuroraColor3A, bk_paramAuroraColor4A, lt);
            } else {
                float lt = (auroraT - 3.0 * quarter) / quarter;
                auroraColor = mix(bk_paramAuroraColor4, bk_paramAuroraColor1, lt);
                auroraAlpha = mix(bk_paramAuroraColor4A, bk_paramAuroraColor1A, lt);
            }
        } else {
            float third = 1.0 / 3.0;
            if (auroraT < third) {
                float lt = auroraT / third;
                auroraColor = mix(bk_paramAuroraColor1, bk_paramAuroraColor2, lt);
                auroraAlpha = mix(bk_paramAuroraColor1A, bk_paramAuroraColor2A, lt);
            } else if (auroraT < 2.0 * third) {
                float lt = (auroraT - third) / third;
                auroraColor = mix(bk_paramAuroraColor2, bk_paramAuroraColor3, lt);
                auroraAlpha = mix(bk_paramAuroraColor2A, bk_paramAuroraColor3A, lt);
            } else {
                float lt = (auroraT - 2.0 * third) / third;
                auroraColor = mix(bk_paramAuroraColor3, bk_paramAuroraColor1, lt);
                auroraAlpha = mix(bk_paramAuroraColor3A, bk_paramAuroraColor1A, lt);
            }
        }
        vertexColor = vec4(auroraColor * s, auroraAlpha * displayColor.a) * lightColor;
    } else if (bk_flagRainbow) {
        bk_applyHueColor(bk_paramRainbowSpeed, preX, preY, displayColor.a);
    } else if (bk_flagDynamicGradient) {
        float s = isShadow ? 0.25 : 1.0;
        int dynDir = int(bk_paramDynGradientDirection);
        float spatialX, spatialY;
        if (ProjMat[3][3] != 0.0) {
            spatialX = preX;
            spatialY = preY;
        } else {
            float dynCharId = floor(float(gl_VertexID) / 4.0);
            float dynXt = (vidf == 2.0 || vidf == 3.0) ? 1.0 : 0.0;
            float dynYt = (vidf == 1.0 || vidf == 2.0) ? 1.0 : 0.0;
            spatialX = (dynCharId + dynXt) * 6.0;
            spatialY = dynYt * 7.0;
        }
        float spatial;
        if      (dynDir == 0) spatial =  spatialY;
        else if (dynDir == 1) spatial =  spatialX + spatialY;
        else if (dynDir == 2) spatial =  spatialX;
        else if (dynDir == 3) spatial =  spatialX - spatialY;
        else if (dynDir == 4) spatial = -spatialY;
        else if (dynDir == 5) spatial = -spatialX - spatialY;
        else if (dynDir == 6) spatial = -spatialX;
        else                  spatial = -spatialX + spatialY;
        float dynT = 1.0 - abs(fract(GameTime * bk_paramDynGradientSpeed + spatial * 0.01) * 2.0 - 1.0);
        vec3 dynColor = mix(bk_paramDynGradientStart * s, bk_paramDynGradientEnd * s, dynT);
        float dynAlpha = mix(bk_paramDynGradientStartA, bk_paramDynGradientEndA, dynT);
        vertexColor = vec4(dynColor, dynAlpha * displayColor.a) * lightColor;
    } else if (bk_flagGradient) {
        float s = isShadow ? 0.25 : 1.0;
        float x_t = (vidf == 2.0 || vidf == 3.0) ? 1.0 : 0.0;
        float y_t = (vidf == 1.0 || vidf == 2.0) ? 1.0 : 0.0;
        int gradDir = int(bk_paramGradientDirection);
        float gradT;
        if      (gradDir == 0) gradT = 1.0 - y_t;
        else if (gradDir == 1) gradT = (x_t + (1.0 - y_t)) * 0.5;
        else if (gradDir == 2) gradT = x_t;
        else if (gradDir == 3) gradT = (x_t + y_t) * 0.5;
        else if (gradDir == 4) gradT = y_t;
        else if (gradDir == 5) gradT = ((1.0 - x_t) + y_t) * 0.5;
        else if (gradDir == 6) gradT = 1.0 - x_t;
        else                   gradT = ((1.0 - x_t) + (1.0 - y_t)) * 0.5;
        vec3 gradColor = mix(bk_paramGradientStart * s, bk_paramGradientEnd * s, gradT);
        float gradAlpha = mix(bk_paramGradientStartA, bk_paramGradientEndA, gradT);
        vertexColor = vec4(gradColor, gradAlpha * displayColor.a) * lightColor;
    } else {
        vertexColor = displayColor * lightColor;
    }

    // Phase 5b: dane dla efektow fragmentowych
    float effectID = 0.0;
    vec4 effectColor = vec4(0.0);
    vec4 effectParams = vec4(0.0);
    vec4 extrude2 = vec4(0.0);
    vec4 extrude3 = vec4(0.0);
    if (bk_flagOutline) {
        effectID = 1.0; effectColor = bk_paramOutlineColor;
        effectParams = vec4(bk_paramOutlineThickness, 0.0, 0.0, 0.0);
    } else if (bk_flagHatch) {
        effectID = 2.0; effectColor = bk_paramHatchColor;
        effectParams = vec4(0.0, bk_paramHatchSpeed, bk_paramHatchDensity, 0.0);
    } else if (bk_flagNeon) {
        effectID = 3.0; effectColor = bk_paramNeonColor;
        effectParams = vec4(bk_paramNeonIntensity, bk_paramNeonSpeed, 0.0, 0.0);
    } else if (bk_flagSplit) {
        effectID = 5.0; effectColor = displayColor;
        effectParams = vec4(bk_paramSplitIntensity, bk_paramSplitSpeed, 0.0, 0.0);
    } else if (bk_flagChromatic) {
        effectID = 6.0; effectColor = displayColor;
        effectParams = vec4(bk_paramChromaticIntensity, bk_paramChromaticSpeed, 0.0, 0.0);
    } else if (bk_flagExtrude) {
        effectID = 7.0; effectColor = bk_paramExtrudeColor;
        extrude2 = bk_paramExtrudeColor2; extrude3 = bk_paramExtrudeColor3;
        effectParams = vec4(bk_paramExtrudeDepth, bk_paramExtrudeLayers, bk_paramExtrudeUseColor, 0.0);
    } else if (bk_flagNoise) {
        effectID = 8.0; effectColor = displayColor;
        effectParams = vec4(bk_paramNoiseIntensity, bk_paramNoiseSpeed, 0.0, 0.0);
    } else if (bk_flagLiquid) {
        effectID = 9.0; effectColor = displayColor;
        effectParams = vec4(bk_paramLiquidIntensity, bk_paramLiquidSpeed, 0.0, 0.0);
    } else if (bk_flagWater) {
        effectID = 10.0; effectColor = bk_paramWaterColor;
        effectParams = vec4(bk_paramWaterLevel, bk_paramWaterAmplitude, bk_paramWaterSpeed, bk_paramWaterFrequency);
    }

    // Phase 6: przezroczystosc
    if (bk_flagFade) {
        float fadeAlpha = (sin(GameTime * 3000.0 * bk_paramFadeSpeed) + 1.0) * 0.5;
        vertexColor.a *= fadeAlpha;
    }

    // Phase 7: lekkie przesuniecie glebi (tylko tekst w swiecie - w GUI psuloby kolejnosc warstw)
    if (ProjMat[3][3] == 0.0) {
        gl_Position.z -= 0.001;
    }

    // Phase 7b: przezroczystosc text display (Color.a)
    vertexColor.a *= Color.a;

    // Phase 8: przekazanie do fragment shadera przez sloty Chaliu
    vctfx_applyTextEffect = 2.0;
    vctfx_isShadow = isShadow ? 1.0 : 0.0;
    vctfx_changedScale = 0.0;
    vctfx_unitScale = vec2(0.0);
    vctfx_uvpos1 = vctfx_uvpos2 = vctfx_uvpos3 = vctfx_uvpos4 = vec3(0.0);
    int vid = gl_VertexID % 4;
    if (vid == 0) vctfx_uvpos1 = vec3(UV0, 1.0);
    if (vid == 1) vctfx_uvpos2 = vec3(UV0, 1.0);
    if (vid == 2) vctfx_uvpos3 = vec3(UV0, 1.0);
    if (vid == 3) vctfx_uvpos4 = vec3(UV0, 1.0);
    vctfx_screenPos = effectParams;                                  // parametry efektu
    vctfx_ipos1 = extrude2.rgb;                                      // extrude kolor 2
    vctfx_ipos2 = extrude3.rgb;                                      // extrude kolor 3
    vctfx_ipos3 = vec3(extrude2.a, extrude3.a, Color.a);             // alfy + przezroczystosc
    vctfx_ipos4 = vec3(effectID, bk_spinFlip, bk_spinScale);         // id efektu + obrot
    baseColor = displayColor;                                        // kolor bazowy efektu
    lightColor = effectColor;                                        // kolor efektu (juz nieuzywany jako lightmapa)
}

// ------------------------------------------------------------ wejscie z main()
bool applyBlocklyEffects() {
    ivec3 c = ivec3(Color.rgb * 255.0 + 0.5);
    bk_currentBaseColor = vec4(Color.rgb, 1.0);
    bk_currentIsShadow = false;

    // skladnia z configu Blockly -> funkcje bk_*
    #undef TEXT_EFFECT
    #define TEXT_EFFECT(COLOR) if (bk_colorMatches(c, COLOR))
    #define TEXT_EFFECT_WITH_SHADOW(COLOR) if (bk_checkAndSetShadow(c, COLOR))
    #define rgb bk_rgb
    #define rgba bk_rgba
    #define argb bk_argb
    #define apply_color bk_apply_color
    #define apply_shake bk_apply_shake
    #define apply_wavy bk_apply_wavy
    #define apply_rainbow bk_apply_rainbow
    #define apply_bouncy bk_apply_bouncy
    #define apply_blinking bk_apply_blinking
    #define apply_pulse bk_apply_pulse
    #define apply_spin bk_apply_spin
    #define apply_sequential_spin bk_apply_sequential_spin
    #define apply_fade bk_apply_fade
    #define apply_iterating bk_apply_iterating
    #define apply_scale bk_apply_scale
    #define apply_offset bk_apply_offset
    #define apply_glitch bk_apply_glitch
    #define apply_gradient bk_apply_gradient
    #define apply_dynamic_gradient bk_apply_dynamic_gradient
    #define apply_lava bk_apply_lava
    #define apply_aurora bk_apply_aurora
    #define apply_split bk_apply_split
    #define apply_outline bk_apply_outline
    #define apply_hatch bk_apply_hatch
    #define apply_neon bk_apply_neon
    #define apply_chromatic bk_apply_chromatic
    #define apply_extrude bk_apply_extrude
    #define apply_noise bk_apply_noise
    #define apply_liquid bk_apply_liquid
    #define apply_water bk_apply_water
    #define apply_jump bk_apply_jump

    #moj_import <minecraft:blockly_effects_config.glsl>

    #undef TEXT_EFFECT
    #undef TEXT_EFFECT_WITH_SHADOW
    #undef rgb
    #undef rgba
    #undef argb
    #undef apply_color
    #undef apply_shake
    #undef apply_wavy
    #undef apply_rainbow
    #undef apply_bouncy
    #undef apply_blinking
    #undef apply_pulse
    #undef apply_spin
    #undef apply_sequential_spin
    #undef apply_fade
    #undef apply_iterating
    #undef apply_scale
    #undef apply_offset
    #undef apply_glitch
    #undef apply_gradient
    #undef apply_dynamic_gradient
    #undef apply_lava
    #undef apply_aurora
    #undef apply_split
    #undef apply_outline
    #undef apply_hatch
    #undef apply_neon
    #undef apply_chromatic
    #undef apply_extrude
    #undef apply_noise
    #undef apply_liquid
    #undef apply_water
    #undef apply_jump

    if (!bk_hasAnyEffect()) return false;

    // Atlas mniejszy niz 256 (np. mapy rysowane shaderem tekstu) - bez efektow
    ivec2 atlasSize = textureSize(Sampler0, 0);
    if (atlasSize.x < 256 || atlasSize.y < 256) return false;

    texCoord0 = UV0;
    bk_applyEffect(vec4(Position, 1.0), bk_currentBaseColor, bk_currentIsShadow);
    fx_writeFog(Position);
    return true;
}

#endif // VSH

// =====================================================================
//  FRAGMENT SHADER
// =====================================================================
#ifdef FSH

// pokrycie litery: .a dla fontow bitmapowych, .r dla TTF / unifont
float bk_glyphA(vec2 uv) {
    return fx_glyph(uv).a;
}

vec2 bk_calculateUVBounds(vec3 t0, vec3 t1, vec3 t2, vec3 t3, out vec2 uvMin, out vec2 uvMax) {
    uvMin = vec2(100.0);
    uvMax = vec2(-100.0);
    if (t0.z > 0.001) { vec2 p = t0.xy / t0.z; uvMin = min(uvMin, p); uvMax = max(uvMax, p); }
    if (t1.z > 0.001) { vec2 p = t1.xy / t1.z; uvMin = min(uvMin, p); uvMax = max(uvMax, p); }
    if (t2.z > 0.001) { vec2 p = t2.xy / t2.z; uvMin = min(uvMin, p); uvMax = max(uvMax, p); }
    if (t3.z > 0.001) { vec2 p = t3.xy / t3.z; uvMin = min(uvMin, p); uvMax = max(uvMax, p); }
    if (uvMax.x < uvMin.x || uvMax.y < uvMin.y) {
        uvMin = vec2(0.0);
        uvMax = vec2(1.0);
    }
    return uvMax - uvMin;
}

bool bk_inside(vec2 uv, vec2 uvMin, vec2 uvMax) {
    return uv.x >= uvMin.x && uv.x <= uvMax.x && uv.y >= uvMin.y && uv.y <= uvMax.y;
}

void bk_applySpinEffect(inout vec2 uv, vec2 uvMin, vec2 uvSize, float scale, float flip, vec2 originalUV) {
    if (scale >= 0.99 && flip <= 0.5) return;

    float minX = 1.0;
    float maxX = 0.0;
    bool hasInk = false;
    for (float x = 0.0; x <= 1.0; x += 0.05) {
        for (float y = 0.0; y <= 1.0; y += 0.05) {
            if (bk_glyphA(uvMin + vec2(x, y) * uvSize) > 0.1) {
                if (x < minX) minX = x;
                maxX = x;
                hasInk = true;
            }
        }
    }
    float inkCenter = hasInk ? (minX + maxX) * 0.5 : 0.5;
    float currentNormX = (originalUV.x - uvMin.x) / uvSize.x;
    float sampleDist = (currentNormX - inkCenter) / max(scale, 0.0001);
    if (flip > 0.5) sampleDist = -sampleDist;
    float targetNormX = inkCenter + sampleDist;
    if (targetNormX < 0.0 || targetNormX > 1.0) discard;
    uv.x = uvMin.x + targetNormX * uvSize.x;
}

vec4 bk_outline(vec2 uv, vec4 baseCol, vec4 effectColor, vec4 params, vec2 uvMin, vec2 uvMax) {
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    vec2 px = max(params.x, 0.5) / texSize;
    float currentA = bk_inside(uv, uvMin, uvMax) ? bk_glyphA(uv) : 0.0;
    float maxA = 0.0;
    for (int i = 0; i < 8; i++) {
        float angle = float(i) * (PI / 4.0);
        vec2 sampleUV = uv + vec2(cos(angle), sin(angle)) * px;
        if (!bk_inside(sampleUV, uvMin, uvMax)) continue;
        maxA = max(maxA, bk_glyphA(sampleUV));
    }
    if (currentA < 0.1 && maxA > 0.5) return effectColor;
    if (currentA >= 0.1) return vec4(baseCol.rgb, currentA * baseCol.a);
    discard;
    return vec4(0.0);
}

vec4 bk_hatch(vec2 uv, vec4 baseCol, vec4 effectColor, vec4 params, vec2 uvMin, vec2 uvSize) {
    float currentA = bk_glyphA(uv);
    if (currentA < 0.1) discard;
    float uNorm = (uvSize.x > 0.0001) ? (uv.x - uvMin.x) / uvSize.x : 0.5;
    float vNorm = (uvSize.y > 0.0001) ? (uv.y - uvMin.y) / uvSize.y : 0.5;
    float density = max(params.z, 0.5);
    float diagPos = (uNorm + vNorm) * density - GameTime * params.y * 2.0;
    float hatchMask = 1.0 - step(0.25, fract(diagPos));
    vec3 outColor = mix(baseCol.rgb, effectColor.rgb, hatchMask);
    float outAlpha = currentA * mix(baseCol.a, max(baseCol.a, effectColor.a), hatchMask);
    return vec4(outColor, outAlpha);
}

vec4 bk_neon(vec2 uv, vec4 effectColor, vec4 params, vec2 uvMin, vec2 uvMax) {
    float currentA = bk_glyphA(uv);
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    float halo = 0.0;
    for (int i = 0; i < 8; i++) {
        float angle = float(i) * (PI / 8.0 * 2.0);
        for (float r = 1.0; r <= 3.0; r += 1.0) {
            vec2 sampleUV = uv + vec2(cos(angle), sin(angle)) * (r / texSize);
            if (!bk_inside(sampleUV, uvMin, uvMax)) continue;
            halo += bk_glyphA(sampleUV) / r;
        }
    }
    halo /= 8.0 * 3.0;
    halo *= params.x;
    float flicker = 1.0;
    if (params.y > 0.0001) {
        flicker = 0.85 + 0.15 * sin(GameTime * params.y * 5000.0)
                              * (0.5 + 0.5 * sin(GameTime * params.y * 10000.0 + 1.7));
    }
    vec3 neonColor = effectColor.rgb * flicker;
    if (currentA > 0.1) return vec4(neonColor, currentA * effectColor.a);
    if (halo > 0.05) return vec4(neonColor, halo * effectColor.a);
    discard;
    return vec4(0.0);
}

vec4 bk_split(vec2 uv, vec4 baseCol, vec4 params, vec2 uvMin, vec2 uvSize) {
    float vNorm = (uvSize.y > 0.0001) ? (uv.y - uvMin.y) / uvSize.y : 0.5;
    float shiftFactor = sin(GameTime * params.y * 3000.0) * 0.5 + 0.5;
    float shiftRatio = clamp(params.x * 0.2, 0.05, 0.6);
    float scaledU;
    if (vNorm < 0.5) {
        float subtract = (1.0 - shiftFactor) * shiftRatio * uvSize.x;
        scaledU = (uv.x - uvMin.x) * (1.0 + shiftRatio) - subtract;
        if (scaledU < 0.0 || scaledU > uvSize.x) discard;
    } else {
        scaledU = (uv.x - uvMin.x) * (1.0 + shiftRatio) - shiftRatio * uvSize.x;
        if (scaledU < 0.0) discard;
    }
    float a = bk_glyphA(vec2(uvMin.x + scaledU, uv.y));
    if (a < 0.1) discard;
    return vec4(baseCol.rgb, a * baseCol.a);
}

vec4 bk_chromatic(vec2 uv, vec4 baseCol, vec4 params, vec2 uvMin, vec2 uvMax) {
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    float anim = 1.0 + 0.4 * sin(GameTime * params.y * 1000.0);
    vec2 offset = vec2(params.x * anim / texSize.x, 0.0);
    vec2 sR = uv - offset;
    vec2 sB = uv + offset;
    float aR = bk_inside(sR, uvMin, uvMax) ? bk_glyphA(sR) : 0.0;
    float aG = bk_inside(uv, uvMin, uvMax) ? bk_glyphA(uv) : 0.0;
    float aB = bk_inside(sB, uvMin, uvMax) ? bk_glyphA(sB) : 0.0;
    float maxA = max(max(aR, aG), aB);
    if (maxA < 0.1) discard;
    vec3 color = clamp(vec3(aR + aG * baseCol.r, aG * baseCol.g, aB + aG * baseCol.b), 0.0, 1.0);
    return vec4(color, maxA * baseCol.a);
}

vec4 bk_extrude(vec2 uv, vec4 baseCol, vec4 c1, vec4 c2, vec4 c3, vec4 params, vec2 uvMin, vec2 uvMax) {
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    int layers = max(int(params.y + 0.5), 1);
    int mode = int(params.z + 0.5);
    vec2 layerStep = vec2(params.x) / texSize;
    float currentA = bk_inside(uv, uvMin, uvMax) ? bk_glyphA(uv) : 0.0;
    if (currentA > 0.1) return vec4(baseCol.rgb, currentA * baseCol.a);
    for (int i = 1; i <= 16; i++) {
        if (i > layers) break;
        vec2 sampleUV = uv - layerStep * float(i);
        if (!bk_inside(sampleUV, uvMin, uvMax)) continue;
        float a = bk_glyphA(sampleUV);
        if (a > 0.5) {
            if (mode == 2 && layers > 1) {
                float segment = float(i - 1) / float(layers - 1) * 2.0;
                if (segment < 1.0) return vec4(mix(c1.rgb, c2.rgb, segment), a * mix(c1.a, c2.a, segment));
                return vec4(mix(c2.rgb, c3.rgb, segment - 1.0), a * mix(c2.a, c3.a, segment - 1.0));
            } else if (mode == 2) {
                return vec4(c1.rgb, a * c1.a);
            } else if (mode == 1 && layers > 1) {
                float t = float(i - 1) / float(layers - 1);
                return vec4(mix(baseCol.rgb, c1.rgb, t), a * mix(baseCol.a, c1.a, t));
            } else if (mode == 1) {
                return vec4(c1.rgb, a * c1.a);
            }
            float darken = float(i) / float(layers + 1);
            return vec4(baseCol.rgb * (1.0 - darken * 0.65), a * baseCol.a);
        }
    }
    discard;
    return vec4(0.0);
}

vec4 bk_noiseFx(vec2 uv, vec4 baseCol, vec4 params, vec2 uvMin, vec2 uvMax) {
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    float t = floor(GameTime * params.y * 1500.0);
    vec2 noiseOff = vec2(
        bk_random(vec2(floor(uv.y * texSize.y) + t, 0.0)) - 0.5,
        bk_random(vec2(floor(uv.x * texSize.x) + t, 1.0)) - 0.5
    ) * params.x / texSize;
    vec2 sampleUV = uv + noiseOff;
    if (!bk_inside(sampleUV, uvMin, uvMax)) discard;
    float a = bk_glyphA(sampleUV);
    if (a < 0.1) discard;
    float bright = 0.85 + 0.3 * bk_random(vec2(t, 0.5));
    return vec4(baseCol.rgb * bright, a * baseCol.a);
}

vec4 bk_liquid(vec2 uv, vec4 baseCol, vec4 params, vec2 uvMin, vec2 uvMax) {
    vec2 texSize = vec2(textureSize(Sampler0, 0));
    float t = GameTime * params.y * 1000.0;
    vec2 displ = vec2(
        sin(uv.y * 40.0 + t) * cos(uv.x * 25.0 - t * 0.7),
        cos(uv.x * 40.0 - t) * sin(uv.y * 25.0 + t * 0.7)
    ) * params.x / texSize;
    vec2 sampleUV = uv + displ;
    if (!bk_inside(sampleUV, uvMin, uvMax)) discard;
    float a = bk_glyphA(sampleUV);
    if (a < 0.1) discard;
    return vec4(baseCol.rgb, a * baseCol.a);
}

vec4 bk_water(vec2 uv, vec4 baseCol, vec4 effectColor, vec4 params, vec2 uvMin, vec2 uvSize) {
    float currentA = bk_glyphA(uv);
    if (currentA < 0.1) discard;
    float uNorm = (uvSize.x > 0.0001) ? (uv.x - uvMin.x) / uvSize.x : 0.5;
    float vNorm = (uvSize.y > 0.0001) ? (uv.y - uvMin.y) / uvSize.y : 0.5;
    float level = clamp(params.x, 0.0, 1.0);
    float freq = max(params.w, 0.5);
    float t = GameTime * params.z * 12000.0;
    float wave = sin(uNorm * 6.2831853 * freq + t) * 0.6
               + sin(uNorm * 6.2831853 * freq * 2.0 + t * 1.3) * 0.4;
    wave *= params.y * 0.08;
    float waterLine = (1.0 - level) + wave;
    if (vNorm < waterLine) return vec4(baseCol.rgb, currentA * baseCol.a);
    float depth = (1.0 - waterLine > 0.0001) ? (vNorm - waterLine) / (1.0 - waterLine) : 0.5;
    depth = clamp(depth, 0.0, 1.0);
    vec3 lightWater = effectColor.rgb;
    vec3 deepWater = effectColor.rgb * 0.45;
    vec3 waterCol = mix(lightWater, deepWater, depth);
    float surfaceGlow = smoothstep(0.0, 0.05, depth) * (1.0 - smoothstep(0.0, 0.10, depth));
    waterCol = mix(waterCol, mix(lightWater, vec3(1.0), 0.5), surfaceGlow * 0.4);
    return vec4(waterCol, currentA * effectColor.a);
}

bool applyBlocklyFragment() {
    if (vctfx_applyTextEffect < 1.5) return false;

    // dane z vertex shadera (patrz Phase 8)
    int effectID = int(vctfx_ipos4.x + 0.5);
    float spinFlip = vctfx_ipos4.y;
    float spinScale = vctfx_ipos4.z;
    float displayAlpha = vctfx_ipos3.z;
    vec4 effBase = baseColor;
    vec4 effColor = lightColor;
    vec4 params = vctfx_screenPos;

    vec2 uvMin, uvMax;
    vec2 uvSize = bk_calculateUVBounds(vctfx_uvpos1, vctfx_uvpos2, vctfx_uvpos3, vctfx_uvpos4, uvMin, uvMax);

    vec2 uv = texCoord0;
    bk_applySpinEffect(uv, uvMin, uvSize, spinScale, spinFlip, texCoord0);

    vec4 result;
    if (effectID == 1) {
        result = bk_outline(uv, effBase, effColor, params, uvMin, uvMax);
    } else if (effectID == 2) {
        result = bk_hatch(uv, effBase, effColor, params, uvMin, uvSize);
    } else if (effectID == 3) {
        result = bk_neon(uv, effColor, params, uvMin, uvMax);
    } else if (effectID == 5) {
        result = bk_split(uv, effBase, params, uvMin, uvSize);
    } else if (effectID == 6) {
        result = bk_chromatic(uv, effBase, params, uvMin, uvMax);
    } else if (effectID == 7) {
        result = bk_extrude(uv, effBase, effColor, vec4(vctfx_ipos1, vctfx_ipos3.x), vec4(vctfx_ipos2, vctfx_ipos3.y), params, uvMin, uvMax);
    } else if (effectID == 8) {
        result = bk_noiseFx(uv, effBase, params, uvMin, uvMax);
    } else if (effectID == 9) {
        result = bk_liquid(uv, effBase, params, uvMin, uvMax);
    } else if (effectID == 10) {
        result = bk_water(uv, effBase, effColor, params, uvMin, uvSize);
    } else {
        // efekty wierzcholkowe: zwykle rysowanie litery z kolorem z VSH
        vec4 color = fx_glyph(uv) * vertexColor * ColorModulator;
        if (color.a < 0.1) discard;
        fragColor = fx_applyFog(color);
        return true;
    }
    result.a *= displayAlpha;
    fragColor = result;
    return true;
}

#endif // FSH
