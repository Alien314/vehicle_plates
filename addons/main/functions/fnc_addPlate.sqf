#include "script_component.hpp"
params ["_vehicle"];

private _plates = _vehicle getVariable [QGVAR(plates), []];

if (_plates isNotEqualTo []) then {
    // get last plate, it might be already damaged
    private _count = count _plates;
    _plates sort false;
    private _lastPlate = _plates deleteAt (_count - 1);
    _plates pushBack GVAR(maxPlateHealth);
    if (_count < MAX_VEH_PLATES(_vehicle)) then {
        // add the last plate back
        _plates pushBack _lastPlate;
    };
    _plates sort false;
} else {
    _plates pushBack GVAR(maxPlateHealth);
};

_vehicle setVariable [QGVAR(syncedPlates), _plates];
_vehicle setVariable [QGVAR(plates), _plates, true];
[QGVAR(plateSync), [_vehicle, _plates], crew _vehicle] call CBA_fnc_targetEvent;
