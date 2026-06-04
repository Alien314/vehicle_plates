player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
    if !(isNull objectParent _unit) exitWith {};
    _unit addMagazine _magazine;
}];
