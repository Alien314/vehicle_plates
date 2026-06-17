#include "script_component.hpp"

params ["_vehicle", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];

if !(local _vehicle) exitWith {};

if !(alive _vehicle) exitWith {
    private _handleDamageEH = _vehicle getVariable QGVAR(handleDamage);

    if !(isNil "_handleDamageEH") then {
        _vehicle removeEventHandler ["HandleDamage", _handleDamageEH];
    };
    nil
};

private _currentDamage = if (_selection != "") then {
    _vehicle getHitIndex _hitIndex
} else {
    damage _vehicle
};
private _retDamage = _currentDamage;

if (_context == 0 && {(abs (_damage - _currentDamage - 1)) < 0.001 && _projectile == "" && isNull _source && isNull _instigator}) exitWith {_damage};

// ace vehicle damage compat
if !(_projectile in ["ace_ammoExplosion", "ACE_ammoExplosionLarge"]) then {
    // check if vehicle has plates
    private _plateValue = 0;
    {
        _plateValue = _plateValue + _x;
    } forEach (_vehicle getVariable [QGVAR(plates), []]);
    if (_plateValue > 0) then {
        if (_damage <= 0 || {"#light" in _hitPoint}) exitWith {};
        private _hitHash = _vehicle getVariable QGVAR(hitHash);
        private _currentFrameArray = _hitHash getOrDefault [diag_frameNo, [], true];
        if (_currentFrameArray isEqualTo []) then {
            [{
                params ["_vehicle", "_processingFrame"];
                [{
                    params ["_vehicle", "", "_source", "_instigator"];
                    [QGVAR(localHit), [_vehicle, [_source, _instigator] select (isNull _source)]] call CBA_fnc_localEvent;
                }, _this] call CBA_fnc_execNextFrame;

                private _hitHash = _vehicle getVariable QGVAR(hitHash);
                private _hitArray = _hitHash deleteAt _processingFrame;

                if (_hitArray isEqualTo []) exitWith {};

                // Start from newest damage and work backwards
                {
                    _x params ["_vehicle", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

                    private _currentDamage = if (_selection != "") then {
                        _vehicle getHitIndex _hitIndex
                    } else {
                        damage _vehicle
                    };

                    private _addedDamage = _damage - _currentDamage;

                    if !([_vehicle, _hitPoint, _hitIndex, _selection, _addedDamage, _projectile, _source, _instigator] call FUNC(handlePlateHit)) exitWith {};
                } forEachReversed _hitArray;
            }, [_vehicle, diag_frameNo, _source, _instigator]] call CBA_fnc_execNextFrame;
        };

        _currentFrameArray pushBack _this;
    } else {
        // check if ace vehicle damage is in play, if not let the engine handle it
        if ((_vehicle getVariable [QGVAR(aceVehicleDamageEH), -1]) isEqualTo -1) then {
            _retDamage = nil;
        } else {
            _retDamage = _this call ace_vehicle_damage_fnc_handleDamage;
        };
    };
    if (_context isEqualTo 2) then {
        _vehicle setVariable [QGVAR(lastDamageTaken), cba_missionTime];
    };
};

_retDamage
