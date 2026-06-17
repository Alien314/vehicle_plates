#include "script_component.hpp"

if (!GVAR(plateToughness) || GVAR(trackedVehicles) isEqualTo []) exitWith {};

private _vehicle = GVAR(trackedVehicles) deleteAt 0;
if !(alive _vehicle && {local _vehicle}) exitWith {};

GVAR(trackedVehicles) pushBack _vehicle;

private _plates = _vehicle getVariable [QGVAR(plates), []];
private _countPlates = count _plates;
private _maxAllowedRegenCount = (_vehicle getVariable [QGVAR(plateToughnessRegenCount), GVAR(plateToughnessRegenCount)]) min (_vehicle getVariable [QGVAR(numPlates), 0]);
private _crew = (crew _vehicle) select {alive _x};

if (
    _maxAllowedRegenCount isEqualTo 0 ||
    {((_vehicle getVariable [QGVAR(lastDamageTaken), -(GVAR(plateToughnessDelay))]) + GVAR(plateToughnessDelay)) > cba_missionTime} ||
    {_crew isEqualTo []} ||
    {_maxAllowedRegenCount < _countPlates} ||
    {_maxAllowedRegenCount isEqualTo _countPlates && {(_plates findIf {_x isNotEqualTo GVAR(maxPlateHealth)}) isEqualTo -1}} ||
    {!GVAR(plateToughnessAllowAI) && {(_crew findIf {isPlayer _x}) isEqualTo -1}}
) exitWith {
    _vehicle setVariable [QGVAR(lastToughnessTick), nil];
};

private _time = time;
private _lastChecked = _vehicle getVariable [QGVAR(lastToughnessTick), _time - diag_deltaTime];
_vehicle setVariable [QGVAR(lastToughnessTick), _time];
private _hpToAdd = GVAR(maxPlateHealth) * ((_time - _lastChecked) / GVAR(plateToughnessRegenSpeed));

if (_countPlates isEqualTo 0) then {
    _plates pushBack 0;
};

private _plateIndex = _plates findIf {_x isNotEqualTo GVAR(maxPlateHealth)};

if (_plateIndex isEqualTo -1) then {
    _plateIndex = _plates pushBack 0;
};

private _newPlateHP = (_plates select _plateIndex) + _hpToAdd;

// systemChat format ["Adding HP: %1 | %2 -> %3 |", _hpToAdd, _plates select _plateIndex, GVAR(maxPlateHealth)];

private _sync = false;
if (_newPlateHP > GVAR(maxPlateHealth)) then {
    _newPlateHP = GVAR(maxPlateHealth);
    _sync = true;

    _vehicle setVariable [QGVAR(lastDamageTaken), cba_missionTime + GVAR(plateToughnessDelayBetweenPlates) -  GVAR(plateToughnessDelay)];
    _vehicle setVariable [QGVAR(lastToughnessTick), nil];
    // systemChat ("Waiting for between plate cooldown time: " + str GVAR(plateToughnessDelayBetweenPlates));
};

_plates set [_plateIndex, _newPlateHP];
_vehicle setVariable [QGVAR(plates), _plates];

if (!_sync) then {
    _sync = (time - (_vehicle getVariable [QGVAR(lastToughPlateSync), 0])) > 2;
};

if (_sync) then {
    systemChat format ["%1 [VPS DEBUG] Toughness regen syncing plates!", time];
    _vehicle setVariable [QGVAR(lastToughPlateSync), time];
    [QGVAR(plateSync), [_vehicle, _plates], crew _vehicle] call CBA_fnc_targetEvent;
} else {
    [QGVAR(updateUI), [_vehicle, 0]] call CBA_fnc_localEvent;
};
