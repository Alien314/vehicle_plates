#include "script_component.hpp"
params ["_vehicle"];

// get out of vehicle event
private _ctrlGroup = uiNamespace getVariable [QGVAR(mainControl), controlNull];
if (isNull _vehicle) exitWith {
    systemChat format ["%1 [VPS DEBUG] Hiding VPS UI", time];
    _ctrlGroup ctrlSetFade 1;
    _ctrlGroup ctrlCommit 0.1;
};
_ctrlGroup ctrlSetFade 0;
_ctrlGroup ctrlCommit 0.1;

private _plateCtrls = uiNamespace getVariable [QGVAR(plateControls), []];
private _plates = _vehicle getVariable [QGVAR(plates), []];
private _count = count _plates;

{
    private _ctrl = _x select 0;
    private _ctrlBack = _x select 1;
    private _pos = ctrlPosition _ctrl;
    if (_count > _forEachIndex) then {
        private _plateStatus = _plates select _forEachIndex;
        private _newWidth = (_ctrl getVariable QGVAR(innerWidth)) * (_plateStatus / GVAR(maxPlateHealth));
        _pos set [2, _newWidth];
    } else {
        _pos set [2, 0];
    };
    if ((ctrlPosition _ctrl) isNotEqualTo _pos) then {
        _ctrl ctrlSetPosition _pos;
    };
    _ctrl ctrlSetFade 0;
    _ctrl ctrlCommit 0.1;
    _ctrlBack ctrlSetFade 0;
    _ctrlBack ctrlCommit 0.1;
} forEach _plateCtrls;

if !(isNil QGVAR(hidePlateHandle)) then {
    terminate GVAR(hidePlateHandle);
    GVAR(hidePlateHandle) = nil;
};
if (GVAR(allowHideArmor)) then {
    GVAR(hidePlateHandle) = _plateCtrls spawn {
        sleep GVAR(hideUiSeconds);
        private _ctrlGroup = uiNamespace getVariable [QGVAR(mainControl), controlNull];
        _ctrlGroup ctrlSetFade 1;
        _ctrlGroup ctrlCommit 1;
    };
};
