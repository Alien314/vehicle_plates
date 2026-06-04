#include "script_component.hpp"

params ["_veh", "_unit"];

// called from an ace progress bar action
if (_veh isEqualType []) then {
    _unit = _veh select 1;
    _veh = _veh select 0;
};

[_veh, _unit] call FUNC(addPlateActionCancel);

[QGVAR(addPlate), [_veh], [_veh]] call CBA_fnc_targetEvent;
