#include "script_component.hpp"

params ["_veh", "_unit"];

// called from an ace progress bar action
if (_veh isEqualType []) then {
    _unit = _veh select 1;
    _veh = _veh select 0;
};

if (isNull objectParent _unit) then {
    private _animation = _unit getVariable [QGVAR(repairPrevAnimCaller), ""];
    _unit playMoveNow _animation;

    if (animationState _unit != _animation) then {
        [QGVAR(switchMove), [_unit, _animation]] call CBA_fnc_globalEvent;
    };
};
_unit setVariable [QGVAR(repairPrevAnimCaller), nil];

private _weaponSelect = _unit getVariable QGVAR(selectedWeaponOnrepair);

if (isNil "_weaponSelect") then {
    _unit action ["SwitchWeapon", _unit, _unit, 299];
} else {
    _unit selectWeapon _weaponSelect;
    _unit setVariable [QGVAR(selectedWeaponOnrepair), nil];
};
