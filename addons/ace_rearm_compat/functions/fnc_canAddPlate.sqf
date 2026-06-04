#include "..\script_component.hpp"

params ["_vehicle", "_unit"];

if (!alive _vehicle) exitWith {false};
if (ace_rearm_level == 0 || {isNull _unit} || {!(_unit isKindOf "CAManBase")} || {!local _unit} || {_vehicle distance _unit > 9} || {_vehicle getVariable ["ace_rearm_disabled", false]}) exitWith {false};

private _dummy = _unit getVariable ["ace_rearm_dummy", objNull];
if (isNull _dummy) exitWith {false};

if !(_dummy isKindOf GVAR(armorPlate)) exitWith {};

[_vehicle, _unit] call EFUNC(main,canAddPlate)
