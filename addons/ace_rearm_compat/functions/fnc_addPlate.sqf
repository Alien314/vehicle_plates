#include "..\script_component.hpp"

params ["_target", "_unit"];

private _attachedDummy = _unit getVariable ["ace_rearm_dummy", objNull];
if (isNull _attachedDummy) exitWith {};


_this call EFUNC(main,addPlateActionStart);
[
    EGVAR(main,timeToAddPlate),
    [_target, _unit],
    {(_this select 0) call FUNC(addPlateSuccess)},
    {(_this select 0) call EFUNC(main,addPlateActionCancel)},
    LELSTRING(main,repairText),
    {
        //IGNORE_PRIVATE_WARNING ["_player"];
        param [0] params ["_target", "_unit"];
        _player distance _target <= ace_rearm_distance;
    },
    ["isnotinside"]
] call ace_common_fnc_progressBar;
