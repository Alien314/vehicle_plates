#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(modulePlate), QGVAR(plateItem)};
        weapons[] = {QGVAR(plate)};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main"};
        author = "diwako";
        url = "";
        authorUrl = "";
        VERSION_CONFIG;
    };
};

#include "CfgEden.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
