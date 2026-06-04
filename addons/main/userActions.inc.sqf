private _aceInteractionLoaded = missionNamespace getVariable ["ace_interact_menu", false];
private _aceRepairLoaded = missionNamespace getVariable ["ace_repair", false];

if (_aceInteractionLoaded && _aceRepairLoaded) then {
    private _action = [GVAR(addPlate), LLSTRING(addPlate), "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa",
        {
            params ["_veh", "_unit"];
            _this call FUNC(addPlateActionStart);
            [
                GVAR(timeToAddPlate),
                _this,
                FUNC(addPlateActionSuccess),
                FUNC(addPlateActionCancel),
                LLSTRING(repairText),
                {
                    (_this select 0) params ["_veh"];
                    alive _veh &&
                    {(abs speed _veh) < 1}
                },
                ["isNotSwimming", "isNotOnLadder"]
            ] call ace_common_fnc_progressBar;
        },
        {
            params ["_veh", "_unit"];
            if NO_PLATES_ALLOWED(_veh) exitWith {false};
            if !(local _veh) then {
                [QGVAR(requestFullPlateSync), [_veh], [_veh]] call CBA_fnc_targetEvent;
            };
            [_veh, _unit, "repair_vehicle"] call FUNC(canAddPlate)
        }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
    {
        [_x, 0, ["ACE_MainActions", "ace_repair_Repair"], _action, true] call ace_interact_menu_fnc_addActionToClass;
    } forEach VEH_BASE_CLASSES;
} else {
    {
        [_x, "Init", {
            params ["_veh"];
            [_veh,
            format ["%1: %2", LLSTRING(addPlate), getText (configOf _veh >> "displayname")], //_title
            nil, nil, // icons
            // show condition
            'call {
                if (cursorObject isNotEqualTo _target) exitWith {false};
                if !(isNull objectParent _this) exitWith {false};
                if NO_PLATES_ALLOWED(_target) exitWith {false};
                if (local _target && {(_target getVariable [QGVAR(nextSync), -1]) < cba_missionTime}) then {
                    _target setVariable [QGVAR(nextSync), cba_missionTime + 5];
                    [QGVAR(requestFullPlateSync), [_target], [_target]] call CBA_fnc_targetEvent;
                };
                [_target, _this, "repair_vehicle"] call FUNC(canAddPlate);
            }'
            , // progress condition
            'alive _target && {(abs speed _target) < 1} && {[_target, _caller, "repair_vehicle"] call FUNC(canAddPlate)}'
            ] call FUNC(holdActionAdd)
        }, true, [], true] call CBA_fnc_addClassEventHandler;
    } forEach VEH_BASE_CLASSES;
};
