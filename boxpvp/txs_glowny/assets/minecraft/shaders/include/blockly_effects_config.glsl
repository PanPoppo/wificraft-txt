// ============================================================
// EFEKTY Z BLOCKLY (przeniesione do WifiCraft)
// ============================================================
// Ten plik ma DOKLADNIE te sama skladnie co _config.glsl w Blockly,
// wiec mozesz kopiowac wpisy 1:1 miedzy paczkami.
//
//   TEXT_EFFECT(rgb(R, G, B)) { apply_xxx(); }              // sam tekst
//   TEXT_EFFECT_WITH_SHADOW(rgb(R, G, B)) { apply_xxx(); }  // tekst + cien
//   rgb(0xRRGGBB), rgba(R, G, B, 0.5), argb(...) tez dzialaja.
//
// Kolejnosc sprawdzania w WifiCraft:
//   1) kolory z text_effects_config.glsl (efekty WifiCraft)
//   2) kolory z tego pliku (efekty Blockly)
// Nie uzywaj tu koloru, ktory juz jest w text_effects_config.glsl
// (WifiCraft lapie tam kolory "co 4", np. #505100..#505103 to jeden efekt).
//
// Dostepne: apply_color, apply_shake, apply_wavy, apply_rainbow,
// apply_bouncy, apply_blinking, apply_pulse, apply_spin,
// apply_sequential_spin, apply_fade, apply_iterating, apply_glitch,
// apply_scale, apply_offset, apply_gradient, apply_dynamic_gradient,
// apply_lava, apply_aurora (3 lub 4 kolory), apply_jump, apply_split,
// apply_outline, apply_hatch, apply_neon, apply_chromatic, apply_extrude,
// apply_noise, apply_liquid, apply_water
// ============================================================

// Shake (#F8F854) - Red
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 84)) {
    apply_shake();
    apply_color(rgb(255, 80, 80));
}

// Wavy (#F8F858) - Green
TEXT_EFFECT_WITH_SHADOW(rgb(0xF8F858)) {
    apply_wavy();
    apply_color(rgb(80, 255, 80));
}

// Rainbow (#F8F85C)
TEXT_EFFECT(rgb(0xF8F85C)) {
    apply_rainbow();
}

// Bouncy (#F8F860) - Orange
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 96)) {
    apply_bouncy();
    apply_color(rgb(255, 170, 0));
}

// Blinking (#F8F864) - Blue
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 100)) {
    apply_blinking();
    apply_color(rgb(80, 80, 255));
}

// Pulse (#F8F868) - Cyan
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 104)) {
    apply_pulse();
    apply_color(rgb(80, 255, 255));
}

// Spin (#F8F86C) - Pink
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 108)) {
    apply_spin();
    apply_color(rgb(255, 80, 255));
}

// Sequential Spin (#F8F870) - White
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 112)) {
    apply_sequential_spin();
    apply_color(rgb(255, 255, 255));
}

// Fade (#F8F874) - Yellow
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 116)) {
    apply_fade();
    apply_color(rgb(255, 255, 80));
}

// Iterating Jump (#F8F878) - Purple
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 120)) {
    apply_iterating();
    apply_color(rgb(170, 0, 255));
}

// Glitch (#F8F87C) - Red
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 124)) {
    apply_glitch();
    apply_color(rgb(255, 80, 80));
}

// Scale x1.5 (#F8F880) - Cyan
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 128)) {
    apply_scale(1.5);
    apply_color(rgb(80, 255, 255));
}

// Offset up (#F8F884) - Orange
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 132)) {
    apply_offset(0.0, 40.0);
    apply_color(rgb(255, 170, 0));
}

// Gradient: Green → Yellow, Down (#F8F888)
TEXT_EFFECT(rgb(248, 248, 136)) {
    apply_gradient(rgb(0, 200, 0), rgb(255, 255, 0), 4.0);
}

// Dynamic Gradient: Red → Blue, Right (#F8F88C)
TEXT_EFFECT(rgb(248, 248, 140)) {
    apply_dynamic_gradient(rgb(255, 0, 0), rgb(0, 0, 255), 2.0, 500.0);
}

// Dynamic Gradient: Green → Yellow, Down (#F8F890)
TEXT_EFFECT(rgb(248, 248, 144)) {
    apply_dynamic_gradient(rgb(0, 200, 0), rgb(255, 255, 0), 4.0, 500.0);
}

// Lava (#F8F894)
TEXT_EFFECT(rgb(248, 248, 148)) {
    apply_lava();
}

// Wavy + Rainbow (#F8F898)
TEXT_EFFECT(rgb(248, 248, 152)) {
    apply_wavy();
    apply_rainbow();
}

// Bouncy + Rainbow (#F8F89C)
TEXT_EFFECT(rgb(248, 248, 156)) {
    apply_bouncy();
    apply_rainbow();
}

// Custom Parameters (Fast Shake) (#C86432)
TEXT_EFFECT(rgb(200, 100, 50)) {
    apply_shake(2.0, 1.5);
    apply_color(rgb(255, 255, 85));
}

// Shadow Support Example (Text + Shadow)
TEXT_EFFECT_WITH_SHADOW(rgb(255, 200, 200)) {
    apply_wavy(5000.0, 0.5);
}

// Aurora (#F8F8A0)
TEXT_EFFECT(rgb(248, 248, 160)) {
    apply_aurora();
}

// Split (#F8F8A4) - Pink
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 164)) {
    apply_split();
    apply_color(rgb(255, 100, 200));
}

// Outline (#F8F8AC) - fragment effect
TEXT_EFFECT(rgb(248, 248, 172)) {
    apply_outline(rgb(0, 0, 0), 1.0);
    apply_color(rgb(255, 255, 255));
}

// Hatch (#F8F8B0) - fragment effect
TEXT_EFFECT(rgb(248, 248, 176)) {
    apply_color(rgb(165, 233, 38));
    apply_hatch(rgb(255, 255, 255), 800.0, 3.0);
}

// Neon (#F8F8B4) - fragment effect
TEXT_EFFECT(rgb(248, 248, 180)) {
    apply_neon(rgb(80, 220, 255), 1.5);
}

// RGBA Alpha Example (#F8F8B8)
TEXT_EFFECT(rgb(248, 248, 184)) {
    apply_color(rgba(255, 80, 80, 0.5));
}

// Chromatic Aberration (#F8F8BC) — args: (intensity_pixels, speed)
TEXT_EFFECT(rgb(248, 248, 188)) {
    apply_chromatic(1.0, 1.0);
    apply_color(rgb(255, 255, 255));
}

// 3D Extrude (#F8F8C0) — args: (depth_pixels, layers)
TEXT_EFFECT(rgb(248, 248, 192)) {
    apply_extrude(1.0, 3.0);
    apply_color(rgb(255, 200, 0));
}

// 3D Extrude with explicit endColor (#F8F8CC) — args: (depth, layers, endColor)
TEXT_EFFECT(rgb(248, 248, 204)) {
    apply_extrude(1.0, 5.0, rgb(80, 40, 0));   // gradient from main color to dark brown
    apply_color(rgb(255, 220, 100));
}

// 3D Extrude 3-color (#F8F8D0) — args: (depth, layers, c1, c2, c3)
TEXT_EFFECT(rgb(248, 248, 208)) {
    apply_extrude(1.0, 5.0, rgb(206, 71, 240), rgb(180, 100, 30), rgb(89, 196, 28));
    apply_color(rgb(255, 240, 180));
}

// Noise (#F8F8C4) — args: (intensity_pixels, speed)
TEXT_EFFECT(rgb(248, 248, 196)) {
    apply_noise(1.0, 1.0);
    apply_color(rgb(255, 255, 255));
}

// Liquid Morph (#F8F8C8) — args: (intensity_pixels, speed)
TEXT_EFFECT(rgb(248, 248, 200)) {
    apply_liquid(1.0, 1.0);
    apply_color(rgb(80, 200, 220));
}

// Water (#F8F8D4) — args: (color) or (color, level) or (color, level, amp, speed) or (color, level, amp, speed, freq)
TEXT_EFFECT(rgb(248, 248, 212)) {
    apply_water(rgb(40, 150, 240));
    apply_color(rgb(60, 60, 80));   // dry portion (above water) tint
}

// Water with custom level (#F8F8D8) — 80% filled
TEXT_EFFECT(rgb(248, 248, 216)) {
    apply_water(rgb(0, 200, 200), 0.8, 1.5, 1.2);
    apply_color(rgb(40, 60, 60));
}

// Red Fluid Gradient (#F8F8DC) — smooth 3-color transition (#FF0000 -> #FF3D3D -> #D62626)
TEXT_EFFECT(rgb(248, 248, 220)) {
    apply_aurora(rgb(255, 0, 0), rgb(255, 61, 61), rgb(214, 38, 38), 500.0);
}

// Red Fluid Gradient (#F8F8DB) — Dynamic high-contrast 3-color transition (#FF1919 -> #FF7828 -> #960019)
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 219)) {
    apply_aurora(rgb(255, 25, 25), rgb(255, 111, 111), rgb(150, 0, 25), 750.0);
}

// Green #1 Pure Fluid Gradient (#F8F8DF) — (#15DE33 -> #28C13F -> #5BD66D)
TEXT_EFFECT_WITH_SHADOW(rgb(248, 248, 223)) {
    apply_aurora(rgb(21, 222, 51), rgb(40, 193, 63), rgb(91, 214, 109), 500.0);
}

// Green Fluid Gradient with Periodic Jump (#F8F8E0) — (#15DE33 -> #28C13F -> #5BD66D)
TEXT_EFFECT(rgb(248, 248, 224)) {
    apply_jump(0.5, 3.0); // Periodic jump: speed 0.5 (~co 3 sec), height 3px
    apply_aurora(rgb(21, 222, 51), rgb(40, 193, 63), rgb(91, 214, 109), 500.0);
}


// Green Fluid Gradient with Wave Iterating Jump (#F8F8E4) — (#15DE33 -> #28C13F -> #5BD66D)
TEXT_EFFECT(rgb(248, 248, 228)) {
    apply_iterating(0.6, 2.5); // Wave jump letter-by-letter with pause
    apply_aurora(rgb(21, 222, 51), rgb(40, 193, 63), rgb(91, 214, 109), 500.0);
}

// Shiny Gold Fluid (#F8F8E8) — Metallic gold shimmer (#FFD700 -> #FFF5A0 -> #D48800)
TEXT_EFFECT(rgb(248, 248, 232)) {
    apply_aurora(rgb(255, 215, 0), rgb(255, 245, 160), rgb(212, 136, 0), 450.0);
}

// Royal 3D Gold (#F8F8EC) — 3D extruded gold text with dark bronze depth
TEXT_EFFECT(rgb(248, 248, 236)) {
    apply_extrude(1.2, 5.0, rgb(200, 140, 0), rgb(120, 75, 0), rgb(50, 30, 0));
    apply_color(rgb(255, 215, 0));
}

// Golden Neon Glow (#F8F8F0) — Glowing golden neon outline
TEXT_EFFECT(rgb(248, 248, 240)) {
    apply_neon(rgb(255, 190, 40), 1.8);
    apply_color(rgb(255, 245, 180));
}

// Bouncy Golden Shimmer (#F8F8F4) — Metallic gold fluid + periodic jump
TEXT_EFFECT(rgb(248, 248, 244)) {
    apply_jump(0.5, 3.0);
    apply_aurora(rgb(255, 215, 0), rgb(255, 245, 160), rgb(212, 136, 0), 450.0);
}

// Vibrant Amber & Fire Orange Fluid (#F8F8F8) — Sunset orange & warm amber wave (#FF6600 -> #FF9900 -> #FFCC00)
TEXT_EFFECT(rgb(248, 248, 248)) {
    apply_aurora(rgb(255, 102, 0), rgb(255, 153, 0), rgb(255, 204, 0), 450.0);
}

// Fire 3D Lava Orange (#F8F8FC) — 3D extruded orange with dark ember red depth
TEXT_EFFECT(rgb(248, 248, 252)) {
    apply_extrude(1.2, 5.0, rgb(204, 34, 0), rgb(102, 0, 0), rgb(34, 0, 0));
    apply_color(rgb(255, 119, 0));
}

// Orange Neon Flame Glow (#F8F900) — Intense glowing orange neon outline
TEXT_EFFECT(rgb(248, 249, 0)) {
    apply_neon(rgb(255, 85, 0), 1.8);
    apply_color(rgb(255, 170, 68));
}

// Bouncy Amber Pulse (#F8F904) — Orange fluid wave + periodic jump
TEXT_EFFECT(rgb(248, 249, 4)) {
    apply_jump(0.5, 3.0);
    apply_aurora(rgb(255, 102, 0), rgb(255, 170, 0), rgb(255, 51, 0), 450.0);
}

// Sky Blue & Royal Blue Fluid (#F8F908) — (#58D0FF -> #70B5FF -> #5489FF)
TEXT_EFFECT(rgb(248, 249, 8)) {
    apply_aurora(rgb(88, 208, 255), rgb(112, 181, 255), rgb(84, 137, 255), 500.0);
}

// Bouncy Sky Blue Gradient (#F8F90C) — Sky blue fluid wave + periodic jump
TEXT_EFFECT(rgb(248, 249, 12)) {
    apply_jump(0.5, 3.0);
    apply_aurora(rgb(88, 208, 255), rgb(112, 181, 255), rgb(84, 137, 255), 500.0);
}

// Cyan-Blue Neon Glow (#F8F910) — Glowing royal blue neon outline with bright sky blue text
TEXT_EFFECT(rgb(248, 249, 16)) {
    apply_neon(rgb(84, 137, 255), 1.8);
    apply_color(rgb(88, 208, 255));
}

// Emerald & Lime Fluid Shimmer (#F8F914) — Neon lime & emerald wave (#39FF14 -> #00FF87 -> #00F5D4)
TEXT_EFFECT(rgb(248, 249, 20)) {
    apply_aurora(rgb(57, 255, 20), rgb(0, 255, 135), rgb(0, 245, 212), 450.0);
}

// Toxic Green Neon Glow (#F8F918) — Intense glowing matrix/toxic green neon outline
TEXT_EFFECT(rgb(248, 249, 24)) {
    apply_neon(rgb(0, 255, 68), 1.8);
    apply_color(rgb(163, 255, 184));
}

// Emerald Forest 3D (#F8F91C) — 3D extruded emerald text with dark forest jade depth
TEXT_EFFECT(rgb(248, 249, 28)) {
    apply_extrude(1.2, 5.0, rgb(0, 119, 51), rgb(0, 51, 17), rgb(0, 26, 8));
    apply_color(rgb(0, 230, 118));
}

// Bouncy Toxic Wave (#F8F920) — Neon lime wave + periodic jump
TEXT_EFFECT(rgb(248, 249, 32)) {
    apply_jump(0.5, 3.0);
    apply_aurora(rgb(57, 255, 20), rgb(0, 255, 135), rgb(0, 245, 212), 450.0);
}

// Toxic Cyber Emerald (#22FF00) — Unique Neon Aurora Wave (#22FF00 -> #80FF36 -> #27AA26)
TEXT_EFFECT(rgb(34, 255, 0)) {
    apply_iterating(0.5, 2.0);
    apply_aurora(rgb(34, 255, 0), rgb(180, 255, 100), rgb(39, 170, 38), 500.0);
    apply_neon(rgba(34, 255, 0, 0.9), 1.1, 0.0);
}

// Velvet Purple & Hot Pink Fluid (#F8F924) — Smooth 3-color transition (#962DFF -> #DC32D2 -> #FF5FC3)
TEXT_EFFECT(rgb(248, 249, 36)) {
    apply_aurora(rgb(150, 45, 255), rgb(220, 50, 210), rgb(255, 95, 195), 500.0);
}

// Bouncy Purple-Pink Fluid (#F8F928) — Purple-pink fluid wave + periodic jump
TEXT_EFFECT(rgb(248, 249, 40)) {
    apply_jump(0.5, 3.0);
    apply_aurora(rgb(150, 45, 255), rgb(220, 50, 210), rgb(255, 95, 195), 500.0);
}

// Wave Iterating Jump Purple-Pink (#F8F92C) — Wave jump character-by-character with purple-pink gradient
TEXT_EFFECT(rgb(248, 249, 44)) {
    apply_iterating(0.6, 2.5);
    apply_aurora(rgb(150, 45, 255), rgb(220, 50, 210), rgb(255, 95, 195), 500.0);
}

// Glowing Magenta-Pink Neon (#F8F930) — Intense neon pink glow with lavender violet text
TEXT_EFFECT(rgb(248, 249, 48)) {
    apply_neon(rgb(255, 40, 180), 1.8);
    apply_color(rgb(230, 170, 255));
}

// Royal Violet & Pink 3D Extrude (#F8F934) — 3D extruded pink text with deep purple-violet depth
TEXT_EFFECT(rgb(248, 249, 52)) {
    apply_extrude(1.2, 5.0, rgb(160, 35, 150), rgb(85, 15, 100), rgb(35, 5, 50));
    apply_color(rgb(255, 105, 200));
}

// Bouncy Neon Purple-Pink Pulse (#F8F938) — Bouncy wave + radiant purple-magenta aurora
TEXT_EFFECT(rgb(248, 249, 56)) {
    apply_bouncy(2500.0, 1.2);
    apply_aurora(rgb(160, 32, 240), rgb(255, 20, 147), rgb(255, 130, 220), 450.0);
}

// Soft Pastel Violet-Pink Wavy (#F8F93C) — Soft wavy animation with pastel purple-pink gradient
TEXT_EFFECT(rgb(248, 249, 60)) {
    apply_wavy(8000.0, 0.4);
    apply_dynamic_gradient(rgb(186, 104, 200), rgb(240, 98, 146), 2.0, 400.0);
}

// Red Smooth Gradient (#F8F940)
TEXT_EFFECT(rgb(248, 249, 64)) {
    apply_aurora(rgb(0xEA0000), rgb(0xCF0505), rgb(0xEE0404), 500.0);
}

// Gold/Yellow Smooth Gradient (#F8F944)
TEXT_EFFECT(rgb(248, 249, 68)) {
    apply_aurora(rgb(0xFFE931), rgb(0xD7B315), rgb(0xE5CB58), 500.0);
}

// Green Smooth Gradient (#F8F948)
TEXT_EFFECT(rgb(248, 249, 72)) {
    apply_aurora(rgb(0x56C850), rgb(0x5BE054), rgb(0x2BD622), 500.0);
}

// Lime/Green 4-Color Smooth Gradient (#F8F94C)
TEXT_EFFECT(rgb(248, 249, 76)) {
    apply_aurora(rgb(0x14CD0A), rgb(0x31DB28), rgb(0x51DD4A), rgb(0x2AEA20), 500.0);
}
