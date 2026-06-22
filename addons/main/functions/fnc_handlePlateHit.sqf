#include "script_component.hpp"

params ["_vehicle", "_hitPoint", "_hitIndex", "_selection", "_addedDamage", "_projectile", "_source", "_instigator"];

// filter ERA specifically because it's damage numbers are much higher and can wipe plates in a single hit
if ("era" in (toLower _hitPoint)) exitWith {true};

private _hitpointArmor = (getNumber (configOf _vehicle >> "HitPoints" >> _hitPoint >> "armor"));
private _invMass = 1 / getMass _vehicle;
if (_hitpointArmor > 0) then {
    _addedDamage = _addedDamage / (1 / _hitpointArmor);
};

_addedDamage = ((sqrt(_addedDamage * 20.0) / _invMass) / 100000) * 3.1622;

([_vehicle, _addedDamage, _projectile] call FUNC(handleArmorDamage)) params ["_restDamage", "_receivedDamage"];

if (!_receivedDamage || _restDamage <= 0) exitWith {true};
// private _restDamageOld = _restDamage;
_restDamage = _restDamage / 3.1622;
// _restDamage = _restDamage * 100000 / 20;
// _restDamage = (_restDamage * _restDamage) * _invMass;

if (_hitpointArmor > 0) then {
    _restDamage = _restDamage * (1 / _hitpointArmor);
};

private _ret = true;
 if ((_vehicle getVariable [QGVAR(aceVehicleDamageEH), -1]) isEqualTo -1) then {
    if (_selection != "") then {
        private _currentDamage = _vehicle getHitIndex _hitIndex;
        private _newDamage = _currentDamage + _restDamage;

        private _hit = toLowerANSI _hitPoint;
        if ("body" in _hit || "hull" in _hit) then {
            _newDamage = _newDamage min 0.89;
        };

        _vehicle setHitIndex [_hitIndex, _newDamage, true, _source, _instigator];
    } else {
        private _currentDamage = damage _vehicle;
        private _newDamage = (_currentDamage + _restDamage) min 0.89;

        _vehicle setHitPointDamage ["HitHull", _newDamage, true, _source, _instigator];
    };
} else {
    _this set [4, _restDamage];
    _ret = [_vehicle, _hitPoint, _hitIndex, _selection, _restDamage, _projectile, _source, _instigator] call ace_vehicle_damage_fnc_handleVehicleDamage;
};

_ret
