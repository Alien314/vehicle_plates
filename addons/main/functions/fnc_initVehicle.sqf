#include "script_component.hpp"

params ["_vehicle"];

if !(GVAR(enabled)) exitWith {};

if ((toLowerANSI typeOf _vehicle) in GVAR(vehBlacklist)) exitWith {
    _vehicle setVariable [QGVAR(disabled), true, true];
    _vehicle setVariable [QGVAR(numPlates), 0, true];
};

if (local _vehicle) then {
    if (isNil {_vehicle getVariable QGVAR(numPlates)}) then {
        if (_vehicle isKindOf "Tank") then {
            _vehicle setVariable [QGVAR(numPlates), GVAR(numMaxPlatesTank), true];
        } else {
            if (_vehicle isKindOf "Car") then {
                if (_vehicle isKindOf "Wheeled_Apc_F" || _vehicle isKindOf "gm_wheeled_APC_base") then {
                    _vehicle setVariable [QGVAR(numPlates), GVAR(numMaxPlatesAPC), true];
                } else {
                    _vehicle setVariable [QGVAR(numPlates), GVAR(numMaxPlatesCar), true];
                };
            } else {
                if (_vehicle isKindOf "Air") then {
                    _vehicle setVariable [QGVAR(numPlates), GVAR(numMaxPlatesAir), true];
                } else {
                    if (_vehicle isKindOf "Ship") then {
                        _vehicle setVariable [QGVAR(numPlates), GVAR(numMaxPlatesShip), true];
                    } else {
                        _vehicle setVariable [QGVAR(numPlates), 0, true];
                    };
                };
            };
        };
    } else {
        if !((_vehicle getVariable QGVAR(numPlates)) isEqualType 0) then {
            _vehicle setVariable [QGVAR(numPlates), 0, true];
        };
    };

    if (_vehicle getVariable [QGVAR(fillPlates), false]) then {
        private _plates = [];
        for "_i" from 1 to MAX_VEH_PLATES(_vehicle) do {
            _plates pushBack GVAR(maxPlateHealth);
        };
        _vehicle setVariable [QGVAR(plates), _plates];
    };
};

if !(isNil {_vehicle getVariable QGVAR(handleDamage)}) exitWith {};

[{
    params ["_vehicle"];
    [{
        params ["_vehicle"];

        if !(isNil {_vehicle getVariable QGVAR(handleDamage)}) exitWith {};

        _vehicle setVariable [QGVAR(handleDamage), _vehicle addEventHandler ["HandleDamage", {call FUNC(handleDamage)}]];
        _vehicle setVariable [QGVAR(hitHash), createHashMap];

        // ace vehicle damage compat
        if (missionNamespace getVariable ["ace_vehicle_damage_enabled", false]) then {
            if !(_vehicle isKindOf "Tank" ||
                {ace_vehicle_damage_enableCarDamage && _vehicle isKindOf "Car"} ||
                {!ace_vehicle_damage_enableCarDamage && {_vehicle isKindOf "Wheeled_Apc_F" || _vehicle isKindOf "gm_wheeled_APC_base"}}
            ) exitWith {};

            [{
                !isNil {_this getVariable "ace_vehicle_damage_handleDamage"}
            }, {
                private _ehID = _this getVariable "ace_vehicle_damage_handleDamage";
                _this setVariable [QGVAR(aceVehicleDamageEH), _ehID];
                _this setVariable ["ace_vehicle_damage_handleDamage", nil];
                _this removeEventHandler ["HandleDamage", _ehID];
            }, _vehicle] call CBA_fnc_waitUntilAndExecute;
        };
    }, [_vehicle]] call CBA_fnc_execNextFrame;
}, [_vehicle]] call CBA_fnc_execNextFrame;

nil
