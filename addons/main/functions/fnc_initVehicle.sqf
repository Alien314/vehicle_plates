#include "script_component.hpp"

params ["_vehicle"];

if !(GVAR(enabled)) exitWith {};

if ((toLowerANSI typeOf _vehicle) in GVAR(vehBlacklist)) exitWith {
    _vehicle setVariable [QGVAR(disabled), true, true];
    _vehicle setVariable [QGVAR(numPlates), 0, true];
};

if (local _vehicle) then {
    systemChat format ["%1 [VPS DEBUG] initializing vehicle: %2", time, getText (configOf _vehicle >> "displayName")];
    if (isNil {_vehicle getVariable QGVAR(numPlates)}) then {
        _vehicle setVariable [QGVAR(numPlates), [_vehicle] call FUNC(getMaxPlatesForType), true];
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

    if !NO_PLATES_ALLOWED(_vehicle) then {
        GVAR(trackedVehicles) pushBack _vehicle;
    };

    if (((crew _vehicle) select {isPlayer _x}) isNotEqualTo [])  then {
        [QGVAR(plateSync), [_vehicle, _vehicle getVariable [QGVAR(plates), []]], crew _vehicle] call CBA_fnc_targetEvent;
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
