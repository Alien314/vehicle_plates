#include "script_component.hpp"
ADDON = false;

if (hasInterface) then {
    GVAR(adjustUI) = true;
    [QEGVAR(main,setUICtrlGrp), {
        if !(GVAR(adjustUI)) exitWith {};
        [{
            params ["_ctrlGroup"];
            if (isNull objectParent ([] call CBA_fnc_currentUnit)) exitWith {};
            private _position = _ctrlGroup getVariable QEGVAR(main,defaultPos);
            private _acreCtrl = uiNamespace getVariable ["ACRE_VehicleInfo", controlNull];
            if (isNull _acreCtrl) then {
                _ctrlGroup ctrlSetPosition _position;
            } else {
                private _acreUIHeight = (ctrlPosition _acreCtrl) select 3;
                _ctrlGroup ctrlSetPosition (_position vectorAdd [0, _acreUIHeight, 0, 0]);
            };
            _ctrlGroup ctrlCommit 0.1;
        }, _this, 0.52] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addEventHandler;
};

ADDON = true;
