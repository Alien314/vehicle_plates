#include "..\script_component.hpp"

if !(ace_rearm_enabled) exitWith {};
if !(hasInterface) exitWith {};

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

private _typeOf = typeOf _vehicle;
private _configOf = configOf _vehicle;

private _configSupply = getNumber (_configOf >> "ace_rearm_defaultSupply");
if (_configSupply == 0) then {
    _configSupply = getNumber (_configOf >> "transportAmmo");
};
private _isSupplyVehicle = _vehicle getVariable ["ace_rearm_isSupplyVehicle", false];
private _oldRearmConfig = isClass (_configOf >> "ACE_Actions" >> "ACE_MainActions" >> "ace_rearm_takeAmmo");
TRACE_3("",_configSupply,_isSupplyVehicle,_oldRearmConfig);

if ((_configSupply <= 0) && {!_isSupplyVehicle} && {!_oldRearmConfig}) exitWith {}; // Ignore if not enabled
if ((_oldRearmConfig || {_configSupply > 0}) && {_typeOf in GVAR(configTypesAdded)}) exitWith {}; // Only add class actions once
if (_oldRearmConfig || {_configSupply > 0}) then {GVAR(configTypesAdded) pushBack _typeOf};

private _actionTakePlate = [
    QGVAR(takePlate),
    // localize "str_ui_abar",
    LLSTRING(takeAction),
    "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa",
    {},
    {call ace_rearm_fnc_canTakeAmmo},
    {call FUNC(addRearmActions)}
] call ace_interact_menu_fnc_createAction;

if (_oldRearmConfig || {_configSupply > 0}) then {
    if (_oldRearmConfig) then {
        WARNING_1("Actions already present on [%1].  Old Compat PBO?",_typeOf);
    } else {
        [_typeOf, 0, ["ACE_MainActions"], _actionTakePlate] call ace_interact_menu_fnc_addActionToClass;
    };
} else {
    if (_vehicle getVariable [QGVAR(objectActionsAdded), false]) exitWith {};
    _vehicle setVariable [QGVAR(objectActionsAdded), true];
    [_vehicle, 0, ["ACE_MainActions"], _actionTakePlate] call ace_interact_menu_fnc_addActionToObject;
};
