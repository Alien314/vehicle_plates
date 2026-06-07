class Cfg3DEN {
    class Object {
        class AttributeCategories {
            class GVAR(attributes) {
                displayName = CSTRING(Eden_options);
                collapsed = 1;
                class Attributes {
                    class GVAR(numMaxPlates) {
                        displayName = CSTRING(numMaxPlates_3den);
                        tooltip = CSTRING(numMaxPlates_3den_desc);
                        property = QUOTE(numMaxPlates);
                        control = "EditShort";
                        expression = QUOTE(if (_value >= 0) then {_this setVariable [ARR_3(QQGVAR(numPlates),round _value,true)]});
                        defaultValue = -1;
                        validate = "number";
                        // condition = "(1-objectBrain)*(1-objectAgent)";
                        condition = "objectVehicle";
                        typeName = "NUMBER";
                    };
                    class GVAR(fillPlates) {
                        displayName = CSTRING(fillPlates);
                        tooltip = CSTRING(fillPlates_desc);
                        property = QUOTE(fillPlates);
                        control = "CheckboxNumber";
                        expression = QUOTE(if (_value != 0) then {_this setVariable [ARR_2(QQGVAR(fillPlates),_value == 1)]});
                        defaultValue = 0;
                        value = 0;
                        condition = "objectVehicle";
                        typeName = "NUMBER";
                    };
                    class GVAR(plateToughnessRegenCount) {
                        displayName = CSTRING(plateToughnessRegenCount);
                        tooltip = CSTRING(plateToughnessRegenCount_3den_desc);
                        property = QUOTE(plateToughnessRegenCount);
                        control = "EditShort";
                        expression = QUOTE(if (_value >= 0) then {_this setVariable [ARR_3(QQGVAR(plateToughnessRegenCount),round _value,true)]});
                        defaultValue = -1;
                        validate = "number";
                        condition = "objectVehicle";
                        typeName = "NUMBER";
                    };
                };
            };
        };
    };
};
