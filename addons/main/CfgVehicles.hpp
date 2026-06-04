
// class CBA_Extended_EventHandlers;
class CfgVehicles {
    // Treatment items
    class Item_Base_F;
    class GVAR(plateItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Armor Plate";
        author = "diwako";
        model = "\A3\Weapons_F\DummyItemHorizontal.p3d";
        vehicleClass = "Items";
        class TransportItems {
            MACRO_ADDITEM(plate,1);
        };
    };

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
