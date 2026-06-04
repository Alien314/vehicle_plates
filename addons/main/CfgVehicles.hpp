
// class CBA_Extended_EventHandlers;
class CfgVehicles {
    class Module_F;
    class GVAR(moduleBase): Module_F {
        author = CSTRING(category);
        category = "VPS";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
    };
    class GVAR(modulePlate): GVAR(moduleBase) {
        curatorCanAttach = 1;
        displayName = CSTRING(zeus_module_plate);
        function = QFUNC(modulePlate);
        icon = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa";
    };
};
