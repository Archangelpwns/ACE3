/*
 * Author: Norrin, Rocko, Ruthberg
 *
 * Handles HuntIR projectiles
 *
 * Arguments:
 * 0: unit - Object the event handler is assigned to <OBJECT>
 * 1: weapon - Fired weapon <STRING>
 * 2: muzzle - Muzzle that was used <STRING>
 * 3: mode - Current mode of the fired weapon <STRING>
 * 4: ammo - Ammo used <STRING>
 * 5: magazine - magazine name which was used <STRING>
 * 6: projectile - Object of the projectile that was shot <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Public: No
 */
#include "script_component.hpp"

PARAMS_7(_unit,_weapon,_muzzle,_mode,_ammo,_magazine,_projectile);

if (_ammo != "F_HuntIR") exitWith {};

[{
    PARAMS_1(_projectile);
    "ACE_HuntIR_Propell" createVehicle (getPosATL _projectile);
    [{
        PARAMS_1(_position);
        private ["_huntir"];
        _huntir = createVehicle ["ACE_HuntIR", _position, [], 0, "FLY"];
        _huntir setPosATL _position;
        _huntir addEventHandler ["HandleDamage", {_this call FUNC(handleDamage)}];
        [{
            EXPLODE_1_PVT(_this select 0,_huntir);
            if (isNull _huntir) exitWith {
                [_this select 1] call CBA_fnc_removePerFrameHandler;
            };
            private ["_deltaT", "_velocity"];
            _velocity = velocity _huntir;
            if (damage _huntir > 0) then {
                _deltaT = ACE_time - (_huntir getVariable [QGVAR(lastTime), ACE_time]);
                _velocity = _velocity vectorAdd [0, 0, -9.8066 * (damage _huntir) * _deltaT];
                _huntir setVariable [QGVAR(lastTime), ACE_time];
            } else {
                _velocity set [2, -1];
            };
            _huntir setVelocity _velocity;
            _huntir setVectorUp [0, 0, 1];
        }, 0.1, [_huntir]] call CBA_fnc_addPerFrameHandler;
    }, [getPosATL _projectile vectorAdd [0, 0, 50]], 2, 0] call EFUNC(common,waitAndExecute);
}, [_projectile], 5, 0] call EFUNC(common,waitAndExecute);
