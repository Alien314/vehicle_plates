#include "..\script_component.hpp"

params ["_truck", "_player"];

private _vehicles = nearestObjects [_truck, ["AllVehicles"], ace_rearm_distance];
_vehicles = _vehicles select {
    _x != _truck
    && {!(_x isKindOf "CAManBase")}
    && {alive _x}
    && {!NO_PLATES_ALLOWED(_x)}
    && {!(_x getVariable ["ace_rearm_disabled", false])}
    && {([_truck, _player, "ace_rearm"] call EFUNC(main,canAddPlate))}
};

private _vehicleActions = [];
{
    private _vehicle = _x;
    private _displayName = getText (configOf _vehicle >> "displayName");
    private _distanceStr = (ACE_player distance _vehicle) toFixed 1;
    private _actionName = format ["%1 (%2m)", _displayName, _distanceStr];
    // Array of magazines that can be rearmed in the vehicle


    private _icon = getText(configOf _vehicle >> "Icon");
    if ((_icon select [0, 1]) != "\") then {
        _icon = "";
    };

    private _action = [
        _vehicle,
        _actionName,
        _icon,
        {call FUNC(takePlate)},
        {true},
        {},
        [GVAR(armorPlate), _vehicle]
    ] call ace_interact_menu_fnc_createAction;

    _vehicleActions pushBack [_action, [], _truck];
} forEach _vehicles;

_vehicleActions
