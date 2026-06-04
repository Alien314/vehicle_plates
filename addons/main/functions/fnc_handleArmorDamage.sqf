#include "script_component.hpp"
params ["_vehicle", "_damage", "_ammo"];

private _receivedDamage = false;
private _plates = _vehicle getVariable [QGVAR(plates), []];
if (_plates isEqualTo []) exitWith {[_damage, _receivedDamage]};

if (GVAR(plateToughness)) then {
    _vehicle setVariable [QGVAR(hitTime), cba_missionTime];
};

switch (GVAR(armorHandlingMode)) do {
    case "arcade": {
        for "_i" from ((count _plates) - 1) to 0 step -1 do {
            private _plateIntegrity = _plates select _i;
            private _newDamage = _plateIntegrity - _damage;
            if (_newDamage > 0) then {
                // plate managed to soak the damage
                _plates set [_i, _newDamage];
                _damage = 0;
                break;
            } else {
                // the plate shattered bleeding damage into lower plates
                _damage = abs _newDamage;
                _plates deleteAt _i;
            };
        };
        _vehicle setVariable [QGVAR(plates), _plates];
        _receivedDamage = true;
        if (GVAR(plateToughness)) then {
            // [cba_missionTime] spawn FUNC(toughLoop);
        };
    };
    case "realism": {
        private _penetrationMult = GVAR(ammoPenCache) getOrDefaultCall [_ammo, {
            private _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_Caliber");
            private _mass = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_bulletMass");
            if (_caliber isEqualTo 0) then {
                // handle none ace configured bullets
                _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");
                _mass = (getNumber (configFile >> "CfgAmmo" >> _ammo >> "hit")) / 2;
            };
            _caliber * _mass;
        }, true];
        for "_i" from ((count _plates) - 1) to 0 step -1 do {
            private _plateIntegrity = _plates select _i;
            private _newDamage = _plateIntegrity - _damage;
            private _pennDamage = 0;
            private _mmPenned = (_damage * _penetrationMult) * (125 / 1000);
            if (_mmPenned > GVAR(plateThickness)) then {
                // plate was penetrated!
                _pennDamage = _damage * (1 - (GVAR(plateThickness) / _mmPenned));
            };
            if (_newDamage > 0) then {
                // plate managed to soak the damage
                _plates set [_i, _newDamage / (GVAR(maxPlateHealth) / _plateIntegrity)];
                _damage = _pennDamage;
            } else {
                // the plate shattered
                _damage = (abs _newDamage) + _pennDamage;
                _plates deleteAt _i;
            };
        };
        _vehicle setVariable [QGVAR(plates), _plates];
        if (GVAR(plateToughness)) then {
            // [cba_missionTime] spawn FUNC(toughLoop);
        };
        _receivedDamage = true;
    };
    default {
        // unhandled
    };
};

[_damage, _receivedDamage]
