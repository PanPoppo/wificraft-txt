#ifndef TEXT_EFFECT
#define TEXT_EFFECT(r, g, b) void f()
#endif

TEXT_EFFECT(80, 81, 0) { // #505100
    apply_shaking_movement();
    override_text_color(rgb(248, 77, 77));
    override_shadow_color(rgb(102, 21, 82));
}

TEXT_EFFECT(80, 81, 4) { // #505104
    apply_waving_movement();
    override_text_color(rgb(255, 235, 60));
    override_shadow_color(rgb(150, 60, 30));
}

TEXT_EFFECT(194, 47, 47) { // #505108
    apply_iterating_movement();
    override_text_color(rgb(245, 27, 27));
    override_shadow_color(rgb(110, 26, 26));
}

TEXT_EFFECT(80, 81, 12) { // #50510C
    apply_flipping_movement();
    override_text_color(rgb(255, 255, 255));
    override_shadow_color(rgb(0, 0, 0));
}

TEXT_EFFECT(80, 81, 16) { // #505110
    apply_skewing_movement();
    override_text_color(rgb(255, 255, 255));
    override_shadow_color(rgb(40, 40, 140));
}

TEXT_EFFECT(80, 81, 20) { // #505114
    override_text_color(rgb(100, 220, 255));
    apply_outline(rgb(0, 150, 200));
}

TEXT_EFFECT(80, 81, 24) { // #505118
    apply_gradient(rgb(255, 50, 150), rgb(150, 80, 255));
}

TEXT_EFFECT(80, 81, 28) { // #50511C
    apply_rainbow();
    textData.shouldScale = true;
}

TEXT_EFFECT(80, 81, 32) { // #505120
    override_text_color(rgb(255, 255, 255));
    override_shadow_color(rgb(0, 0, 0));
    apply_shimmer();
}

TEXT_EFFECT(80, 81, 36) { // #505124
    override_text_color(rgb(255, 255, 255));
    apply_chromatic_abberation();
    remove_text_shadow();
}

TEXT_EFFECT(80, 81, 40) { // #505128
    override_text_color(rgb(255, 20, 20));
    apply_fire();
}

TEXT_EFFECT(80, 81, 44) { // #50512C
    override_text_color(rgb(20, 150, 255));
    apply_water();
}

TEXT_EFFECT(80, 81, 48) { // #505130
    apply_growing_movement();
    override_text_color(rgb(255, 82, 82));
    override_shadow_color(rgb(100, 20, 80));
}

TEXT_EFFECT(80, 81, 52) { // #505134
    override_text_color(rgb(255, 235, 60));
    override_shadow_color(rgb(150, 60, 30));
    apply_fade(rgb(86, 235, 86));
}

TEXT_EFFECT(80, 81, 56) { // #505138
    override_text_color(rgb(86, 235, 86));
    override_shadow_color(rgb(20, 80, 90));
    apply_blinking();
}

TEXT_EFFECT(80, 81, 60) { // #50513C
    override_text_color(rgb(74, 222, 209));
    override_shadow_color(rgb(37, 71, 150));
    apply_glowing();
}

TEXT_EFFECT(80, 81, 64) { // #505140
    override_text_color(rgb(60, 193, 50));
    apply_outline(rgb(22, 75, 18));
}

TEXT_EFFECT(80, 81, 68) { // #505144
    apply_gradient(rgb(251, 143, 34), rgb(44, 44, 44));
}

TEXT_EFFECT(80, 81, 72) { // #505148
    apply_gradient(rgb(44, 44, 44), rgb(251, 143, 34));
}

TEXT_EFFECT(80, 81, 76) { // #50514C
    override_text_color(rgb(74, 35, 175));
    override_shadow_color(rgb(21, 12, 65));
    apply_fade(rgb(142, 34, 226));
}

TEXT_EFFECT(80, 81, 80) { // #505150
    apply_gradient(rgb(251, 225, 130), rgb(238, 183, 0));
}

TEXT_EFFECT(80, 81, 84) { // #505154
    apply_gradient(rgb(44, 44, 44), rgb(251, 143, 34));
}

TEXT_EFFECT(80, 81, 88) { // #505158
    apply_gradient(rgb(134, 255, 97), rgb(255, 56, 56));
}

TEXT_EFFECT(80, 81, 92) { // #50515C
    apply_waving_movement();
    override_text_color(rgb(255, 255, 255));
    override_shadow_color(rgb(0, 0, 0));
}

TEXT_EFFECT(80, 81, 96) { // #505160
    override_text_color(rgb(255, 255, 255));
    override_shadow_color(rgb(0, 0, 0));
    apply_sweep_shine();
}

TEXT_EFFECT(240, 241, 100) { // #F0F164
    apply_gradient(rgb(255, 0, 0), rgb(0, 255, 0));
}

TEXT_EFFECT(244, 240, 100) { // #F4F064 - green
    apply_animated_gradient_3(rgb(0, 230, 118), rgb(118, 255, 3), rgb(178, 255, 89));
}

TEXT_EFFECT(82, 230, 235) { // #52e6eb - Lighter Soul Blue
    apply_animated_gradient_3(rgb(137, 237, 255),rgb(0, 255, 255),rgb(148, 234, 255));
}

TEXT_EFFECT(244, 240, 108) { // #F4F06C - yellow
    apply_animated_gradient_3(rgb(255, 145, 0), rgb(255, 255, 0), rgb(255, 255, 141), 0.3);
}

TEXT_EFFECT(189, 85, 194) { // #bd55c2 - purple
    apply_animated_gradient_3(rgb(136, 59, 252), rgb(224, 84, 229), rgb(143, 68, 232));
}

TEXT_EFFECT(244, 240, 116) { // #F4F074 - pink
    apply_animated_gradient_3(rgb(255, 41, 149), rgb(255, 58, 243), rgb(247, 115, 255));
}

TEXT_EFFECT(227, 19, 5) { // #e31305 - red
    apply_animated_gradient_3(rgb(213, 0, 0), rgb(245, 0, 0), rgb(255, 138, 128), 0.7);
}
TEXT_EFFECT(19, 227, 5) { // #13e305 - green
    apply_animated_gradient_3(rgb(0, 213, 0), rgb(0, 245, 0), rgb(138, 255, 128), 0.7);
}
TEXT_EFFECT(244, 240, 124) { // #F4F07C - dreamteam
    apply_animated_gradient_3(rgb(168, 131, 243), rgb(131, 147, 249), rgb(222, 126, 246));
}

TEXT_EFFECT(244, 240, 128) { // #F4F080 - cosmicquartz
    apply_animated_gradient_3(rgb(28, 242, 149), rgb(51, 255, 255), rgb(255, 0, 255));
}

TEXT_EFFECT(244, 240, 132) { // #F4F084 - easter
    apply_animated_gradient_3(rgb(255, 255, 255), rgb(204, 255, 204), rgb(204, 255, 255));
}

TEXT_EFFECT(73, 205, 55) { // #49CD37
    apply_lucky_gradient();
    textData.shouldScale = true;
}

TEXT_EFFECT(120, 168, 227) { // #78a8e3
    apply_gradient(rgb(0, 162, 255), rgb(0, 225, 255));
}

TEXT_EFFECT(78, 217, 222) { // #4ed9de
    apply_waving_movement();
    apply_blue_gradient();
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 112) { // #F0F170
    apply_purple_to_green_gradient();
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 140) { // #F0F18C
    apply_rainbow_fractal();
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 144) { // #F0F190
    apply_pink_fractal();
    textData.shouldScale = true;
}

// Found online
TEXT_EFFECT(240, 241, 136) { // #F0F188 - witch brew
    apply_animated_gradient_7_smoother(rgb(148, 0, 211), rgb(186, 85, 211), rgb(147, 112, 219), rgb(170, 143, 226), rgb(111, 45, 168), rgb(153, 50, 204), rgb(120, 81, 169));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 148) { // #F0F194 - icy aurora
    apply_animated_gradient_7_smoother(rgb(173, 216, 230), rgb(135, 206, 235), rgb(0, 206, 209), rgb(64, 224, 208), rgb(0, 191, 255), rgb(175, 238, 238), rgb(176, 224, 230));
    textData.shouldScale = true;
}
TEXT_EFFECT(20, 201, 35) { // #14c923 - classic green
    apply_animated_gradient_7_smoother(
        rgb(7, 187, 7),     // Ciemna, głęboka zieleń (baza/cień)
        rgb(16, 172, 16),   // Leśna zieleń
        rgb(7, 189, 7),     // Nasycona zieleń
        rgb(0, 255, 0),     // Czysta, jaskrawa zieleń (najjaśniejszy punkt)
        rgb(50, 205, 50),   // Limonkowa zieleń
        rgb(144, 238, 144), // Jasna zieleń (poświata/błysk)
        rgb(40, 182, 40)    // Powrót do leśnej zieleni dla płynnego zapętlenia
    );
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 156) { // #F0F19C - summer sunshine
    apply_animated_gradient_7_smoother(rgb(255, 14, 14), rgb(253, 108, 26), rgb(255, 148, 50), rgb(255, 204, 24), rgb(255, 246, 39), rgb(255, 118, 60), rgb(231, 59, 59));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 160) { // #F0F1A0 - wizard magic
    apply_animated_gradient_7_smoother(rgb(105, 42, 239), rgb(95, 92, 253), rgb(139, 39, 239), rgb(205, 62, 255), rgb(255, 131, 243), rgb(208, 90, 90), rgb(246, 53, 53));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 164) { // #F0F1A4 - alien
    override_text_color(rgb(100, 255, 100));
    apply_alien();
}

TEXT_EFFECT(97, 149, 237) { // #6195ed - smooth sky blue
    apply_animated_gradient_7_smoother(rgb(0, 140, 230), rgb(0, 160, 240), rgb(40, 180, 250), rgb(70, 195, 255), rgb(40, 180, 250), rgb(0, 160, 240), rgb(0, 140, 230));
    textData.shouldScale = true;
}
TEXT_EFFECT(146, 181, 221) { // #92B5DD - vivid royal blue
    apply_animated_gradient_7_smoother(rgb(0, 130, 255), rgb(0, 170, 255), rgb(0, 210, 255), rgb(47, 224, 255), rgb(0, 210, 255), rgb(0, 170, 255), rgb(0, 130, 255));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 172) { // #F0F1AC - witch brew
    apply_animated_gradient_7_smoother(rgb(148, 0, 211), rgb(186, 85, 211), rgb(147, 112, 219), rgb(170, 143, 226), rgb(111, 45, 168), rgb(153, 50, 204), rgb(120, 81, 169));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 176) { // #F0F1B0 - vampire kiss
    apply_animated_gradient_7_smoother(rgb(178, 34, 34), rgb(220, 20, 60), rgb(139, 0, 0), rgb(184, 15, 10), rgb(229, 36, 36), rgb(255, 0, 0), rgb(97, 6, 6));
    textData.shouldScale = true;
}

TEXT_EFFECT(154, 20, 250) { // #9a14fa - electric pulse
    apply_animated_gradient_7_smoother(rgb(154, 20, 250), rgb(187, 36, 252), rgb(255, 0, 255), rgb(226, 43, 226), rgb(255, 20, 147), rgb(255, 0, 255), rgb(186, 85, 211));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 184) { // #F0F1B8 - spring meadow
    apply_animated_gradient_7_smoother(rgb(100, 253, 152), rgb(34, 214, 18), rgb(144, 238, 144), rgb(211, 254, 39), rgb(152, 251, 152), rgb(30, 162, 19), rgb(127, 255, 0));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 188) { // #F0F1BC - golden sparkle
    apply_animated_gradient_7_smoother(rgb(255, 215, 0), rgb(255, 223, 0), rgb(255, 193, 37), rgb(218, 165, 32), rgb(240, 230, 140), rgb(255, 239, 213), rgb(184, 134, 11));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 192) { // #F0F1C0 - candy cane
    apply_animated_gradient_7_smoother(rgb(255, 0, 0), rgb(255, 182, 193), rgb(220, 20, 60), rgb(255, 192, 203), rgb(255, 105, 180), rgb(240, 128, 128), rgb(205, 92, 92));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 196) { // #F0F1C4 - poinsettia bloom
    apply_animated_gradient_7_smoother(rgb(199, 21, 133), rgb(255, 105, 180), rgb(208, 32, 144), rgb(219, 112, 147), rgb(231, 84, 128), rgb(255, 20, 147), rgb(176, 48, 96));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 200) { // #F0F1C8 - sweet embrace
    apply_animated_gradient_7_smoother(rgb(255, 182, 193), rgb(255, 160, 122), rgb(255, 105, 180), rgb(255, 69, 105), rgb(219, 112, 147), rgb(255, 218, 185), rgb(250, 128, 114));
    textData.shouldScale = true;
}

TEXT_EFFECT(240, 241, 204) { // #F0F1CC - enchanted evening
    apply_animated_gradient_7_smoother(rgb(93, 48, 167), rgb(72, 61, 139), rgb(123, 104, 238), rgb(147, 112, 219), rgb(186, 85, 211), rgb(255, 105, 180), rgb(176, 48, 96));
    textData.shouldScale = true;
}

TEXT_EFFECT(245, 48, 224) { // #F530E0 - elite prefix
    apply_animated_gradient_7_smoother(rgb(219, 84, 186), rgb(223, 72, 178), rgb(255, 97, 255), rgb(255, 255, 255), rgb(242, 96, 255), rgb(198, 23, 204), rgb(192, 93, 201));
    textData.shouldScale = true;
}

TEXT_EFFECT(245, 48, 228) { // #F530E4 - elite name
    apply_animated_gradient_7_smoother(rgb(219, 84, 186), rgb(223, 72, 178), rgb(255, 97, 255), rgb(255, 58, 239), rgb(242, 96, 255), rgb(198, 23, 204), rgb(192, 93, 201));
    textData.shouldScale = true;
}

TEXT_EFFECT(245, 67, 66) { // #F54342 - firework prefix
    apply_animated_gradient_7_smoother(rgb(34, 117, 212), rgb(47, 128, 221), rgb(134, 222, 252), rgb(255, 187, 187), rgb(247, 117, 117), rgb(253, 74, 74), rgb(255, 40, 40));
    textData.shouldScale = true;
}

TEXT_EFFECT(92, 81, 0) { // #5C5100 - pulse
    override_text_color(rgb(255, 100, 150));
    apply_pulse();
}

TEXT_EFFECT(92, 81, 4) { // #5C5104 - glitch
    override_text_color(rgb(255, 255, 255));
    apply_glitch();
}

TEXT_EFFECT(92, 81, 8) { // #5C5108 - neon glow pulse
    override_text_color(rgb(0, 255, 255));
    apply_neon_glow_pulse();
}

TEXT_EFFECT(92, 81, 20) { // #5C5114 - rpg damage
    override_text_color(rgb(255, 80, 80));
    apply_rpg_damage();
}

TEXT_EFFECT(92, 81, 24) { // #5C5118 - aurora
    apply_aurora();
}

TEXT_EFFECT(92, 81, 28) { // #5C511C - terminal
    apply_terminal();
}

TEXT_EFFECT(92, 81, 32) { // #5C5120 - loot rare
    apply_loot_rare();
}

TEXT_EFFECT(92, 81, 36) { // #5C5124 - electric
    apply_electric();
}

TEXT_EFFECT(92, 81, 40) { // #5C5128 - rotate
    override_text_color(rgb(255, 200, 100));
    apply_rotate();
}

TEXT_EFFECT(92, 81, 52) { // #5C5134 - zigzag
    override_text_color(rgb(150, 255, 150));
    apply_zigzag();
}

TEXT_EFFECT(92, 81, 56) { // #5C5138 - outline wave
    override_text_color(rgb(255, 255, 255));
    apply_outline_wave();
}

TEXT_EFFECT(92, 81, 64) { // #5C5140 - cooldown
    override_text_color(rgb(150, 150, 150));
    apply_cooldown();
}

TEXT_EFFECT(92, 81, 72) { // #5C5148 - poison
    apply_poison();
}

TEXT_EFFECT(92, 81, 76) { // #5C514C - boss warning
    apply_boss_warning();
}

TEXT_EFFECT(56, 200, 236) { // #38c8ec - bounce
apply_animated_gradient_7_smoother(rgb(40, 125, 215), rgb(70, 150, 230), rgb(110, 180, 245), rgb(120, 203, 255), rgb(110, 180, 245), rgb(70, 150, 230), rgb(40, 125, 215));
    apply_bounce();
}

TEXT_EFFECT(92, 81, 84) { // #5C5154 - scan line
    override_text_color(rgb(200, 200, 200));
    apply_scan_line();
}

TEXT_EFFECT(92, 81, 88) { // #5C5158 - hologram
    apply_hologram();
}

TEXT_EFFECT(92, 81, 108) { // #5C516C - mirror
    override_text_color(rgb(200, 200, 255));
    apply_mirror();
}

TEXT_EFFECT(92, 81, 112) { // #5C5170 - underwater
    override_text_color(rgb(100, 200, 255));
    apply_underwater();
}

TEXT_EFFECT(92, 81, 124) { // #5C517C - drip
    override_text_color(rgb(150, 100, 200));
    apply_drip();
}

TEXT_EFFECT(92, 85, 200) { // #5C55C8 - typewriter
    override_text_color(rgb(255, 255, 255));
    apply_typewriter();
}

TEXT_EFFECT(92, 81, 132) { // #5C5184 - wobble
    override_text_color(rgb(150, 255, 150));
    apply_wobble();
}

TEXT_EFFECT(92, 81, 136) { // #5C5188 - slanted
    override_text_color(rgb(200, 200, 255));
    apply_slanted();
}

TEXT_EFFECT(92, 81, 140) { // #5C518C - magic
    apply_magic();
}

TEXT_EFFECT(92, 81, 144) { // #5C5190 - enchanted
    apply_enchanted();
}

TEXT_EFFECT(92, 81, 148) { // #5C5194 - mystical
    apply_mystical();
}

TEXT_EFFECT(92, 81, 152) { // #5C5198 - cursed
    apply_cursed();
}

TEXT_EFFECT(92, 81, 156) { // #5C519C - blessed
    apply_blessed();
}

TEXT_EFFECT(92, 81, 160) { // #5C51A0 - dragon fire
    apply_dragon_fire();
}

TEXT_EFFECT(92, 81, 168) { // #5C51A8 - nature
    apply_nature();
}

TEXT_EFFECT(92, 81, 184) { // #5C51B8 - phoenix
    apply_phoenix();
}

TEXT_EFFECT(124, 109, 188) { // #7C6DBC - rainbow wave
    apply_rainbow_wave();
}

TEXT_EFFECT(124, 109, 192) { // #7C6DC0 - neon pulse
    apply_neon_pulse();
}

TEXT_EFFECT(124, 109, 196) { // #7C6DC4 - lava flow
    apply_lava_flow();
}

TEXT_EFFECT(124, 109, 200) { // #7C6DC8 - prism shift
    apply_prism_shift();
}

TEXT_EFFECT(124, 109, 204) { // #7C6DCC - spark burst
    apply_spark_burst();
}

TEXT_EFFECT(124, 109, 208) { // #7C6DD0 - neon flicker
    apply_neon_flicker();
}

TEXT_EFFECT(124, 109, 212) { // #7C6DD4 - valentine
    override_text_color(rgb(255, 100, 150));
    apply_valentine();
}

TEXT_EFFECT(124, 109, 216) { // #7C6DD8 - halloween pumpkin
    override_text_color(rgb(255, 140, 50));
    apply_halloween_pumpkin();
}

TEXT_EFFECT(80, 81, 160) { // #5051A0 - Nowy efekt
    apply_iterating_movement(1.0, 4.0);
    apply_animated_gradient_3(rgb(255, 0, 0), rgb(199, 0, 0), rgb(230, 0, 0), 0.5);
}

TEXT_EFFECT(80, 81, 164) { // #5051A4 - Nowy efekt
    apply_animated_gradient_3(rgb(255, 221, 0), rgb(255, 235, 15), rgb(255, 247, 0));
}

TEXT_EFFECT(80, 85, 160) { // #5055A0 - Nowy efekt
    apply_animated_gradient_3(rgb(61, 84, 255), rgb(0, 110, 255), rgb(32, 87, 254));
}

TEXT_EFFECT(80, 81, 168) { // #5051A8 - Pływające kule
    apply_floating_orbs(rgb(122, 92, 255), rgb(63, 168, 255), rgb(255, 95, 210), rgb(92, 255, 225), rgb(255, 224, 102), 1.6, 1.0, 1.0, 2.0, 1.0);
}

TEXT_EFFECT(84, 81, 160) { // #5451A0 - keyall
    apply_floating_orbs(rgb(255, 248, 36), rgb(255, 234, 0), rgb(255, 221, 0), rgb(255, 187, 0), rgb(255, 220, 46), 1.4, 0.4, 1.0, 1.0, 0.8);
}

TEXT_EFFECT(80, 81, 172) { // #5051AC - Małe pływające kule
    apply_floating_orbs(rgb(122, 92, 255), rgb(63, 168, 255), rgb(255, 95, 210), rgb(92, 255, 225), rgb(255, 224, 102), 1.8, 0.6, 2.0, 1.8, 1.2);
}

TEXT_EFFECT(80, 81, 156) { // #50519C - odbierz keyall
    apply_waving_movement(1.0, 0.2);
    apply_animated_gradient_3(rgb(255, 200, 0), rgb(254, 200, 6), rgb(255, 247, 0));
}

TEXT_EFFECT(240, 219, 81) { // #F0DB51 - karnet zloty
    apply_bounce(0.7);
    apply_animated_gradient_3(rgb(255, 162, 0), rgb(255, 210, 74), rgb(255, 241, 168), 0.5);
}

TEXT_EFFECT(170, 188, 197) { // #AABCC5 - karnet srebrny
    apply_animated_gradient_3(rgb(169, 176, 187), rgb(227, 227, 227), rgb(255, 255, 255), 0.5);
    apply_waving_movement(0.5);
}
