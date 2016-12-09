/*
 * Author: BaerMitUmlaut
 * Handles the unconscious effect.
 *
 * Arguments:
 * 0: Enable <BOOL>
 * 1: Mode (0: instant, 1: animation, 2: fx handler) <NUMBER>
 *
 * Return Value:
 * None
 */
#include "script_component.hpp"
params ["_enable", "_mode"];

switch (_mode) do {
    // Instant (for Zeus or death)
    case 0: {
        GVAR(ppUnconsciousBlur)     ppEffectEnable _enable;
        GVAR(ppUnconsciousBlackout) ppEffectEnable _enable;
    };
    // Animated (triggered on unconscious event)
    case 1: {
        if (_enable) then {
            ACE_player setVariable [QGVAR(effectUnconsciousTimeout), CBA_missionTime + FX_UNCON_FADE_IN];
            GVAR(ppUnconsciousBlur)     ppEffectEnable true;
            GVAR(ppUnconsciousBlackout) ppEffectEnable true;

            GVAR(ppUnconsciousBlur)     ppEffectAdjust [0];
            GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
            GVAR(ppUnconsciousBlur)     ppEffectCommit 0;
            GVAR(ppUnconsciousBlackout) ppEffectCommit 0;

            GVAR(ppUnconsciousBlur)     ppEffectAdjust [5];
            GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
            GVAR(ppUnconsciousBlur)     ppEffectCommit FX_UNCON_FADE_IN;
            GVAR(ppUnconsciousBlackout) ppEffectCommit FX_UNCON_FADE_IN;
        } else {
            ACE_player setVariable [QGVAR(effectUnconsciousTimeout), CBA_missionTime + FX_UNCON_FADE_OUT];
            GVAR(ppUnconsciousBlur)     ppEffectEnable true;
            GVAR(ppUnconsciousBlackout) ppEffectEnable true;

            // Step 1: Widen eye "hole"
            GVAR(ppUnconsciousBlur)     ppEffectAdjust [5];
            GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0.9], [0, 0, 0, 1], [0, 0, 0, 0], [0.51, 0.17, 0, 0, 0, 0, 1]];
            GVAR(ppUnconsciousBlur)     ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            GVAR(ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);

            // Step 2: Open it
            [{
                GVAR(ppUnconsciousBlur)     ppEffectAdjust [0];
                GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0.8], [0, 0, 0, 1], [0, 0, 0, 0], [0.7, 0.78, 0, 0, 0, 0, 1]];
                GVAR(ppUnconsciousBlur)     ppEffectCommit (FX_UNCON_FADE_OUT * 2/3);
                GVAR(ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            }, [], FX_UNCON_FADE_OUT * 1/3] call CBA_fnc_waitAndExecute;

            // Step 3: Fade away vignette
            [{
                GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0.7, 0.78, 0, 0, 0, 0, 1]];
                GVAR(ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            }, [], FX_UNCON_FADE_OUT * 2/3] call CBA_fnc_waitAndExecute;
        };
    };
    // Raised by effectsHandler (blocked if animation in progress)
    case 2: {
        private _animatedTimeOut = ACE_player getVariable [QGVAR(effectUnconsciousTimeout), 0];
        if (_animatedTimeOut > CBA_missionTime) exitWith {};

        if (_enable) then {
            GVAR(ppUnconsciousBlur)     ppEffectAdjust [5];
            GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
        } else {
            GVAR(ppUnconsciousBlur)     ppEffectAdjust [0];
            GVAR(ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
        };
        GVAR(ppUnconsciousBlur)     ppEffectCommit 0;
        GVAR(ppUnconsciousBlackout) ppEffectCommit 0;

        GVAR(ppUnconsciousBlur)     ppEffectEnable _enable;
        GVAR(ppUnconsciousBlackout) ppEffectEnable _enable;
    };
};
