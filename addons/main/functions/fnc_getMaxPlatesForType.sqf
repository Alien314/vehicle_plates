#include "script_component.hpp"

params ["_vehicle"];

if (_vehicle isKindOf "Tank") then {
    GVAR(numMaxPlatesTank)
} else {
    if (_vehicle isKindOf "Car") then {
        [GVAR(numMaxPlatesCar), GVAR(numMaxPlatesAPC)] select (_vehicle isKindOf "Wheeled_Apc_F" || _vehicle isKindOf "gm_wheeled_APC_base")
    } else {
        if (_vehicle isKindOf "Air") then {
            GVAR(numMaxPlatesAir)
        } else {
            [0, GVAR(numMaxPlatesShip)] select (_vehicle isKindOf "Ship");
        };
    };
};
