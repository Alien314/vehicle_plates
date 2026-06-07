#include "script_component.hpp"

params ["_logic"];

if !(local _logic) exitWith {};

private _vehicle = attachedTo _logic;
deleteVehicle _logic;

private _isObj = _vehicle isEqualType objNull;
private _isPerson = (_isObj && {(_vehicle isKindOf "CAManBase")});
if (_isPerson && _isObj) then {_vehicle = vehicle _vehicle};
if (!_isObj || {isNull _vehicle} || {!alive _vehicle} || {NO_PLATES_ALLOWED(_vehicle)}) exitWith {
    [objNull, LLSTRING(zeus_invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

[QGVAR(fillPlates), [_vehicle], _vehicle] call CBA_fnc_targetEvent;

[objNull, format [LLSTRING(zeus_plates_applied), getText (configOf _vehicle >> "displayName")]] call BIS_fnc_showCuratorFeedbackMessage;
