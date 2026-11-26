#if defined(RENDERTYPE_TEXT) || defined(RENDERTYPE_TEXT_INTENSITY) || defined(IS_GRAYSCALE)

struct TextData {
    vec4 color;
    vec4 topColor;
    vec4 backColor;
    vec2 position;
    vec2 characterPosition;
    vec2 localPosition;
    vec2 uv;
    vec2 uvMin;
    vec2 uvMax;
    vec2 uvCenter;
    bool isShadow;
    bool doTextureLookup;
    bool shouldScale;
    vec2 px; // UV size of one font pixel (1/256 for the vanilla font, smaller for HD / TTF fonts)
};

TextData textData;

// Glyph lookup that works for every font type:
//  - bitmap fonts (rendertype_text)            -> RGBA atlas
//  - TTF / unifont (rendertype_text_intensity) -> R8 atlas, coverage in .r
vec4 fx_glyph(vec2 uv) {
#if defined(RENDERTYPE_TEXT_INTENSITY) || defined(IS_GRAYSCALE)
    return texture(Sampler0, uv).rrrr;
#else
    return texture(Sampler0, uv);
#endif
}

const float _gamma = 0.43;

bool uvBoundsCheck(vec2 uv, vec2 uvMin, vec2 uvMax) {
    if(isnan(uv.x) || isnan(uv.y)) return true;
    const float error = 0.0001;
    return uv.x < textData.uvMin.x + error || uv.y < textData.uvMin.y + error || uv.x > textData.uvMax.x - error || uv.y > textData.uvMax.y - error;
}

float time() {
  return GameTime * 1200.;
}

vec3 textSdf() {
    vec3 value = vec3(0.0, 0.0, 1.0);

    vec2 texelSize = textData.px;
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 uv = textData.uv + vec2(x, y) * texelSize;
            if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) continue;

            vec4 s = fx_glyph(uv);
            if(s.a >= 0.1) {
                vec3 v = vec3(fract((uv - textData.uvMin) / textData.px), 0.0);

                if(x == 0) v.x = 0.0;
                if(y == 0) v.y = 0.0;
                if(x > 0) v.x = 1.0-v.x;
                if(y > 0) v.y = 1.0-v.y;

                v.z = length(v.xy);

                if(v.z < value.z) value = v;
            }
        }
    }
    return value;
}

void override_text_color(vec4 color) {
    textData.color = color;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void override_text_color(vec3 color) {
    textData.color.rgb = color;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void override_shadow_color(vec4 color) {
    if(textData.isShadow) {
        textData.color = color;
        textData.topColor.rgb = color.rgb;
        textData.topColor.a *= color.a;
        textData.backColor.rgb = color.rgb;
        textData.backColor.a *= color.a;
    }
}

void override_shadow_color(vec3 color) {
    override_shadow_color(vec4(color, 1.0));
}

void remove_text_shadow() {
    if(textData.isShadow) textData.color.a = 0.0;
}

void apply_lesbian_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(0.839, 0.161, 0.000);
    if(y == 3) textData.color.rgb = vec3(1.000, 0.608, 0.333);
    if(y == 4) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y == 5) textData.color.rgb = vec3(0.831, 0.384, 0.647);
    if(y >  5) textData.color.rgb = vec3(0.647, 0.000, 0.384);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_mlm_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(0.000, 0.584, 0.525);
    if(y == 3) textData.color.rgb = vec3(0.412, 0.941, 0.686);
    if(y == 4) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y == 5) textData.color.rgb = vec3(0.510, 0.698, 1.000);
    if(y >  5) textData.color.rgb = vec3(0.271, 0.153, 0.627);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_bisexual_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  4) textData.color.rgb = vec3(0.843, 0.000, 0.443);
    if(y == 4) textData.color.rgb = vec3(0.612, 0.306, 0.592);
    if(y >  4) textData.color.rgb = vec3(0.000, 0.208, 0.663);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_transgender_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(0.357, 0.812, 0.980);
    if(y == 3) textData.color.rgb = vec3(0.961, 0.671, 0.725);
    if(y == 4) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y == 5) textData.color.rgb = vec3(0.961, 0.671, 0.725);
    if(y >  5) textData.color.rgb = vec3(0.357, 0.812, 0.980);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  2) textData.color.rgb = vec3(1.000, 0.012, 0.012);
    if(y == 2) textData.color.rgb = vec3(1.000, 0.549, 0.000);
    if(y == 3) textData.color.rgb = vec3(1.000, 0.929, 0.000);
    if(y == 4) textData.color.rgb = vec3(0.000, 0.502, 0.149);
    if(y == 5) textData.color.rgb = vec3(0.000, 0.302, 1.000);
    if(y >  5) textData.color.rgb = vec3(0.459, 0.027, 0.529);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_pansexual_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(1.000, 0.129, 0.549);
    if(y == 3) textData.color.rgb = vec3(1.000, 0.847, 0.000);
    if(y == 4) textData.color.rgb = vec3(1.000, 0.847, 0.000);
    if(y >  4) textData.color.rgb = vec3(0.129, 0.694, 1.000);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_asexual_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(0.100, 0.100, 0.100);
    if(y == 3) textData.color.rgb = vec3(0.639, 0.639, 0.639);
    if(y == 4) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y >  4) textData.color.rgb = vec3(0.502, 0.000, 0.502);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_aromantic_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(0.047, 0.655, 0.294);
    if(y == 3) textData.color.rgb = vec3(0.584, 0.796, 0.451);
    if(y == 4) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y == 5) textData.color.rgb = vec3(0.639, 0.639, 0.639);
    if(y >  5) textData.color.rgb = vec3(0.100, 0.100, 0.100);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_non_binary_pride() {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));

    if(y <  3) textData.color.rgb = vec3(1.000, 0.957, 0.173);
    if(y == 3) textData.color.rgb = vec3(1.000, 1.000, 1.000);
    if(y == 4) textData.color.rgb = vec3(0.616, 0.349, 0.824);
    if(y >  4) textData.color.rgb = vec3(0.100, 0.100, 0.100);

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_vertical_shadow() {
    if(textData.isShadow) {
        textData.uv.x += textData.px.x;
        textData.shouldScale = true;
    }
}

void apply_waving_movement(float speed, float frequency) {
    textData.uv.y += sin(textData.characterPosition.x * 0.1 * frequency - GameTime * 7500.0 * speed) * textData.px.y;
    textData.shouldScale = true;
}

void apply_waving_movement(float speed) {
    apply_waving_movement(speed, 1.0);
}

void apply_waving_movement() {
    apply_waving_movement(1.0, 1.0);
}

void apply_shaking_movement() {
    float noiseX = noise(textData.characterPosition.x + textData.characterPosition.y + GameTime * 32000.0) - 0.5;
    float noiseY = noise(textData.characterPosition.x - textData.characterPosition.y + GameTime * 32000.0) - 0.5;
    textData.shouldScale = true;

    textData.uv += vec2(noiseX, noiseY) * textData.px;
}

void apply_iterating_movement(float speed, float space) {
    float x = mod(textData.characterPosition.x * 0.4 - GameTime * 18000.0 * speed, (5.0 * space) * TAU);
    if(x > TAU) x = TAU;
    textData.uv.y += (-cos(x) * 0.5 + 0.5) * textData.px.y;
    textData.shouldScale = true;
}

void apply_iterating_movement() {
    apply_iterating_movement(1.0, 1.0);
}

void apply_flipping_movement(float speed, float space) {
    float t = mod((textData.characterPosition.x * 0.4 - GameTime  * 18000.0 * speed) / TAU, 5.0 * space);
    textData.uv.x = textData.uvCenter.x + (textData.uv.x - textData.uvCenter.x) / (cos(TAU * min(t, 1.0)));
    textData.uv.y = textData.uvCenter.y + (textData.uv.y - textData.uvCenter.y) / (1.0 + 0.1 * sin(TAU * min(t, 1.0)));
    textData.shouldScale = true;
}

void apply_flipping_movement() {
    apply_flipping_movement(1.0, 1.0);
}

void apply_skewing_movement(float speed) {
    float t = GameTime * 1600.0 * speed;

    textData.uv.x = mix(textData.uv.x, textData.uv.x + sin(TAU * t * 0.5) * 0.5 * textData.px.x, 1.0 - textData.localPosition.y);
    textData.uv.y = mix(textData.uv.y, textData.uvMax.y, -(0.05 * cos(TAU * t)));
    textData.shouldScale = true;
}

void apply_skewing_movement() { 
    apply_skewing_movement(1.0);
}

// Convert sRGB to linear space (simplified version)
vec3 toLinear(vec3 srgb) {
    return pow(srgb, vec3(2.2));
}

vec3 fromLinear(vec3 linearRGB) {
  bvec3 cutoff = lessThan(linearRGB, vec3(0.0031308));
  vec3 higher = vec3(1.055) * pow(linearRGB, vec3(1.0 / 2.4)) - vec3(0.055);
  vec3 lower = linearRGB * vec3(12.92);

  return mix(higher, lower, cutoff);
}

vec3 markMix(vec3 color1, vec3 color2, float x) {
  vec3 outColor = mix(color1, color2, x);

  float brightness1 = pow(color1.r + color1.g + color1.b, _gamma);
  float brightness2 = pow(color2.r + color2.g + color2.b, _gamma);

  float brightness = mix(brightness1, brightness2, x);
  float intensity = pow(brightness, 1.0 / _gamma);

  float factor = intensity / (outColor.r + outColor.g + outColor.b);

  return fromLinear(outColor * factor);
}

void apply_purple_to_green_gradient() {
    int stops = 2;
    vec3 colors[2] = vec3[](
        vec3(0.682, 0.0, 0.859),
        vec3(0, 0.859, 0.584)
    );
    
    // Center UV coordinates
    vec2 uv = textData.uvCenter;
    
    // Create rotating effect
    float angle = atan(uv.y, uv.x);
    float len = length(uv);
    uv = vec2(cos(angle) * len, sin(angle) * len);
    
    // Animate gradient
    float n_pos = textData.characterPosition.x / 400; // Scale with half width
    float n_time = time() * -0.5;
    float n = fract(n_pos + n_time) * float(stops);
    
    // Color interpolation
    int first = int(floor(n));
    vec3 color1 = toLinear(colors[first]);
    vec3 color2 = toLinear(colors[(first + 1) % stops]);
    
    // Mix colors with smooth transition
    vec3 gradColor = markMix(color1, color2, smoothstep(0.0, 1.0, fract(n)));
    
    // Apply to existing color
    textData.color.rgb = gradColor;

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_lucky_gradient() {
    int stops = 3;
    vec3 colors[3] = vec3[](
        vec3(0.125, 0.941, 0.039), // Green
        vec3(0.396, 0.851, 0.514), // Light Green
        vec3(0.961, 0.957, 0.204) // Yellow
    );
    
    // Center UV coordinates
    vec2 uv = textData.uvCenter;
    
    // Create rotating effect
    float angle = atan(uv.y, uv.x);
    float len = length(uv);
    uv = vec2(cos(angle) * len, sin(angle) * len);
    
    // Animate gradient
    float n_pos = textData.characterPosition.x / 400; // Scale with half width
    float n_time = time() * -0.5;
    float n = fract(n_pos + n_time) * float(stops);
    
    // Color interpolation
    int first = int(floor(n));
    vec3 color1 = toLinear(colors[first]);
    vec3 color2 = toLinear(colors[(first + 1) % stops]);
    
    // Mix colors with smooth transition
    vec3 gradColor = markMix(color1, color2, smoothstep(0.0, 1.0, fract(n)));
    
    // Apply to existing color
    textData.color.rgb = gradColor;

    if(textData.isShadow) textData.color.rgb *= 0.25;
}


void apply_blue_gradient() {
    int stops = 3;
    vec3 colors[3] = vec3[](
        vec3(0.0, 1.0, 1.0),                // Cyan
        vec3(0.357, 0.749, 1.0),              // Dark blue
        vec3(1, 1, 1)
    );
    
    // Center UV coordinates
    vec2 uv = textData.uvCenter;
    
    // Create rotating effect
    float angle = atan(uv.y, uv.x);
    float len = length(uv);
    uv = vec2(cos(angle) * len, sin(angle) * len);
    
    // Animate gradient
    float n_pos = textData.characterPosition.x / 400; // Scale with half width
    float n_time = time() * -0.5;
    float n = fract(n_pos + n_time) * float(stops);
    
    // Color interpolation
    int first = int(floor(n));
    vec3 color1 = toLinear(colors[first]);
    vec3 color2 = toLinear(colors[(first + 1) % stops]);
    
    // Mix colors with smooth transition
    vec3 gradColor = markMix(color1, color2, smoothstep(0.0, 1.0, fract(n)));
    
    // Apply to existing color
    textData.color.rgb = gradColor;

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_growing_movement(float speed) {
    vec2 offset = vec2(0.0, 5.0) * textData.px;
    textData.uv = (textData.uv - textData.uvCenter - offset) * (sin(GameTime * 12800.0 * speed) * 0.15 + 0.85) + textData.uvCenter + offset;
    textData.shouldScale = true;
}

void apply_growing_movement() {
    apply_growing_movement(1.0);
}

void apply_outline(vec3 color) {
    textData.shouldScale = true;

    if(textData.isShadow) {
        color *= 0.25;
        textData.color.rgb = color;
    } 

    vec2 texelSize = textData.px;
    bool outline = false;

    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            if(x == 0 && y == 0) continue;

            vec2 uv = textData.uv + vec2(x, y) * texelSize;
            if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) continue;

            vec4 s = fx_glyph(uv);
            if(s.a >= 0.1) { textData.backColor = vec4(color, 1.0); return; }
        }
    }
}

void apply_thin_outline(vec3 color) {
    textData.shouldScale = true;

    if(textData.isShadow) {
        color *= 0.25;
        textData.color.rgb = color;
    } 
    
    vec2 texelSize = 0.5 * textData.px;
    bool outline = false;

    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            if(x == 0 && y == 0) continue;

            vec2 uv = textData.uv + vec2(x, y) * texelSize;
            if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) continue;

            vec4 s = fx_glyph(uv);
            if(s.a >= 0.1) { textData.backColor = vec4(color, 1.0); return; }
        }
    }
}


void apply_gradient(vec3 color1, vec3 color2) {
    textData.color.rgb = mix(color1, color2, (textData.uv.y - textData.uvMin.y) / (textData.uvMax.y - textData.uvMin.y));
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_rainbow() {
    textData.color.rgb = hsvToRgb(vec3(0.005 * (textData.position.x + textData.position.y) - GameTime * 300.0, 0.7, 1.0));
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_shimmer(float speed, float intensity) {
    if(textData.isShadow) return;
    float f = textData.localPosition.x + textData.localPosition.y - GameTime * 6400.0 * speed;
    
    if(mod(f, 15) < 0.7) textData.topColor = vec4(1.0, 1.0, 1.0, intensity);
}

void apply_shimmer(){
    apply_shimmer(0.9, 0.5);
}

void apply_sweep_shine(float speed, float width, float intensity) {
    if(textData.isShadow) return;
    // จากขวาบน (1, 0) มาซ้ายล่าง (0, 1)
    float pos = (1.0 - textData.localPosition.x) + textData.localPosition.y;
    float t = mod(pos + GameTime * 2000.0 * speed, 2.0);
    float shine = 0.0;
    if(t < width) {
        shine = smoothstep(0.0, width, t);
    } else if(t < width * 2.0) {
        shine = smoothstep(width * 2.0, width, t);
    }
    textData.topColor = vec4(1.0, 1.0, 1.0, shine * intensity);
}

void apply_sweep_shine() {
    apply_sweep_shine(1.0, 0.4, 1.0);
}

void apply_chromatic_abberation() {
    textData.shouldScale = true;
    float noiseX = noise(GameTime * 12000.0) - 0.5;
    float noiseY = noise(GameTime * 12000.0 + 19732.134) - 0.5;
    vec2 offset = (vec2(0.5, 0.0) + vec2(0.5, 1.0) * vec2(noiseX, noiseY)) * textData.px;

    vec2 uv = textData.uv + offset;
    vec4 s1 = fx_glyph(uv);
    s1.rgb *= s1.a;
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) s1 = vec4(0.0);

    uv = textData.uv - offset;
    vec4 s2 = fx_glyph(uv);
    s2.rgb *= s2.a;
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) s2 = vec4(0.0);

    textData.backColor = (s1 * vec4(1.0, 0.25, 0.0, 1.0)) + (s2 * vec4(0.0, 0.75, 1.0, 1.0));
    textData.backColor.rgb *= textData.color.rgb;
}

void apply_metalic(vec3 lightColor, vec3 darkColor) {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));
    
    if(y > 3) textData.color.rgb = darkColor;
    if(y == 3) textData.color.rgb = lightColor + 0.25;
    if(y < 3) textData.color.rgb = lightColor;

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_metalic(vec3 color) {
    int y = int(floor((textData.uv.y - textData.uvMin.y) / textData.px.y));
    
    if(y > 3) textData.color.rgb = color * 0.7;
    if(y == 3) textData.color.rgb = color + 0.25;
    if(y < 3) textData.color.rgb = color;

    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_fire() {
    textData.shouldScale = true;
    if(textData.isShadow) return;

    float h = fract((textData.uv.y - textData.uvMin.y) / textData.px.y);
    vec2 uv = textData.uv + vec2(0.0, textData.px.y);
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) return;
    vec4 s = fx_glyph(uv);
    if(s.a > 0.1) {
        float f = noise(textData.localPosition * 32.0 + vec2(0.0, GameTime * 6400.0)) * 0.5 + 0.5;
        f -= (1.0 - sqrt(h)) * 0.8;

        if(f > 0.5)
        textData.backColor = vec4(mix(vec3(1.0, 0.2, 0.2), vec3(1.0, 0.7, 0.3), (f - 0.5) / 0.5), 1.0);
    }
}

void apply_water() {
    textData.shouldScale = true;
    if(textData.isShadow) return;

    float h = fract((textData.uv.y - textData.uvMin.y) / textData.px.y);
    vec2 uv = textData.uv + vec2(0.0, textData.px.y);
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) return;
    vec4 s = fx_glyph(uv);
    if(s.a > 0.1) {
        // Water-like flowing effect (slower and wavy)
        float wave1 = noise(textData.localPosition * 24.0 + vec2(GameTime * 2000.0, GameTime * 3000.0));
        float wave2 = noise(textData.localPosition * 16.0 - vec2(GameTime * 1500.0, GameTime * 2500.0));
        float f = (wave1 + wave2) * 0.5;
        f -= (1.0 - sqrt(h)) * 0.7;

        if(f > 0.4) {
            // Blue/cyan water colors
            vec3 darkWater = vec3(0.1, 0.3, 0.8);   // Dark blue
            vec3 lightWater = vec3(0.3, 0.7, 1.0);  // Light cyan
            textData.backColor = vec4(mix(darkWater, lightWater, (f - 0.4) / 0.6), 1.0);
        }
    }
}

void apply_alien() {
    textData.shouldScale = true;
    if(textData.isShadow) return;

    float h = fract((textData.uv.y - textData.uvMin.y) / textData.px.y);
    vec2 uv = textData.uv + vec2(0.0, textData.px.y);
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) return;
    vec4 s = fx_glyph(uv);
    if(s.a > 0.1) {
        // Alien ooze/slime effect with pulsing glow
        float time = GameTime * 3500.0;
        vec2 alienPos = textData.localPosition * 35.0;
        
        // Create bubbling/oozing motion
        float ooze1 = noise(alienPos + vec2(time * 0.5, time * 0.3));
        float ooze2 = noise(alienPos * 1.3 - vec2(time * 0.4, time * 0.6));
        float bubble = sin(time * 2.0 + alienPos.x * 8.0 + alienPos.y * 6.0) * 0.5 + 0.5;
        
        float f = (ooze1 + ooze2 * 0.7 + bubble * 0.4) / 2.1;
        f -= (1.0 - sqrt(h)) * 0.7;

        if(f > 0.35) {
            // Glowing alien green colors
            vec3 darkAlien = vec3(0.0, 0.4, 0.1);       // Dark toxic green
            vec3 brightAlien = vec3(0.2, 1.0, 0.3);     // Bright glowing green
            vec3 neonAlien = vec3(0.5, 1.0, 0.5);       // Neon highlight
            
            float colorMix = (f - 0.35) / 0.65;
            vec3 alienColor;
            
            if(colorMix < 0.5) {
                alienColor = mix(darkAlien, brightAlien, colorMix * 2.0);
            } else {
                alienColor = mix(brightAlien, neonAlien, (colorMix - 0.5) * 2.0);
            }
            
            // Add pulsing glow effect
            float pulse = sin(time * 1.5) * 0.15 + 0.85;
            alienColor *= pulse;
            
            textData.backColor = vec4(alienColor, 1.0);
        }
    }
}

void apply_valentine() {
    textData.shouldScale = true;
    if(textData.isShadow) return;

    float h = fract((textData.uv.y - textData.uvMin.y) / textData.px.y);
    vec2 uv = textData.uv + vec2(0.0, textData.px.y);
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) return;
    vec4 s = fx_glyph(uv);
    if(s.a > 0.1) {
        float time = GameTime * 1000.0;
        vec2 pos = textData.localPosition * 18.0;
        
        // หัวใจลอยขึ้น
        pos.y += time;
        pos.x += sin(time * 0.3 + pos.y * 0.1) * 2.0;
        
        // แบ่งเป็นหัวใจแต่ละดวง
        vec2 cellId = floor(pos / 5.0);
        vec2 p = (fract(pos / 5.0) - 0.5) * 4.0;
        
        // กลับให้ปลายแหลมชี้ลง แต่เลื่อนขึ้นเพื่อตัดส่วนล่าง
        p.y = -p.y + 0.5;
        
        // สร้างหัวใจด้วยสมการเดิม แต่ปรับให้สั้นลง
        float x = p.x;
        float y = p.y;
        
        // ส่วนบนของหัวใจ (2 วงกลม)
        float a = x * x + (y - abs(x) * 0.5) * (y - abs(x) * 0.5);
        
        // ปรับให้รูปทรงสมบูรณ์
        float heartDist = a - 1.0;
        
        // ตัดส่วนล่างที่แหลมเกินไป
        float cutBottom = smoothstep(-1.2, -1.0, y);
        
        float heartShape = smoothstep(0.2, -0.2, heartDist) * cutBottom;
        
        float f = heartShape;
        
        // Fade ที่ขอบจอ
        f *= smoothstep(0.0, 0.2, h) * smoothstep(1.0, 0.8, h);

        if(f > 0.15) {
            // สีหัวใจ
            float seed = noise(cellId);
            vec3 color;
            
            if(seed < 0.5) {
                color = vec3(1.0, 0.1, 0.35); // แดงสด
            } else {
                color = vec3(1.0, 0.45, 0.65); // ชมพู
            }
            
            // ไล่โทนสี
            color = mix(color * 0.8, color, f);
            
            textData.backColor = vec4(color, f * 1.1);
        }
    }
}

void apply_fade(float speed) {
    textData.color.a = mix(textData.color.a, 0.0, sin(GameTime * 1200 * speed * PI) * 0.5 + 0.5);
}

void apply_fade() {
    apply_fade(1.0);
}

void apply_fade(vec3 color, float speed) {
    if(textData.isShadow) color *= 0.25;

    textData.color.rgb = mix(textData.color.rgb, color, sin(GameTime * 1200 * speed * PI) * 0.5 + 0.5);
}

void apply_fade(vec3 color) {
    apply_fade(color, 1.0);
}

void apply_blinking(float speed){
    if(sin(GameTime * 3200 * speed * PI) < 0.0) { textData.color.a = 0.0; textData.backColor.a = 0.0; textData.topColor.a = 0.0; }
}

void apply_halloween_pumpkin() {
    textData.shouldScale = true;
    if(textData.isShadow) return;

    float h = fract((textData.uv.y - textData.uvMin.y) / textData.px.y);
    vec2 uv = textData.uv + vec2(0.0, textData.px.y);
    if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) return;
    vec4 s = fx_glyph(uv);
    if(s.a > 0.1) {
        float time = GameTime * 2200.0;
        vec2 pumpkinPos = textData.localPosition * 30.0;
        
        // Floating pumpkins
        pumpkinPos.y += time;
        pumpkinPos.x += sin(time * 0.4 + pumpkinPos.y * 0.25) * 1.2;
        
        vec2 cell = floor(pumpkinPos / 9.0);
        vec2 local = fract(pumpkinPos / 9.0) - 0.5;
        
        // Pumpkin body (oval shape)
        vec2 p = local * 3.0;
        float pumpkinBody = length(p * vec2(1.0, 1.3)) - 0.6;
        float pumpkin = smoothstep(0.08, -0.02, pumpkinBody);
        
        // Jack-o'-lantern face (eyes and mouth)
        // Eyes (triangles)
        float leftEye = max(abs(p.x + 0.2) * 1.5 - (p.y - 0.1) - 0.15, (p.y - 0.1) + 0.2);
        float rightEye = max(abs(p.x - 0.2) * 1.5 - (p.y - 0.1) - 0.15, (p.y - 0.1) + 0.2);
        leftEye = smoothstep(0.02, -0.02, leftEye);
        rightEye = smoothstep(0.02, -0.02, rightEye);
        
        // Mouth (zigzag smile)
        float mouthY = -0.15;
        float mouthCurve = sin((p.x) * 10.0) * 0.08;
        float mouth = smoothstep(0.05, -0.02, abs(p.y - (mouthY + mouthCurve)) - 0.03) * 
                     step(abs(p.x), 0.35);
        
        // Cut out face from pumpkin
        float face = max(max(leftEye, rightEye), mouth);
        pumpkin *= (1.0 - face);
        
        float f = pumpkin;
        
        // Remove from edges
        float edgeFade = smoothstep(0.0, 0.25, h) * smoothstep(1.0, 0.75, h);
        f *= edgeFade;
        
        f -= (1.0 - sqrt(h)) * 0.4;

        if(f > 0.25) {
            // Orange pumpkin colors with inner glow
            float glowPulse = sin(time * 2.0 + noise(cell) * 6.0) * 0.15 + 0.85;
            vec3 darkOrange = vec3(0.9, 0.4, 0.1);
            vec3 brightOrange = vec3(1.0, 0.7, 0.2);
            vec3 glowOrange = vec3(1.0, 0.9, 0.4);
            
            float colorMix = (f - 0.25) / 0.75;
            vec3 pumpkinColor;
            if(colorMix < 0.5) {
                pumpkinColor = mix(darkOrange, brightOrange, colorMix * 2.0);
            } else {
                pumpkinColor = mix(brightOrange, glowOrange, (colorMix - 0.5) * 2.0);
            }
            
            pumpkinColor *= glowPulse;
            
            // Add face glow
            if(face > 0.1) {
                pumpkinColor = mix(pumpkinColor, glowOrange * 1.5, face * glowPulse);
            }
            
            textData.backColor = vec4(pumpkinColor, f * 1.1);
        }
    }
}

void apply_blinking() {
    apply_blinking(1.0);
}

void apply_glowing() {
    if(textData.isShadow) textData.color = vec4(0.0);
    vec3 d = textSdf();
    textData.backColor = vec4(1.0, 1.0, 1.0, (1.0 - d.z) * (1.0 - d.z));
}

void apply_pulse(float speed) {
    float t = sin(GameTime * 2400.0 * speed) * 0.5 + 0.5;
    float scale = 0.92 + 0.08 * t;
    textData.uv = (textData.uv - textData.uvCenter) * scale + textData.uvCenter;
    textData.shouldScale = true;
}

void apply_pulse() {
    apply_pulse(1.0);
}

void apply_glitch(float speed) {
    float n = noise(textData.characterPosition * 0.5 + GameTime * 8000.0 * speed);
    float n2 = noise(textData.characterPosition * 0.3 + GameTime * 12000.0 * speed + 7.3);
    vec2 offset = vec2((n - 0.5) * 2.0, (n2 - 0.5) * 2.0) * textData.px;
    textData.uv += offset;
    if(n > 0.9) textData.color.rgb = vec3(1.0, 0.0, 1.0);
    else if(n < 0.1) textData.color.rgb = vec3(0.0, 1.0, 1.0);
    textData.shouldScale = true;
}

void apply_glitch() {
    apply_glitch(1.0);
}

void apply_neon_glow_pulse(float speed) {
    vec3 baseColor = textData.color.rgb;
    if(textData.isShadow) textData.color = vec4(0.0);
    vec3 d = textSdf();
    float pulse = sin(GameTime * 3000.0 * speed) * 0.5 + 0.5;
    float glow = (1.0 - d.z) * (1.0 - d.z) * (0.6 + 0.4 * pulse);
    textData.backColor = vec4(baseColor, glow);
    textData.shouldScale = true;
}

void apply_neon_glow_pulse() {
    apply_neon_glow_pulse(1.0);
}

void apply_rpg_damage(float speed) {
    float n = noise(textData.characterPosition * 0.3 + GameTime * 6000.0 * speed);
    textData.uv.y += (n - 0.5) * 2.0 * textData.px.y;
    textData.uv.x += sin(GameTime * 8000.0 * speed) * 0.5 * textData.px.x;
    textData.shouldScale = true;
}

void apply_rpg_damage() {
    apply_rpg_damage(1.0);
}

void apply_aurora() {
    float t = 0.03 * (textData.position.x + textData.position.y) - GameTime * 400.0;
    vec3 c1 = rgb(0, 255, 200);
    vec3 c2 = rgb(100, 200, 255);
    vec3 c3 = rgb(150, 100, 255);
    float phase = fract(t) * 3.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(c1, c2, phase);
    else if(phase < 2.0) resultColor = mix(c2, c3, phase - 1.0);
    else resultColor = mix(c3, c1, phase - 2.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_terminal(float speed) {
    override_text_color(rgb(0, 255, 100));
    float n = noise(textData.localPosition * 50.0 + GameTime * 3000.0 * speed);
    if(n > 0.97) textData.topColor = vec4(0.0, 1.0, 0.4, 0.8);
    textData.shouldScale = true;
}

void apply_terminal() {
    apply_terminal(1.0);
}

void apply_loot_rare() {
    float t = 0.02 * (textData.position.x + textData.position.y) - GameTime * 600.0;
    vec3 gold = rgb(255, 215, 0);
    vec3 purple = rgb(180, 100, 255);
    textData.color.rgb = mix(gold, purple, sin(t) * 0.5 + 0.5);
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    float n = noise(textData.localPosition * 60.0 + GameTime * 4000.0);
    if(n > 0.9) textData.topColor = vec4(1.0, 1.0, 0.8, (n - 0.9) * 10.0);
}

void apply_electric(float speed) {
    float n = noise(textData.characterPosition * 0.5 + GameTime * 10000.0 * speed);
    vec3 blue = rgb(100, 200, 255);
    vec3 yellow = rgb(255, 255, 100);
    textData.color.rgb = mix(blue, yellow, step(0.5, n));
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    if(n > 0.92) textData.topColor = vec4(1.0, 1.0, 1.0, 0.9);
    textData.shouldScale = true;
}

void apply_electric() {
    apply_electric(1.0);
}

void apply_rotate(float speed) {
    float angle = sin(textData.characterPosition.x * 0.2 + GameTime * 4000.0 * speed) * 0.3;
    vec2 offset = textData.uv - textData.uvCenter;
    textData.uv = textData.uvCenter + rotateUv(offset, angle);
    textData.shouldScale = true;
}

void apply_rotate() {
    apply_rotate(1.0);
}

void apply_zigzag(float speed) {
    float wave = sin(textData.characterPosition.x * 0.15 + GameTime * 5000.0 * speed) * 3.0 * textData.px.y;
    textData.uv.y += wave;
    textData.shouldScale = true;
}

void apply_zigzag() {
    apply_zigzag(1.0);
}

void apply_outline_wave(float speed) {
    textData.shouldScale = true;
    float t = sin(GameTime * 3000.0 * speed) * 0.5 + 0.5;
    vec3 color1 = rgb(255, 100, 255);
    vec3 color2 = rgb(100, 200, 255);
    vec3 waveColor = mix(color1, color2, t);
    if(textData.isShadow) {
        waveColor *= 0.25;
        textData.color.rgb = waveColor;
    }
    vec2 texelSize = textData.px;
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            if(x == 0 && y == 0) continue;
            vec2 uv = textData.uv + vec2(x, y) * texelSize;
            if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) continue;
            vec4 s = fx_glyph(uv);
            if(s.a >= 0.1) { textData.backColor = vec4(waveColor, 1.0); return; }
        }
    }
}

void apply_outline_wave() {
    apply_outline_wave(1.0);
}

void apply_cooldown(float speed) {
    float t = fract(GameTime * 800.0 * speed);
    float fade = 1.0 - t;
    textData.color.rgb *= fade;
    textData.color.a *= fade;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_cooldown() {
    apply_cooldown(1.0);
}

void apply_poison(float speed) {
    vec3 poison = rgb(100, 255, 100);
    textData.color.rgb = poison;
    if(sin(GameTime * 2500.0 * speed * PI) < 0.0) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_poison() {
    apply_poison(1.0);
}

void apply_boss_warning(float speed) {
    vec3 red = rgb(255, 80, 80);
    textData.color.rgb = red;
    float t = sin(GameTime * 800.0 * speed * PI) * 0.5 + 0.5;
    textData.color.rgb *= (0.5 + 0.5 * t);
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_boss_warning() {
    apply_boss_warning(1.0);
}

void apply_bounce(float speed) {
    // cycle_length to długość całego cyklu (podskok + lądowanie + przerwa).
    float cycle_length = 20.0;

    float t = mod(textData.characterPosition.x * 0.2 - GameTime * 6500.0 * speed, cycle_length);

    float bounce = 0.0;

    float mainDur = 3.14159; // czas trwania głównego podskoku w górę
    float landDur = 2.2;     // czas trwania lądowania (pod -> nad -> na miejscu)

    if (t < mainDur) {
        // Główny podskok w górę
        bounce = sin(t) * 5.0;
    }
    else if (t < mainDur + landDur) {
        // Lądowanie: znaczek najpierw zapada się POD swoje miejsce,
        // potem odbija się NAD nie, po czym opada dokładnie na miejsce.
        float v = t - mainDur;
        float landAmount = 2.5 + noise(textData.characterPosition.x * 0.37) * 1.5; // różna amplituda na znak
        float decay = exp(-v * 2.6);
        bounce = -sin(v * 5.5) * landAmount * decay;
    }
    // Przez resztę cyklu 'bounce' zostaje 0.0 - to jest przerwa przed kolejnym podskokiem.

    textData.uv.y += bounce * textData.px.y;
    textData.shouldScale = true;
}

void apply_bounce() {
    apply_bounce(1.0);
}
void apply_scan_line(float speed) {
    if(textData.isShadow) return;
    float line = mod(textData.localPosition.y * 100.0 + GameTime * 3000.0 * speed, 1.0);
    if(line < 0.03 || line > 0.97) textData.topColor = vec4(0.0, 0.0, 0.0, 0.3);
}

void apply_scan_line() {
    apply_scan_line(1.0);
}

void apply_hologram(float speed) {
    vec3 blue = rgb(100, 200, 255);
    textData.color.rgb = blue;
    textData.color.a *= 0.9;
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    float band = mod(textData.localPosition.y + GameTime * 2000.0 * speed, 1.0);
    if(band < 0.1) textData.topColor = vec4(1.0, 1.0, 1.0, 0.5 * (1.0 - band * 10.0));
}

void apply_hologram() {
    apply_hologram(1.0);
}

void apply_mirror() {
    float midY = (textData.uvMin.y + textData.uvMax.y) * 0.5;
    if(textData.uv.y > midY) {
        textData.uv.y = 2.0 * midY - textData.uv.y;
        textData.color.a *= 0.5;
    }
    textData.shouldScale = true;
}

void apply_underwater(float speed) {
    float n = noise(textData.uv * 50.0 + GameTime * 3000.0 * speed);
    float n2 = noise(textData.uv * 30.0 + GameTime * 2500.0 * speed + 7.3);
    textData.uv += vec2((n - 0.5) * 2.0, (n2 - 0.5) * 2.0) * textData.px;
    textData.shouldScale = true;
}

void apply_underwater() {
    apply_underwater(1.0);
}

void apply_drip(float speed) {
    float t = textData.localPosition.y + GameTime * 3000.0 * speed;
    float drip = sin(t * 3.0) * 0.5 + 0.5;
    textData.uv.y += drip * 3.0 * textData.px.y;
    textData.shouldScale = true;
}

void apply_drip() {
    apply_drip(1.0);
}

void apply_typewriter(float speed) {
    // Typewriter effect - characters appear one by one and stay permanently
    float time = GameTime * 5000.0 * speed;
    float charPos = textData.characterPosition.x * 0.3;
    
    float cycleLength = 35.0;
    float cycleTime = mod(time, cycleLength);
    float charOffset = mod(charPos, cycleLength);
    
    // Simple logic: show if wave position >= character position
    bool isRevealed = (cycleTime >= charOffset);
    
    // Special case: if character is at the end and wave just restarted,
    // it was already revealed in previous cycle - keep it visible
    if(!isRevealed && charOffset > cycleLength * 0.85) {
        isRevealed = true;
    }
    
    if(!isRevealed) {
        // Not revealed yet - hide it
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    } else {
        // Character is revealed - add fade-in for characters currently being typed
        float distanceFromWave = cycleTime - charOffset;
        if(distanceFromWave >= 0.0 && distanceFromWave < 3.0) {
            // Currently being typed - smooth fade in
            float fadeAlpha = smoothstep(0.0, 3.0, distanceFromWave);
            textData.color.a *= fadeAlpha;
            textData.backColor.a *= fadeAlpha;
            textData.topColor.a *= fadeAlpha;
        }
        // Otherwise character stays fully visible
    }
}

void apply_typewriter() {
    apply_typewriter(1.0);
}

void apply_wobble(float speed) {
    float wave = sin(textData.characterPosition.x * 0.15 + GameTime * 5000.0 * speed) * 2.0 * textData.px.y;
    textData.uv.y += wave;
    textData.uv.x += cos(textData.characterPosition.y * 0.2 + GameTime * 4000.0 * speed) * 1.0 * textData.px.x;
    textData.shouldScale = true;
}

void apply_wobble() {
    apply_wobble(1.0);
}

void apply_slanted(float angle) {
    float midY = (textData.uvMin.y + textData.uvMax.y) * 0.5;
    textData.uv.x += (textData.uv.y - midY) * angle;
    textData.shouldScale = true;
}

void apply_slanted() {
    apply_slanted(0.15);
}

void apply_magic(float speed) {
    float t = 0.02 * (textData.position.x + textData.position.y) - GameTime * 500.0 * speed;
    vec3 purple = rgb(150, 80, 255);
    vec3 blue = rgb(80, 150, 255);
    textData.color.rgb = mix(purple, blue, sin(t) * 0.5 + 0.5);
    if(textData.isShadow) return;
    float n = noise(textData.localPosition * 60.0 + GameTime * 4000.0 * speed);
    if(n > 0.88) textData.topColor = vec4(1.0, 0.9, 1.0, (n - 0.88) * 8.3);
    textData.shouldScale = true;
}

void apply_magic() {
    apply_magic(1.0);
}

void apply_enchanted(float speed) {
    float t = 0.02 * (textData.position.x + textData.position.y) - GameTime * 400.0 * speed;
    vec3 purple = rgb(180, 100, 255);
    vec3 pink = rgb(255, 150, 220);
    vec3 baseColor = mix(purple, pink, sin(t) * 0.5 + 0.5);
    textData.color.rgb = baseColor;
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    vec3 d = textSdf();
    float glow = (1.0 - d.z) * (1.0 - d.z) * 0.4;
    textData.backColor = vec4(baseColor, glow);
    textData.shouldScale = true;
}

void apply_enchanted() {
    apply_enchanted(1.0);
}

void apply_mystical(float speed) {
    float t = 0.025 * (textData.position.x + textData.position.y) - GameTime * 450.0 * speed;
    vec3 purple = rgb(120, 60, 255);
    vec3 blue = rgb(60, 180, 255);
    textData.color.rgb = mix(purple, blue, fract(t));
    if(textData.isShadow) return;
    float n = noise(textData.localPosition * 50.0 + GameTime * 3500.0 * speed);
    if(n > 0.9) textData.topColor = vec4(0.9, 0.8, 1.0, (n - 0.9) * 10.0);
    textData.shouldScale = true;
}

void apply_mystical() {
    apply_mystical(1.0);
}

void apply_cursed(float speed) {
    vec3 darkPurple = rgb(80, 20, 120);
    textData.color.rgb = darkPurple;
    float n = noise(textData.uv * 40.0 + GameTime * 2500.0 * speed);
    float n2 = noise(textData.uv * 35.0 + GameTime * 2200.0 * speed + 11.3);
    textData.uv += vec2((n - 0.5) * 2.5, (n2 - 0.5) * 2.5) * textData.px;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_cursed() {
    apply_cursed(1.0);
}

void apply_blessed(float speed) {
    vec3 gold = rgb(255, 230, 180);
    textData.color.rgb = gold;
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    vec3 d = textSdf();
    float pulse = sin(GameTime * 2000.0 * speed) * 0.5 + 0.5;
    float glow = (1.0 - d.z) * (1.0 - d.z) * (0.2 + 0.15 * pulse);
    textData.backColor = vec4(gold, glow);
    textData.shouldScale = true;
}

void apply_blessed() {
    apply_blessed(1.0);
}

void apply_dragon_fire(float speed) {
    float t = 0.025 * (textData.position.x + textData.position.y) - GameTime * 450.0 * speed;
    vec3 red = rgb(255, 50, 30);
    vec3 orange = rgb(255, 140, 50);
    vec3 yellow = rgb(255, 220, 80);
    float phase = fract(t) * 3.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(red, orange, phase);
    else if(phase < 2.0) resultColor = mix(orange, yellow, phase - 1.0);
    else resultColor = mix(yellow, red, phase - 2.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_dragon_fire() {
    apply_dragon_fire(1.0);
}

void apply_nature(float speed) {
    float t = 0.03 * (textData.position.x + textData.position.y) - GameTime * 400.0 * speed;
    vec3 darkGreen = rgb(30, 120, 50);
    vec3 midGreen = rgb(80, 200, 100);
    vec3 lightGreen = rgb(150, 255, 150);
    float phase = fract(t) * 3.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(darkGreen, midGreen, phase);
    else if(phase < 2.0) resultColor = mix(midGreen, lightGreen, phase - 1.0);
    else resultColor = mix(lightGreen, darkGreen, phase - 2.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_nature() {
    apply_nature(1.0);
}

void apply_phoenix(float speed) {
    float t = 0.025 * (textData.position.x + textData.position.y) - GameTime * 500.0 * speed;
    vec3 red = rgb(255, 60, 40);
    vec3 orange = rgb(255, 150, 60);
    vec3 gold = rgb(255, 200, 80);
    float phase = fract(t) * 3.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(red, orange, phase);
    else if(phase < 2.0) resultColor = mix(orange, gold, phase - 1.0);
    else resultColor = mix(gold, red, phase - 2.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_phoenix() {
    apply_phoenix(1.0);
}

void apply_rainbow_wave(float speed) {
    float t = 0.02 * (textData.position.x + textData.position.y) - GameTime * 350.0 * speed;
    vec3 red = rgb(255, 0, 80);
    vec3 orange = rgb(255, 120, 0);
    vec3 yellow = rgb(255, 255, 0);
    vec3 green = rgb(0, 255, 100);
    vec3 cyan = rgb(0, 255, 255);
    vec3 blue = rgb(100, 100, 255);
    vec3 purple = rgb(200, 0, 255);
    float phase = fract(t) * 7.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(red, orange, phase);
    else if(phase < 2.0) resultColor = mix(orange, yellow, phase - 1.0);
    else if(phase < 3.0) resultColor = mix(yellow, green, phase - 2.0);
    else if(phase < 4.0) resultColor = mix(green, cyan, phase - 3.0);
    else if(phase < 5.0) resultColor = mix(cyan, blue, phase - 4.0);
    else if(phase < 6.0) resultColor = mix(blue, purple, phase - 5.0);
    else resultColor = mix(purple, red, phase - 6.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_rainbow_wave() {
    apply_rainbow_wave(1.0);
}

void apply_neon_pulse(float speed) {
    float t = GameTime * 2500.0 * speed;
    vec3 cyan = rgb(0, 255, 255);
    vec3 pink = rgb(255, 50, 200);
    vec3 lime = rgb(150, 255, 50);
    float phase = fract(t * 0.33) * 3.0;
    vec3 baseColor;
    if(phase < 1.0) baseColor = mix(cyan, pink, phase);
    else if(phase < 2.0) baseColor = mix(pink, lime, phase - 1.0);
    else baseColor = mix(lime, cyan, phase - 2.0);
    textData.color.rgb = baseColor;
    float pulse = sin(GameTime * 2000.0 * speed) * 0.5 + 0.5;
    float scale = 0.92 + 0.16 * pulse;
    vec2 center = textData.uvCenter;
    textData.uv = center + (textData.uv - center) * scale;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_neon_pulse() {
    apply_neon_pulse(1.0);
}

void apply_lava_flow(float speed) {
    float t = 0.03 * (textData.position.x + textData.position.y) - GameTime * 280.0 * speed;
    vec3 red = rgb(255, 40, 20);
    vec3 orange = rgb(255, 120, 30);
    vec3 yellow = rgb(255, 200, 50);
    float phase = fract(t) * 3.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(red, orange, phase);
    else if(phase < 2.0) resultColor = mix(orange, yellow, phase - 1.0);
    else resultColor = mix(yellow, red, phase - 2.0);
    textData.color.rgb = resultColor;
    float wave = sin(t * 4.0 + textData.position.y * 0.1) * 0.5 + 0.5;
    textData.color.rgb = mix(textData.color.rgb, resultColor * 1.2, wave * 0.3);
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_lava_flow() {
    apply_lava_flow(1.0);
}

void apply_prism_shift(float speed) {
    float t = GameTime * 400.0 * speed;
    vec3 c1 = rgb(255, 100, 200);
    vec3 c2 = rgb(100, 200, 255);
    vec3 c3 = rgb(100, 255, 150);
    vec3 c4 = rgb(255, 220, 100);
    vec3 c5 = rgb(200, 100, 255);
    float phase = fract(t) * 5.0;
    vec3 resultColor;
    if(phase < 1.0) resultColor = mix(c1, c2, phase);
    else if(phase < 2.0) resultColor = mix(c2, c3, phase - 1.0);
    else if(phase < 3.0) resultColor = mix(c3, c4, phase - 2.0);
    else if(phase < 4.0) resultColor = mix(c4, c5, phase - 3.0);
    else resultColor = mix(c5, c1, phase - 4.0);
    textData.color.rgb = resultColor;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_prism_shift() {
    apply_prism_shift(1.0);
}

void apply_spark_burst(float speed) {
    float t = 0.02 * (textData.position.x + textData.position.y) - GameTime * 500.0 * speed;
    vec3 vivid = rgb(255, 150, 50);
    vec3 vivid2 = rgb(255, 80, 180);
    textData.color.rgb = mix(vivid, vivid2, sin(t) * 0.5 + 0.5);
    if(textData.isShadow) { textData.color.rgb *= 0.25; return; }
    float n = noise(textData.localPosition * 80.0 + GameTime * 5000.0 * speed);
    if(n > 0.85) textData.topColor = vec4(1.0, 1.0, 1.0, (n - 0.85) * 6.7);
    textData.shouldScale = true;
}

void apply_spark_burst() {
    apply_spark_burst(1.0);
}

void apply_neon_flicker(float speed) {
    float t = GameTime * 8000.0 * speed;
    vec3 cyan = rgb(0, 255, 255);
    vec3 pink = rgb(255, 80, 200);
    vec3 baseColor = mix(cyan, pink, step(0.5, fract(t)));
    float flicker = step(0.15, fract(t * 3.7)) * 0.5 + 0.5;
    textData.color.rgb = baseColor * flicker;
    textData.shouldScale = true;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_neon_flicker() {
    apply_neon_flicker(1.0);
}

// found online
// 1. Główna funkcja z parametrem określającym prędkość
void apply_animated_gradient_7_smoother(vec3 color1, vec3 color2, vec3 color3, vec3 color4, vec3 color5, vec3 color6, vec3 color7, float speedMultiplier) {
    // Mnożymy podaną wartość przez 500.0 (czyli 1.0 = 500.0, 0.1 = 50.0 itd.)
    float actualSpeed = speedMultiplier * 500.0;
    float t = 0.01 * (textData.position.x + textData.position.y) - GameTime * actualSpeed;
    float smoothT = fract(t) * 12.0; // 0 to 12 range
    
    vec3 resultColor;
    if (smoothT < 1.0) {
        resultColor = mix(color1, color2, smoothT);
    } else if (smoothT < 2.0) {
        resultColor = mix(color2, color3, smoothT - 1.0);
    } else if (smoothT < 3.0) {
        resultColor = mix(color3, color4, smoothT - 2.0);
    } else if (smoothT < 4.0) {
        resultColor = mix(color4, color5, smoothT - 3.0);
    } else if (smoothT < 5.0) {
        resultColor = mix(color5, color6, smoothT - 4.0);
    } else if (smoothT < 6.0) {
        resultColor = mix(color6, color7, smoothT - 5.0);
    } else if (smoothT < 7.0) {
        resultColor = mix(color7, color6, smoothT - 6.0);
    } else if (smoothT < 8.0) {
        resultColor = mix(color6, color5, smoothT - 7.0);
    } else if (smoothT < 9.0) {
        resultColor = mix(color5, color4, smoothT - 8.0);
    } else if (smoothT < 10.0) {
        resultColor = mix(color4, color3, smoothT - 9.0);
    } else if (smoothT < 11.0) {
        resultColor = mix(color3, color2, smoothT - 10.0);
    } else {
        resultColor = mix(color2, color1, smoothT - 11.0);
    }
    
    float wave = sin(10.0 * t + textData.position.x * 0.2) * 0.5 + 0.5;
    resultColor = mix(resultColor, vec3(1.0), wave * 0.15);
    
    textData.color.rgb = resultColor;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

// 2. Funkcja pomocnicza, gdy nie podasz parametru prędkości
void apply_animated_gradient_7_smoother(vec3 color1, vec3 color2, vec3 color3, vec3 color4, vec3 color5, vec3 color6, vec3 color7) {
    // Przekazanie 1.0 jako ostatniego argumentu ustawi domyślną prędkość na 500.0
    apply_animated_gradient_7_smoother(color1, color2, color3, color4, color5, color6, color7, 1.0);
}
float frameTicksFire = 20.0;
float framesFire = 8.0;

void frame1Fire(){
    float frame = 1.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame2Fire(){
    float frame = 2.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame3Fire(){
    float frame = 3.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame4Fire(){
    float frame = 4.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame5Fire(){
    float frame = 5.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame6Fire(){
    float frame = 6.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame7Fire(){
    float frame = 7.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame8Fire(){
    float frame = 8.0;
    float frameStartTime = (frame - 1.0) / framesFire;
    float frameEndTime = frame / framesFire;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksFire));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}


float frameTicksRick = 40.0;
float framesRick = 16.0;

void frame1Rick(){
    float frame = 1.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame2Rick(){
    float frame = 2.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame3Rick(){
    float frame = 3.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame4Rick(){
    float frame = 4.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame5Rick(){
    float frame = 5.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame6Rick(){
    float frame = 6.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame7Rick(){
    float frame = 7.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame8Rick(){
    float frame = 8.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame9Rick(){
    float frame = 9.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame10Rick(){
    float frame = 10.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame11Rick(){
    float frame = 11.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame12Rick(){
    float frame = 12.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame13Rick(){
    float frame = 13.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame14Rick(){
    float frame = 14.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame15Rick(){
    float frame = 15.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame16Rick(){
    float frame = 16.0;
    float frameStartTime = (frame - 1.0) / framesRick;
    float frameEndTime = frame / framesRick;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksRick));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}


float frameTicksHeart = 20.0;
float framesHeart = 5.0;

void frame1Heart(){
    float frame = 1.0;
    float frameStartTime = (frame - 1.0) / framesHeart;
    float frameEndTime = frame / framesHeart;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksHeart));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame2Heart(){
    float frame = 2.0;
    float frameStartTime = (frame - 1.0) / framesHeart;
    float frameEndTime = frame / framesHeart;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksHeart));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame3Heart(){
    float frame = 3.0;
    float frameStartTime = (frame - 1.0) / framesHeart;
    float frameEndTime = frame / framesHeart;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksHeart));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame4Heart(){
    float frame = 4.0;
    float frameStartTime = (frame - 1.0) / framesHeart;
    float frameEndTime = frame / framesHeart;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksHeart));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

void frame5Heart(){
    float frame = 5.0;
    float frameStartTime = (frame - 1.0) / framesHeart;
    float frameEndTime = frame / framesHeart;
    float timeInAnimation = fract(GameTime * (24000 / frameTicksHeart));

    if (timeInAnimation < frameStartTime ||  timeInAnimation > frameEndTime) {
        textData.color.a = 0.0;
        textData.backColor.a = 0.0;
        textData.topColor.a = 0.0;
    }
}

float pink_fractal_rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float pink_fractal_noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(pink_fractal_rand(ip),pink_fractal_rand(ip+vec2(1.0,0.0)),u.x),
        mix(pink_fractal_rand(ip+vec2(0.0,1.0)),pink_fractal_rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

float pink_fractal_fbm( vec2 p ) {
    return 0.516129 * pink_fractal_noise( p + GameTime * 1200.0);
}

void apply_pink_fractal() {
    #ifdef FSH
        vec2 uv = vec2(gl_FragCoord.xy) / 100.0;
        float shade = pink_fractal_fbm(uv);
        vec3 lighter_dark_pink = vec3(0.6, -0.6, 0.6); 
        textData.color.rgb = mix(lighter_dark_pink, vec3(3.25, 3.136, 1.75), shade);
        if(textData.isShadow) {
            textData.color.rgb *= 0.25;
        }
    #endif
}

float fractal_rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float fractal_noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
        mix(fractal_rand(ip), fractal_rand(ip + vec2(1.0, 0.0)), u.x),
        mix(fractal_rand(ip + vec2(0.0, 1.0)), fractal_rand(ip + vec2(1.0, 1.0)), u.x),
        u.y
    );
    return res * res;
}

float fractal_fbm(vec2 p) {
    return 0.516129 * fractal_noise(p + GameTime * 1200.0);
}

void apply_rainbow_fractal() {
    #ifdef FSH
        vec2 uv = vec2(gl_FragCoord.xy) / 100.0;
        float fractalShade = fractal_fbm(uv);
        float baseHue = 0.005 * (textData.position.x + textData.position.y) - GameTime * 300.0;
        float hue = mod(baseHue + fractalShade, 1.0);

        textData.color.rgb = hsvToRgb(vec3(hue, 0.7, 1.0));

        if (textData.isShadow) {
            textData.color.rgb *= 0.25;
        }
    #endif
}

void apply_pale_rainbow_fractal() {
    #ifdef FSH
        vec2 uv = vec2(gl_FragCoord.xy) / 100.0;
        float fractalShade = fractal_fbm(uv);
        float baseHue = 0.005 * (textData.position.x + textData.position.y) - GameTime * 300.0;
        float hue = mod(baseHue + fractalShade, 1.0);

        textData.color.rgb = hsvToRgb(vec3(hue, 0.4, 1.2));

        if (textData.isShadow) {
            textData.color.rgb *= 0.25;
        }
    #endif
}

void apply_animated_gradient_3(vec3 color1, vec3 color2, vec3 color3, float speed) {
    // If speed is 1.0, this becomes 5000.0. If speed is 0.1, it becomes 500.0
    float actualSpeed = speed * 5000.0; 
    
    float t = 0.05 * (textData.position.x + textData.position.y) - GameTime * actualSpeed;
    float smoothT = fract(t / (2.0 * 3.14159)) * 3.0; // 0 to 3 range
    
    vec3 resultColor;
    if (smoothT < 1.0) {
        resultColor = mix(color1, color2, smoothT);
    } else if (smoothT < 2.0) {
        resultColor = mix(color2, color3, smoothT - 1.0);
    } else {
        resultColor = mix(color3, color1, smoothT - 2.0);
    }
    
    textData.color.rgb = resultColor;
    if(textData.isShadow) textData.color.rgb *= 0.25;
    textData.shouldScale = true;
}

// 2. The fallback function that takes 3 parameters
void apply_animated_gradient_3(vec3 color1, vec3 color2, vec3 color3) {
    // Calls the function above and passes 1.0 as the default speed
    apply_animated_gradient_3(color1, color2, color3, 1.0); 
}
// ===== Plywajace kule (floating orbs) =====
// Miekkie kule koloru dryfuja po tekscie nad plynnym gradientem.
// gradientFrom / gradientTo - kolory gradientu (tla), orb1..orb3 - kolory kul,
// speed  - predkosc (1.0 = normalnie)
// size   - wielkosc kul (1.0 = normalnie, 0.6 = male)
// motion - jak mocno kule sie ruszaja (1.0 = normalnie, 2.0 = duzo, max ok. 2.2)
// blur   - rozmycie krawedzi kul (0.3 = ostre, 1.0 = normalnie, 2.0-3.0 = mocno rozmyte)
// deform - zdeformowanie kul (0.0 = idealne kule, 1.0 = lekko, 2.0 = mocno)
float floating_orbs_hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3, float speed, float size, float motion, float blur, float deform) {
#ifdef FSH
    float t = time() * speed;
    vec2 p = textData.position;
    size = max(size, 0.2);
    motion = max(motion, 0.0);
    blur = clamp(blur, 0.2, 3.0);
    deform = clamp(deform, 0.0, 2.0);

    // tlo: miekki gradient, ktory powoli przelewa sie wzdluz tekstu
    float g = 0.5 + 0.5 * sin(p.x * 0.04 + p.y * 0.03 - t * 0.7);
    vec3 col = mix(gradientFrom, gradientTo, smoothstep(0.0, 1.0, g));

    // kule: jedna na komorke, kazda kolysze sie po swojemu, calosc dryfuje w bok i lekko w gore
    vec2 cell = vec2(22.0, 17.0) * size;
    // deformacja rozciaga kule maksymalnie o (1 + stretchMax), wgniecenia tylko je zmniejszaja
    float stretchMax = 0.175 * deform;
    // zasieg kolysania (w komorkach) - ograniczony, zeby kule (z rozmyciem i rozciagnieciem)
    // nie wychodzily poza sprawdzane sasiednie komorki
    vec2 swingMax = max(vec2(1.45) - vec2(0.6, 0.78) * (1.0 + stretchMax), vec2(0.0));
    vec2 swing = min(vec2(0.38, 0.32) * motion, swingMax);
    // przy wiekszym ruchu kule tez szybciej sie kolysza
    float wobbleSpeed = 0.75 + 0.25 * motion;
    // rozmycie: kolory sasiednich kul tez przechodza w siebie lagodniej
    float colorSharpness = 2.2 / max(blur, 0.35);
    vec2 q = p - vec2(t * 4.0, t * 1.2);
    vec2 base = floor(q / cell);
    float field = 0.0;
    float colorWeight = 0.0;
    vec3 orbColor = vec3(0.0);
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            vec2 id = base + vec2(float(i), float(j));
            float h1 = floating_orbs_hash(id);
            float h2 = floating_orbs_hash(id + vec2(17.31, 5.13));
            float h3 = floating_orbs_hash(id + vec2(3.71, 41.97));
            float h4 = floating_orbs_hash(id + vec2(29.17, 13.53));
            vec2 wobble = vec2(sin(t * wobbleSpeed * (0.55 + 0.5 * h1) + h2 * TAU),
                               cos(t * wobbleSpeed * (0.45 + 0.4 * h3) + h4 * TAU));
            vec2 center = (id + 0.5) * cell + wobble * cell * swing;
            float radius = mix(6.5, 11.0, h3) * size;
            vec2 d = (q - center) / radius;
            if (deform > 0.001) {
                // rozciaganie w obracajacym sie kierunku (jak galaretka)
                float e = stretchMax * (0.5 + 0.5 * sin(t * (0.7 + 0.6 * h2) + h1 * TAU));
                float ang = h3 * TAU + t * (0.3 + 0.4 * h4) * (h1 < 0.5 ? 1.0 : -1.0);
                vec2 dir = vec2(cos(ang), sin(ang));
                d = vec2(dot(d, dir), dot(d, vec2(-dir.y, dir.x))) * vec2(1.0 / (1.0 + e), 1.0 + e);
                // falujace wgniecenia na brzegu
                float th = atan(d.y, d.x + 0.00001);
                float wave = 0.6 * sin(2.0 * th + t * (1.1 + h2) + h4 * TAU) + 0.4 * sin(3.0 * th - t * (0.9 + h1) + h2 * TAU);
                d /= 1.0 - 0.15 * deform * (0.5 + 0.5 * wave);
            }
            float dd = dot(d, d);
            // okno: kula konczy sie na 1.2 promienia - dzieki temu nie ma przeskokow przy zmianie komorki
            float win = 1.0 - smoothstep(0.95, 1.2, sqrt(dd));
            float w = exp(-2.2 * dd) * win;
            float wc = exp(-colorSharpness * dd) * win;
            vec3 c = h4 < 0.334 ? orb1 : (h4 < 0.667 ? orb2 : orb3);
            field += w;
            colorWeight += wc;
            orbColor += c * wc;
        }
    }
    orbColor /= max(colorWeight, 0.000001);

    // odleglosc od "krawedzi" zlanych kul (0 = srodek); kule zlewaja sie jak w lampie lava
    float de = sqrt(max(-log(max(field, 0.000001)) / 2.2, 0.0));
    float bw = 0.22 * blur;
    float edge = 1.0 - smoothstep(max(0.7 - bw, 0.0), min(0.7 + bw, 1.2), de);
    col = mix(col, orbColor, edge);
    // jasniejszy srodek kul
    float core = 1.0 - smoothstep(0.0, clamp(0.32 * blur, 0.15, 0.7), de);
    col = mix(col, min(orbColor * 1.2 + 0.1, vec3(1.0)), core * 0.35);

    textData.color.rgb = col;
    if (textData.isShadow) textData.color.rgb *= 0.25;
#endif
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3, float speed, float size, float motion, float blur) {
    apply_floating_orbs(gradientFrom, gradientTo, orb1, orb2, orb3, speed, size, motion, blur, 0.0);
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3, float speed, float size, float motion) {
    apply_floating_orbs(gradientFrom, gradientTo, orb1, orb2, orb3, speed, size, motion, 1.0, 0.0);
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3, float speed, float size) {
    apply_floating_orbs(gradientFrom, gradientTo, orb1, orb2, orb3, speed, size, 1.0, 1.0, 0.0);
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3, float speed) {
    apply_floating_orbs(gradientFrom, gradientTo, orb1, orb2, orb3, speed, 1.0, 1.0, 1.0, 0.0);
}

void apply_floating_orbs(vec3 gradientFrom, vec3 gradientTo, vec3 orb1, vec3 orb2, vec3 orb3) {
    apply_floating_orbs(gradientFrom, gradientTo, orb1, orb2, orb3, 1.0, 1.0, 1.0, 1.0, 0.0);
}

void apply_floating_orbs() {
    apply_floating_orbs(rgb(122, 92, 255), rgb(63, 168, 255), rgb(255, 95, 210), rgb(92, 255, 225), rgb(255, 224, 102), 1.0, 1.0, 1.0, 1.0, 0.0);
}

#define TEXT_EFFECT(r, g, b) return true; case ((uint(r/4) << 16) | (uint(g/4) << 8) | (uint(b/4))):

bool applyTextEffects() { 
    uint vertexColorId = colorId(floor(round(textData.color.rgb * 255.0) / 4.0) / 255.0);
    if(textData.isShadow) { vertexColorId = colorId(textData.color.rgb);} 
    switch(vertexColorId >> 8) { 
        case 0xFFFFFFFFu:

    #moj_import<text_effects_config.glsl>
    
        return true; 
    } 
    return false;
}

#define CHALIU_PACK_9

#ifdef FSH
in vec4 vctfx_screenPos;
flat in float vctfx_applyTextEffect;
flat in float vctfx_isShadow;
flat in float vctfx_changedScale;
flat in vec2 vctfx_unitScale;

in vec3 vctfx_ipos1;
in vec3 vctfx_ipos2;
in vec3 vctfx_ipos3;
in vec3 vctfx_ipos4;

in vec3 vctfx_uvpos1;
in vec3 vctfx_uvpos2;
in vec3 vctfx_uvpos3;
in vec3 vctfx_uvpos4;

in float vertexDistance;

// Size of one font pixel in UV units.
// Vanilla font: 8 px glyph = 8 texels  -> 1/256 (identical to the old behaviour).
// HD bitmap font (e.g. 32 px glyphs)    -> 4/256, TTF with oversample N -> N/256.
// Computed from the glyph's on-screen size, so effects keep the same strength
// no matter which font a texture pack loads.
vec2 fx_fontPixel(vec2 uvSize, vec2 innerSize) {
    vec2 atlas = vec2(textureSize(Sampler0, 0));
    vec2 texels = uvSize * atlas;
    vec2 k2 = texels * abs(vctfx_unitScale) / max(abs(innerSize), vec2(1e-6));
    float k = k2.y;
    if (vctfx_unitScale.x < 0.0) k = min(k2.x, k2.y); // world text: protect against foreshortening
    k = max(1.0, floor(k + 0.25));
    if (isnan(k) || isinf(k)) k = 1.0;
    return vec2(k) / atlas;
}

#ifndef FX_FOG_DEFINED
#define FX_FOG_DEFINED
vec4 fx_applyFog(vec4 color) {
#if defined(IS_1_21_6) && !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    return apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
#elif !defined(IS_1_21_6) && !defined(IS_SEE_THROUGH)
    return linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
#else
    return color;
#endif
}
#endif

bool applyChaliuPack9() {
    // 0 = no effect, 1 = Chaliu (this file), 2 = Blockly (blockly_effects.glsl)
    if(vctfx_applyTextEffect < 0.5 || vctfx_applyTextEffect > 1.5) {
        return false;
    }

    textData.isShadow = vctfx_isShadow > 0.5;
    textData.backColor = vec4(0.0);
    textData.topColor = vec4(0.0);
    textData.doTextureLookup = true;
    textData.color = baseColor;
    
    vec2 ip1 = vctfx_ipos1.xy / vctfx_ipos1.z;
    vec2 ip2 = vctfx_ipos2.xy / vctfx_ipos2.z;
    vec2 ip3 = vctfx_ipos3.xy / vctfx_ipos3.z;
    vec2 ip4 = vctfx_ipos4.xy / vctfx_ipos4.z;
    vec2 innerMin = min(ip1.xy,min(ip2.xy,min(ip3.xy,ip4.xy)));
    vec2 innerMax = max(ip1.xy,max(ip2.xy,max(ip3.xy,ip4.xy)));
    vec2 innerSize = innerMax - innerMin;
    
    vec2 uvp1 = vctfx_uvpos1.xy / vctfx_uvpos1.z;
    vec2 uvp2 = vctfx_uvpos2.xy / vctfx_uvpos2.z;
    vec2 uvp3 = vctfx_uvpos3.xy / vctfx_uvpos3.z;
    vec2 uvp4 = vctfx_uvpos4.xy / vctfx_uvpos4.z;
    vec2 uvMin = min(uvp1.xy,min(uvp2.xy,min(uvp3.xy, uvp4.xy)));
    vec2 uvMax = max(uvp1.xy,max(uvp2.xy,max(uvp3.xy, uvp4.xy)));
    vec2 uvSize = uvMax - uvMin;
    textData.uvMin = uvMin;
    textData.uvMax = uvMax;
    textData.uvCenter = uvMin + 0.25 * uvSize;
    textData.px = fx_fontPixel(uvSize, innerSize);
    textData.localPosition = ((vctfx_screenPos.xy - innerMin) / innerSize);
    textData.localPosition.y = 1.0 - textData.localPosition.y;
    textData.uv = textData.localPosition * uvSize + uvMin;
    if(vctfx_changedScale < 0.5) {
        textData.uv = texCoord0;
    }
    textData.position = vctfx_screenPos.xy * uvSize / (innerSize * textData.px);
    textData.characterPosition = 0.5 * (innerMin + innerMax) * uvSize / (innerSize * textData.px);
    if(textData.isShadow) { 
        textData.characterPosition += vec2(-1.0, 1.0);
        textData.position += vec2(-1.0, 1.0);
    }
    applyTextEffects();
    if(uvBoundsCheck(textData.uv, uvMin, uvMax)) textData.doTextureLookup = false;
    
    // fx_glyph already reads the coverage from .r for TTF / unifont atlases
    // (the old code zeroed the sample here, which made such text invisible on 26.2+)
    vec4 textureSample = fx_glyph(textData.uv);

    if(!textData.doTextureLookup) textureSample = vec4(0.0);
    textData.topColor.a *= textureSample.a;

    fragColor = mix(vec4(textData.backColor.rgb, textData.backColor.a * textData.color.a), textureSample * textData.color, textureSample.a);
    fragColor.rgb = mix(fragColor.rgb, textData.topColor.rgb, textData.topColor.a);
    fragColor *= lightColor * ColorModulator;

    if (fragColor.a < 0.1) {
        discard;
    }

    fragColor = fx_applyFog(fragColor);
    return true;
}
#endif

#ifdef VSH
out vec4 vctfx_screenPos;
flat out float vctfx_applyTextEffect;
flat out float vctfx_isShadow;
flat out float vctfx_changedScale;
flat out vec2 vctfx_unitScale;

out vec3 vctfx_ipos1;
out vec3 vctfx_ipos2;
out vec3 vctfx_ipos3;
out vec3 vctfx_ipos4;

out vec3 vctfx_uvpos1;
out vec3 vctfx_uvpos2;
out vec3 vctfx_uvpos3;
out vec3 vctfx_uvpos4;

out float vertexDistance;

#ifndef FX_FOG_DEFINED
#define FX_FOG_DEFINED
void fx_writeFog(vec3 pos) {
#if defined(IS_1_21_6) && !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);
#elif !defined(IS_1_21_6)
    vertexDistance = length((ModelViewMat * vec4(pos, 1.0)).xyz);
#endif
}
#endif

bool applyChaliuPack9() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vctfx_isShadow = fract(Position.z) < 0.01 ? 1.0 : 0.0;
    vctfx_applyTextEffect = 1.0;
    vctfx_changedScale = 0.0;

    textData.isShadow = vctfx_isShadow > 0.5;
    textData.color = Color;
    textData.shouldScale = false;
    textData.px = vec2(1.0 / 256.0);

    // Same logic as before (first try the exact shadow colour, then the normal
    // colour), but with ONE call site of applyTextEffects(): the whole effect
    // list is inlined once instead of twice (smaller/faster vertex shader; the
    // double copy was also miscompiled by the Mesa driver in tests).
    #ifdef IS_1_21_6
    bool canRetry = textData.isShadow;
    #else
    bool canRetry = Position.z == 0.0 && textData.isShadow;
    #endif
    int passes = canRetry ? 2 : 1;
    bool matched = false;
    for(int pass = 0; pass < passes; pass++) {
        if(applyTextEffects()) {
            matched = true;
            break;
        }
        vctfx_isShadow = 0.0;
        textData.isShadow = false;
        textData.color = Color;
    }
    if(!matched) {
        vctfx_applyTextEffect = 0.0;
        return false;
    }

    vec2 corner = vec2[](vec2(-1.0, +1.0), vec2(-1.0, -1.0), vec2(+1.0, -1.0), vec2(+1.0, +1.0))[gl_VertexID % 4];

    // Glyph atlases are >= 256x256 (bitmap RGBA or TTF R8). Anything smaller
    // (e.g. map textures drawn with the text shader) is left untouched.
    ivec2 atlasSize = textureSize(Sampler0, 0);
    if(atlasSize.x < 256 || atlasSize.y < 256) {
        vctfx_applyTextEffect = 0.0;
        return false;
    }

    // clip-space units per font pixel, used by the FSH to measure the font resolution
    if (ProjMat[3][3] != 0.0) {
        // GUI (orthographic): 1 position unit = 1 GUI pixel
        mat4 mvp = ProjMat * ModelViewMat;
        vctfx_unitScale = vec2(abs(mvp[0][0]), abs(mvp[1][1]));
    } else {
        // world text (name tags, holograms): 1 font pixel = 0.025 blocks; x < 0 marks "world"
        vctfx_unitScale = vec2(-abs(ProjMat[0][0]), abs(ProjMat[1][1])) * 0.025;
    }

    vctfx_uvpos1 = vctfx_uvpos2 = vctfx_uvpos3 = vctfx_uvpos4 = vctfx_ipos1 = vctfx_ipos2 = vctfx_ipos3 = vctfx_ipos4 = vec3(0.0);
    switch (gl_VertexID % 4) {
        case 0: vctfx_ipos1 = vec3(gl_Position.xy, 1.0); vctfx_uvpos1 = vec3(UV0.xy, 1.0); break;
        case 1: vctfx_ipos2 = vec3(gl_Position.xy, 1.0); vctfx_uvpos2 = vec3(UV0.xy, 1.0); break;
        case 2: vctfx_ipos3 = vec3(gl_Position.xy, 1.0); vctfx_uvpos3 = vec3(UV0.xy, 1.0); break;
        case 3: vctfx_ipos4 = vec3(gl_Position.xy, 1.0); vctfx_uvpos4 = vec3(UV0.xy, 1.0); break;
    } 
    if(textData.shouldScale) {
        gl_Position.xy += corner * 0.2;
        vctfx_changedScale = 1.0;
    }

    vctfx_screenPos = gl_Position;
    fx_writeFog(Position);
    vertexColor = baseColor * lightColor;
    texCoord0 = UV0;
    return true;
}
#endif

#endif