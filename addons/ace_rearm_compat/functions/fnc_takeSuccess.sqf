#include "..\script_component.hpp"

params ["_args"];
_args params ["_unit", "_magazineClass", "_truck", "_vehicle"];

private _success = true;
if (ace_rearm_supply > 0) then {
    _success = [_truck, "60Rnd_30mm_APFSDS_shells"] call ace_rearm_fnc_removeMagazineFromSupply;
};
if !(_success) exitWith {};

if (_vehicle == _unit) exitWith {};

[_unit, "forceWalk", "ace_rearm", true] call ace_common_fnc_statusEffect_set;
[_unit, "blockThrow", "ace_rearm", true] call ace_common_fnc_statusEffect_set;
private _dummy = QGVAR(armorPlate) createVehicle (position _unit);
_dummy allowDamage false;
_dummy setVariable ["ace_rearm_magazineClass", LELSTRING(main,plateItemName), true];
[_dummy, _unit] call ace_rearm_fnc_pickUpAmmo;

private _actionID = _unit addAction [
    format ["<t color='#FF0000'>%1</t>", localize "str_ace_common_Drop"],
    '(_this select 0) call ace_rearm_fnc_dropAmmo',
    nil,
    20,
    false,
    true,
    "",
    '!isNull (_target getVariable ["ace_rearm_dummy", objNull])'
];
_unit setVariable ["ace_rearm_ReleaseActionID", _actionID];
