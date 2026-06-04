#include "script_component.hpp"

if (is3DEN) exitWith {};
if !(EGVAR(main,enabled)) exitWith {};

["CBA_settingsInitialized", {
    if !(ace_rearm_enabled) exitWith {};
    if !(hasInterface) exitWith {};
    GVAR(configTypesAdded) = [];

    ["AllVehicles", "Init", FUNC(initSupplyVehicle), true, ["Man", "StaticWeapon"], true] call CBA_fnc_addClassEventHandler;
    ["ReammoBox_F", "Init", FUNC(initSupplyVehicle), true, [], true] call CBA_fnc_addClassEventHandler;
    ["House", "Init", FUNC(initSupplyVehicle), true, [], true] call CBA_fnc_addClassEventHandler;

    {
        _x call FUNC(initSupplyVehicle);
    } forEach allMissionObjects "Static";

    {
        [_x, "Init", {
            params ["_vehicle"];
            private _action = [
                QGVAR(addPlate),
                LELSTRING(main,addPlate),
                "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa",
                {call FUNC(addPlate)},
                {call FUNC(canAddPlate)},
                {},
                [],
                [0, 0, 0],
                9,
                [false, true, false, false, false]
            ] call ace_interact_menu_fnc_createAction;
            [_vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
        }, true, [], true] call CBA_fnc_addClassEventHandler;
    } forEach VEH_BASE_CLASSES;
}] call CBA_fnc_addEventHandler;
