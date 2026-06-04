#include "script_component.hpp"
if !(hasInterface) exitWith {};
private _display = findDisplay 46;

if (isNull _display) exitWith {
    [FUNC(initPlates)] call CBA_fnc_execNextFrame;
};

private _ctrlGroup = uiNamespace getVariable [QGVAR(mainControl), controlNull];

if (isNull _ctrlGroup) then {
    _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", 65481];
    uiNamespace setVariable [QGVAR(mainControl), _ctrlGroup];

    private _ctrlx = (profileNamespace getVariable ["IGUI_GRID_VEHICLE_X", (safeZoneX + 0.5 * ( ((safeZoneW / safeZoneH) min 1.2) / 40))]);
    // private _ctrly = (profileNamespace getVariable ["IGUI_GRID_VEHICLE_Y", (safeZoneY + 0.5 * ( ( ((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))]);
    private _ctrly = 3.3 * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ["IGUI_GRID_VEHICLE_Y", (safeZoneY + 0.5 * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))])+ // Y pos of toggles background
        GVAR(fullHeight) + // height of our own control
        ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + // height vehicle title
        0;
    _ctrlGroup ctrlSetPosition [_ctrlx, _ctrly, GVAR(fullWidth), GVAR(fullHeight)];
    _ctrlGroup ctrlSetTextColor [1, 1, 1, 1];
    _ctrlGroup ctrlSetBackgroundColor [1, 0, 0, 0];
    _ctrlGroup ctrlSetText "Group";
    _ctrlGroup ctrlCommit 0;
};

private _plateCtrls = uiNamespace getVariable [QGVAR(plateControls), []];
private _count = count _plateCtrls;
private _player = [] call CBA_fnc_currentUnit;

private _maxPlates = MAX_VEH_PLATES(vehicle _player);

if (_count isNotEqualTo _maxPlates) then {
    {
        ctrlDelete (_x select 0);
        ctrlDelete (_x select 1);
    } forEach (uiNamespace getVariable [QGVAR(plateControls), []]);
    uiNamespace setVariable [QGVAR(plateControls), []];
    _plateCtrls = [];
    if ((_maxPlates max 0) isEqualTo 0) exitWith {};

    private _width = GVAR(fullWidth) / _maxPlates;
    private _innerWidth = _width * 0.9;
    private _padding = (_width - _innerWidth) / 2;
    private _height = GVAR(fullHeight);

    for "_i" from 0 to (_maxPlates - 1) do {
        private _ctrlBack = _display ctrlCreate ["RscText", -1, _ctrlGroup];
        _ctrlBack ctrlSetPosition [_padding + _width * _i, 0, _innerWidth, _height];
        _ctrlBack ctrlSetTextColor [1, 1, 1, 0];
        _ctrlBack ctrlSetBackgroundColor [
            profileNamespace getVariable ['igui_bcg_RGB_R', 0],
            profileNamespace getVariable ['igui_bcg_RGB_G', 0],
            profileNamespace getVariable ['igui_bcg_RGB_B', 0],
            profileNamespace getVariable ['igui_bcg_RGB_A', 0.33]
        ];
        _ctrlBack ctrlCommit 0;
        private _ctrl = _display ctrlCreate ["RscText", -1, _ctrlGroup];
        _ctrl setVariable [QGVAR(innerWidth), _innerWidth];
        _ctrl ctrlSetPosition [_padding + _width * _i, 0, 0, _height];
        _ctrl ctrlSetTextColor [1, 1, 1, 0];
        _ctrl ctrlSetBackgroundColor GVAR(plateColor);
        _ctrl ctrlCommit 0;
        _plateCtrls pushBack [_ctrl, _ctrlBack];
    };

    uiNamespace setVariable [QGVAR(plateControls), _plateCtrls];
};

[objectParent _player] call FUNC(updatePlateUi);
