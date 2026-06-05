#include "..\script_component.hpp"

params ["_vehicle", "_unit"];

if !(alive _vehicle) exitWith {};

if !(_this call EFUNC(main,canAddPlate)) exitWith {};

if (local _unit) then {
    [_unit, true, true] call ace_rearm_fnc_dropAmmo;
};

_this call EFUNC(main,addPlateActionSuccess)
