#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
  #undef PREP
  #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
  #undef PREP
  #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif


#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = QGVAR(ITEM); \
    count = COUNT; \
}

#define VEH_BASE_CLASSES ["Car", "Tank", "Air", "Ship"]
#define MAX_VEH_PLATES(var) ((var) getVariable [QEGVAR(main,numPlates), 0])
#define NO_PLATES_ALLOWED(var) (var getVariable [QEGVAR(main,disabled), false] || {(var getVariable [QEGVAR(main,numPlates), 0]) isEqualTo 0})
