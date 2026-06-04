#include "script_component.hpp"

params ["_veh", "_unit", ["_mode", "default"]];

if NO_PLATES_ALLOWED(_veh) exitWith {false};

private _plates = _veh getVariable [QGVAR(plates), []];
private _countPlates = count _plates;

// vehicle already at full plates
private _numPlates = _veh getVariable [QGVAR(numPlates), 0];
if !(_countPlates < _numPlates || {GVAR(allowPlateReplace) && _countPlates isEqualTo _numPlates && {((_plates findIf {_x < GVAR(maxPlateHealth)}) > -1)}}) exitWith {false};

private _class = _unit getVariable ["ACE_IsEngineer", _unit getUnitTrait "engineer"];
if (_class isEqualType false) then {_class = parseNumber _class};
if (missionNamespace getVariable ["ace_repair_locationsBoostTraining", false]) then {
    if ([_unit] call ace_repair_fnc_isInRepairFacility || {[_unit] call ace_repair_fnc_isNearRepairVehicle}) then {
        _class = _class + 1;
    };
};

if (GVAR(requireEngineer) && _class isEqualTo 0) exitWith {false};

private _result = switch (_mode) do {
    case "repair_vehicle": {
        GVAR(allowAddPlateViaRepairVehicle) &&
        {((nearestObjects [_unit, ["Air", "LandVehicle", "Ship", "ThingX"], 20]) findIf {
            alive _x && {getRepairCargo _x > 0 || {[_x] call (missionNamespace getVariable ["ace_repair_fnc_isRepairVehicle", {false}])}}
        }) > -1};
    };
    case "ace_rearm": {
        missionNamespace getVariable [QEGVAR(ace_rearm_compat,allowAddPlateViaAceRearm), false]
    };
    default {true};
};

_result
