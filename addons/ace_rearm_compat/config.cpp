#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(armorPlate)};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"diw_vehicle_plates_main", "ace_rearm", "ace_repair"};
        author = "diwako";
        url = "";
        authorUrl = "";
        VERSION_CONFIG;
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
