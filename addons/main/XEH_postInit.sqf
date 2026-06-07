#include "script_component.hpp"

if (is3DEN) exitWith {};
if !(GVAR(enabled)) exitWith {};

GVAR(trackedVehicles) = [];

["CBA_settingsInitialized", {
    {
        [_x, "Local", {
            params ["_veh", "_isLocal"];
            if (!alive _veh || {NO_PLATES_ALLOWED(_veh)}) exitWith {};
            if (_isLocal) exitWith {
                GVAR(trackedVehicles) pushBackUnique _veh;
            };

            private _plateHp = (_veh getVariable [QGVAR(plates), nil]);
            if !(isNil "_plateHp") then {
                [QGVAR(plateSync), [_veh, _plateHp, _veh getVariable [QGVAR(lastDamageTaken), -1]], [_veh]] call CBA_fnc_targetEvent;
            };
            _veh setVariable [QGVAR(lastDamageTaken), nil];
            _veh setVariable [QGVAR(syncedPlates), nil];
            _veh setVariable [QGVAR(lastToughnessTick), nil];
            GVAR(trackedVehicles) = GVAR(trackedVehicles) - [_veh];
        }, true, [], true] call CBA_fnc_addClassEventHandler;

        [_x, "Init", FUNC(initVehicle), true, [], true] call CBA_fnc_addClassEventHandler;
    } forEach VEH_BASE_CLASSES;
    if (hasInterface) then {
        [] call FUNC(initPlates);
    };
    if (GVAR(plateToughness)) then {
        [{call FUNC(toughnessPFH)}, 0.1] call CBA_fnc_addPerFrameHandler;
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
    params ["_veh", "_plateHp", ["_lastDamageTaken", -1]];
    _veh setVariable [QGVAR(plates), _plateHp];
    if (local _veh && _lastDamageTaken isNotEqualTo -1) then {
        _veh setVariable [QGVAR(lastDamageTaken), _lastDamageTaken];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(fillPlates), {
    params ["_veh"];
    if !(alive _veh) exitWith {};
    private _plates = [];
    for "_i" from 1 to MAX_VEH_PLATES(_veh) do {
        _plates pushBack GVAR(maxPlateHealth);
    };
    _veh setVariable [QGVAR(plates), _plates];
    [QGVAR(plateSync), [_veh, _plates]] call CBA_fnc_globalEvent;
}] call CBA_fnc_addEventHandler;

[QGVAR(editVehicle), {
    params ["_vehicle", "_args"];
    _args params ["_platesNum", "_toughPlatesNum"];

    _platesNum = round _platesNum;
    _toughPlatesNum = round _toughPlatesNum;

    if (_toughPlatesNum > -1) then {
        _vehicle setVariable [QGVAR(plateToughnessRegenCount), _toughPlatesNum, true];
    } else {
        _vehicle setVariable [QGVAR(plateToughnessRegenCount), nil, true];
    };


    if (MAX_VEH_PLATES(_vehicle) isNotEqualTo _platesNum) then {
        if ((count (_vehicle getVariable [QGVAR(plates), []])) > _platesNum) then {
            private _plates = (_vehicle getVariable [QGVAR(plates), []]) select [0, _platesNum];
            _vehicle setVariable [QGVAR(plates), _plates];
        };
        if (_platesNum > -1) then {
            _vehicle setVariable [QGVAR(numPlates), _platesNum, true];
        } else {
            _vehicle setVariable [QGVAR(numPlates), [_vehicle] call FUNC(getMaxPlatesForType), true];
        };

        [QGVAR(plateSync), [_vehicle, _vehicle getVariable [QGVAR(plates), []]], crew _vehicle] call CBA_fnc_targetEvent;
    };
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
    params ["_veh", ["_updateTime", 0.1]];
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

if !(isNil "zen_custom_modules_fnc_register") then {
    [LLSTRING(category), LLSTRING(zen_edit),
        {
            params ["", "_vehicle"];
            private _isObj = _vehicle isEqualType objNull;
            private _isPerson = (_isObj && {(_vehicle isKindOf "CAManBase")});
            if (_isPerson && _isObj) then {_vehicle = vehicle _vehicle};
            if (!_isObj || {isNull _vehicle} || {!alive _vehicle}) exitWith {
                [objNull, LLSTRING(zeus_invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
            };

            [LLSTRING(zen_edit), [
                    ["SLIDER", [LLSTRING(numMaxPlates_3den), LLSTRING(numMaxPlates_3den_desc)], [-1, MAX_PLATES_SETTING, MAX_VEH_PLATES(_vehicle), 0]],
                    ["SLIDER", [LLSTRING(plateToughnessRegenCount), LLSTRING(plateToughnessRegenCount_3den_desc)], [-1, MAX_PLATES_SETTING, (_vehicle getVariable [QGVAR(plateToughnessRegenCount), GVAR(plateToughnessRegenCount)]), 0]]
                ],
                {
                    params ["_dialog", "_args"];
                    _args params ["_vehicle"];

                    [QGVAR(editVehicle), [_vehicle, _dialog], _vehicle] call CBA_fnc_targetEvent;
                }, {}, [_vehicle]
            ] call zen_dialog_fnc_create;
        }
    ] call zen_custom_modules_fnc_register;
};

#include "userActions.inc.sqf"
