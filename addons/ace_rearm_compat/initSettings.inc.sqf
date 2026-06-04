private _header = LELSTRING(main,category);
private _category = [_header, localize "str_a3_vehiclerepair1"];

[
    QGVAR(allowAddPlateViaAceRearm),
    "CHECKBOX",
    [LLSTRING(allowAddPlateViaAceRearm), LLSTRING(allowAddPlateViaAceRearm_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;
