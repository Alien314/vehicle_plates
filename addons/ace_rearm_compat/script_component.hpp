#define COMPONENT ace_rearm_compat
#define COMPONENT_BEAUTIFIED ACE Rearm Compat
#include "\z\diw_vehicle_plates\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
  #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_MAIN
  #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\diw_vehicle_plates\addons\main\script_macros.hpp"

#define REARM_HOLSTER_WEAPON \
    if (currentWeapon _unit != "") then { \
        _unit setVariable ["ace_rearm_selectedWeaponOnRearm", (weaponState _unit) select [0, 3]]; \
    }; \
    TRACE_2("REARM_HOLSTER_WEAPON",_unit,currentWeapon _unit); \
    _unit action ["SwitchWeapon", _unit, _unit, 299];

#define REARM_UNHOLSTER_WEAPON \
    private _weaponSelect = _unit getVariable "ace_rearm_selectedWeaponOnRearm"; \
    if (!isNil "_weaponSelect") then { \
        TRACE_2("REARM_UNHOLSTER_WEAPON",_unit,_weaponSelect); \
        _unit selectWeapon _weaponSelect; \
        _unit setVariable ["ace_rearm_selectedWeaponOnRearm", nil]; \
    };
