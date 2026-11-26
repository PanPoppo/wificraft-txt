#version 150

#moj_import <chaliu_lib.glsl>
#moj_import <chaliu_import.glsl>

bool applyChaliuEffects() {
    #ifdef CHALIU_PACK_0
    if(applyChaliuPack0()) return true;
    #endif
    #ifdef CHALIU_PACK_1
    if(applyChaliuPack1()) return true;
    #endif
    #ifdef CHALIU_PACK_2
    if(applyChaliuPack2()) return true;
    #endif
    #ifdef CHALIU_PACK_3
    if(applyChaliuPack3()) return true;
    #endif
    #ifdef CHALIU_PACK_4
    if(applyChaliuPack4()) return true;
    #endif
    #ifdef CHALIU_PACK_5
    if(applyChaliuPack5()) return true;
    #endif
    #ifdef CHALIU_PACK_6
    if(applyChaliuPack6()) return true;
    #endif
    #ifdef CHALIU_PACK_7
    if(applyChaliuPack7()) return true;
    #endif
    #ifdef CHALIU_PACK_8
    if(applyChaliuPack8()) return true;
    #endif
    #ifdef CHALIU_PACK_9
    if(applyChaliuPack9()) return true;
    #endif
    return false;
}
