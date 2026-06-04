#include "..\script_component.hpp"

params ["_truck", "_unit", "_args"];
_args params ["_magazineClass", "_vehicle"];

REARM_HOLSTER_WEAPON;

private _targetName = getText(configOf _vehicle >> "displayName");

[
    5,
    [_unit, "_magazineClass", _truck, _vehicle],
    FUNC(takeSuccess),
    "",
    format [localize "STR_ACE_Rearm_TakeAction", LELSTRING(main,plateItemName), _targetName],
    {true},
    ["isnotinside"]
] call ace_common_fnc_progressBar;

