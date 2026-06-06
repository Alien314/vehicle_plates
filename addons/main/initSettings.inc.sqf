private _header = LLSTRING(category);
private _category = [_header, LLSTRING(subCategoryGeneral)];

[
    QGVAR(enable),
    "CHECKBOX",
    LLSTRING(enable),
    _category,
    true,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowHideArmor),
    "CHECKBOX",
    [LLSTRING(allowHideArmor), LLSTRING(allowHideArmor_desc)],
    _category,
    false,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(hideUiSeconds),
    "SLIDER",
    [LLSTRING(hideUiSeconds), LLSTRING(hideUiSeconds_desc)],
    _category,
    [1, 600, 5, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(plateColor),
    "COLOR",
    LLSTRING(plateColor),
    _category,
    [0.35, 0.35, 1, 0.8],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(vehicleBlacklist),
    "EDITBOX",
    [LLSTRING(vehicleBlacklist), LLSTRING(vehicleBlacklist_desc)],
    _category,
    "",
    true,
    {   params ["_value"];
        GVAR(vehBlacklist) = ([(_value call CBA_fnc_removeWhitespace), ","] call CBA_fnc_split) apply {toLowerANSI _x};
    },
    true
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryArmorPlates)];

[
    QGVAR(numMaxPlatesTank),
    "SLIDER",
    [LLSTRING(numMaxPlatesTank), LLSTRING(numMaxPlates_desc)],
    _category,
    [0, 10, 3, 0],
    true,
    {
        params ["_value"];
        GVAR(numMaxPlatesTank) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(numMaxPlatesAPC),
    "SLIDER",
    [LLSTRING(numMaxPlatesAPC), LLSTRING(numMaxPlates_desc)],
    _category,
    [0, 10, 2, 0],
    true,
    {
        params ["_value"];
        GVAR(numMaxPlatesAPC) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(numMaxPlatesCar),
    "SLIDER",
    [LLSTRING(numMaxPlatesCar), LLSTRING(numMaxPlates_desc)],
    _category,
    [0, 10, 2, 0],
    true,
    {
        params ["_value"];
        GVAR(numMaxPlatesCar) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(numMaxPlatesAir),
    "SLIDER",
    [LLSTRING(numMaxPlatesAir), LLSTRING(numMaxPlates_desc)],
    _category,
    [0, 10, 1, 0],
    true,
    {
        params ["_value"];
        GVAR(numMaxPlatesAir) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(numMaxPlatesShip),
    "SLIDER",
    [LLSTRING(numMaxPlatesShip), LLSTRING(numMaxPlates_desc)],
    _category,
    [0, 10, 1, 0],
    true,
    {
        params ["_value"];
        GVAR(numMaxPlatesShip) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(maxPlateHealth),
    "SLIDER",
    [LLSTRING(maxPlateHealth), LLSTRING(maxPlateHealth_desc)],
    _category,
    [1, 200, 20, 0],
    true,
    {
        params ["_value"];
        GVAR(maxPlateHealth) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(armorHandlingMode),
    "LIST",
    [LLSTRING(armorHandlingMode), LLSTRING(armorHandlingMode_desc)],
    _category,
    [["arcade", "realism"], [LLSTRING(armorHandlingMode_arcade), LLSTRING(armorHandlingMode_realism)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateThickness),
    "SLIDER",
    [LLSTRING(plateThickness), LLSTRING(plateThickness_desc)],
    _category,
    [0, 200, 40, 0],
    true,
    {
        params ["_value"];
        GVAR(plateThickness) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughness),
    "CHECKBOX",
    [LLSTRING(plateToughness), LLSTRING(plateToughness_desc)],
    _category,
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughnessAllowAI),
    "CHECKBOX",
    [LLSTRING(plateToughnessAllowAI), LLSTRING(plateToughnessAllowAI_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughnessRegenCount),
    "SLIDER",
    [LLSTRING(plateToughnessRegenCount), LLSTRING(plateToughnessRegenCount_desc)],
    _category,
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughnessDelay),
    "SLIDER",
    [LLSTRING(plateToughnessDelay), LLSTRING(plateToughnessDelay_desc)],
    _category,
    [1, 600, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughnessDelayBetweenPlates),
    "SLIDER",
    [LLSTRING(plateToughnessDelayBetweenPlates), LLSTRING(plateToughnessDelayBetweenPlates_desc)],
    _category,
    [1, 600, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateToughnessRegenSpeed),
    "SLIDER",
    [LLSTRING(plateRegenSpeed), LLSTRING(plateRegenSpeed_desc)],
    _category,
    [1, 600, 5, 1],
    true
] call CBA_fnc_addSetting;

_category = [_header, localize "str_a3_vehiclerepair1"];

[
    QGVAR(timeToAddPlate),
    "SLIDER",
    [LLSTRING(timeToAddPlate), LLSTRING(timeToAddPlate_desc)],
    _category,
    [0, 60, 10, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowPlateReplace),
    "CHECKBOX",
    [LLSTRING(allowPlateReplace), LLSTRING(allowPlateReplace_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireEngineer),
    "CHECKBOX",
    [LLSTRING(requireEngineer), LLSTRING(requireEngineer_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowAddPlateViaRepairVehicle),
    "CHECKBOX",
    [LLSTRING(allowAddPlateViaRepairVehicle), LLSTRING(allowAddPlateViaRepairVehicle_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;
