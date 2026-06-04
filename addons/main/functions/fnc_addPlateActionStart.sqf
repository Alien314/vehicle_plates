#include "script_component.hpp"

params ["_veh", "_unit"];

private _currentWeapon = currentWeapon _unit;

if (_currentWeapon != "") then {
    _unit setVariable [QGVAR(selectedWeaponOnrepair), (weaponState _unit) select [0, 3]];
};

if (_currentWeapon == secondaryWeapon _unit) then {
    _unit selectWeapon (primaryWeapon _unit);
};

if (isNull objectParent _unit) then {
    if (currentWeapon _unit == "" && primaryWeapon _unit != "") then {
        _unit selectWeapon (primaryWeapon _unit);
    };

    if (stance _unit == "STAND") then {
        _unit setVariable [QGVAR(repairPrevAnimCaller), "amovpknlmstpsraswrfldnon"];
    } else {
        _unit setVariable [QGVAR(repairPrevAnimCaller), animationState _unit];
    };

    _unit playMove "Acts_carFixingWheel";
};

private _soundPosition = _unit modelToWorldVisualWorld (_unit selectionPosition "RightHand");
private _sound = getArray (configFile >> "CfgSounds" >> "Acts_carFixingWheel" >> "sound");
_sound params ["_fileName", ["_cfgVolume", 1], ["_pitch", 1]];
_fileName = _fileName select [1];
if !(toLowerANSI (_fileName select [count _fileName - 4]) in [".wav", ".ogg", ".wss"]) then {
    _fileName = _fileName + ".wss";
};
playSound3D [_fileName, objNull, false, _soundPosition, _cfgVolume, _pitch, 50];
