#include "script_component.hpp"

if (is3DEN) exitWith {};
if !(GVAR(enabled)) exitWith {};

["CBA_settingsInitialized", {
    {
        [_x, "Local", {
            params ["_veh", "_isLocal"];
            if (_isLocal || {!alive _veh || {GVAR(numMaxPlates) isEqualTo 0}}) exitWith {};
            private _plateHp = (_veh getVariable [QGVAR(plates), nil]);
            if !(isNil "_plateHp") then {
                [QGVAR(plateSync), [_veh, _plateHp], [_veh]] call CBA_fnc_targetEvent;
            };
        }, true, [], true] call CBA_fnc_addClassEventHandler;

        [_x, "Init", FUNC(initVehicle), true, [], true] call CBA_fnc_addClassEventHandler;
    } forEach VEH_BASE_CLASSES;
    if (hasInterface) then {
        [] call FUNC(initPlates);
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(requestPlateSync), {
    params ["_vehicle", "_player"];
    [QGVAR(plateSync), [_vehicle, _vehicle getVariable [QGVAR(plates), []]], [_player]] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

[QGVAR(requestFullPlateSync), {
    params ["_vehicle"];
    private _actualPlates = _vehicle getVariable [QGVAR(plates), []];
    if ((_vehicle getVariable [QGVAR(syncedPlates), []]) isNotEqualTo _actualPlates) then {
        _vehicle setVariable [QGVAR(syncedPlates), _actualPlates];
        _vehicle setVariable [QGVAR(plates), _actualPlates, true];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(addPlate), {
    if !(local (_this select 0)) exitWith {};
    _this call FUNC(addPlate);
}] call CBA_fnc_addEventHandler;

[QGVAR(plateSync), {
    params ["_veh", "_plateHp"];
    _veh setVariable [QGVAR(plates), _plateHp];
}] call CBA_fnc_addEventHandler;

[QGVAR(switchMove), {(_this select 0) switchMove (_this select 1)}] call CBA_fnc_addEventHandler;

if !(hasInterface) exitWith {};
GVAR(fullWidth) = 10 * ( ((safeZoneW / safeZoneH) min 1.2) / 40);
GVAR(fullHeight) = 0.2 * ( ( ((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25);

{
    ctrlDelete (_x select 0);
    ctrlDelete (_x select 1);
} forEach (uiNamespace getVariable [QGVAR(plateControls), []]);
uiNamespace setVariable [QGVAR(plateControls), []];
ctrlDelete (uiNamespace getVariable [QGVAR(mainControl), controlNull]);

["CAManBase", "GetInMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];
    if (_unit isNotEqualTo ([] call CBA_fnc_currentUnit)) exitWith {};
    if !((toLowerANSI _role) in ["driver", "gunner", "commander"]) exitWith {};
    [] call FUNC(initPlates);
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "GetOutMan", {
    params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
    if (_unit isNotEqualTo ([] call CBA_fnc_currentUnit)) exitWith {};
    [objNull] call FUNC(updatePlateUi);
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "SeatSwitchedMan", {
    params [["_unit1", objNull], ["_unit2", objNull], "_vehicle"];
    private _player = [] call CBA_fnc_currentUnit;
    {
        if (local _vehicle) then {
            private _role = assignedVehicleRole _player;
            if (_role isNotEqualTo [] && {(toLowerANSI (_role select 0)) in ["driver", "turret"]}) then {
                [] call FUNC(initPlates);
            } else {
                [objNull] call FUNC(updatePlateUi);
            };
        } else {
            [QGVAR(requestPlateSync), [_vehicle, _player], [_vehicle]] call CBA_fnc_targetEvent;
        };
    } forEach ([_unit1, _unit2] select {(_x isEqualTo _player)});
}] call CBA_fnc_addClassEventHandler;

[QGVAR(plateSync), {
    params ["_veh"];
    [{
        params ["_veh"];
        [QGVAR(updateUI), [_veh]] call CBA_fnc_localEvent;
    }, [_veh]] call CBA_fnc_execNextFrame;
}] call CBA_fnc_addEventHandler;

[QGVAR(updateUI), {
    params ["_veh"];
    private _player = [] call CBA_fnc_currentUnit;
    if !(_player in _veh) exitWith {};
    private _role = assignedVehicleRole _player;
    if (_role isNotEqualTo [] && {(toLowerANSI (_role select 0)) in ["driver", "turret"]}) then {
        [_veh] call FUNC(updatePlateUi);
    } else {
        [objNull] call FUNC(updatePlateUi);
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(localHit), {
    params ["_veh", "_source", "_instigator"];
    [QGVAR(plateSync), [_veh, _veh getVariable [QGVAR(plates), []]], crew _veh] call CBA_fnc_targetEvent;

    if !(isNil "diw_armor_plates_main_fnc_showDamageFeedbackMarker") then {
        private _crew = ((fullCrew [_veh, "", false]) select {(toLowerANSI (_x select 1)) in ["driver", "commander", "gunner", "turret"]}) apply {_x select 0};
        if (_crew isNotEqualTo []) then {
            [QGVAR(showAPSFeedback), [_crew, _instigator], _crew] call CBA_fnc_targetEvent;
        };
    };
}] call CBA_fnc_addEventHandler;

if !(isNil "diw_armor_plates_main_fnc_showDamageFeedbackMarker") then {
    [QGVAR(showAPSFeedback), {
        params ["_crew", "_instigator"];
        private _player = [] call CBA_fnc_currentUnit;
        if (diw_armor_plates_main_showDamageMarker && {_player in _crew}) then {
            [_player, _instigator, 0] call diw_armor_plates_main_fnc_showDamageFeedbackMarker;
        };
    }] call CBA_fnc_addEventHandler;
};


#include "userActions.inc.sqf"
