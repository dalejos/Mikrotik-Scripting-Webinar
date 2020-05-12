:global config;
:if ([:typeof $config] != "array") do={
    :set $config [:toarray ""];
}

:local romonConfig [:toarray ""];

:set ($romonConfig->"SwitchCore") \
{\
    "romonId"="CC:00:00:00:00:02";\
    "romonUser"="admin";\
    "identity"="Switch Core";\
    "bridges"=\
    {\
        "bridge"=\
        {\
            "pvid"="1";\
            "ports"=\
            {\
                "ether1"={"pvid"="1"};\
                "ether2"={"pvid"="1"};\
                "ether3"={"pvid"="1"};\
                "ether4"={"pvid"="1"};\
                "ether5"={"pvid"="1"};\
                "ether6"={"pvid"="1"};\
                "ether7"={"pvid"="1"};\
                "ether8"={"pvid"="1"};\
                "ether9"={"pvid"="1"};\
                "ether10"={"pvid"="1"};\
                "ether11"={"pvid"="1"};\
                "ether12"={"pvid"="1"};\
                "ether13"={"pvid"="1"};\
                "ether14"={"pvid"="1"};\
                "ether15"={"pvid"="1"};\
                "ether16"={"pvid"="1"};\
                "ether17"={"pvid"="1"};\
                "ether18"={"pvid"="1"};\
                "ether19"={"pvid"="1"};\
                "ether20"={"pvid"="1"};\
                "ether21"={"pvid"="1"};\
                "ether22"={"pvid"="1"};\
                "ether23"={"pvid"="1"};\
                "ether24"={"pvid"="1"}\
            };\
            "vlans"=\
            {\
                "10,20,30,100"=\
                {\
                    "tagged"="ether21,ether22,ether23,ether24";\
                    "untagged"=""\
                };\
                "10"=\
                {\
                    "tagged"="";\
                    "untagged"=""\
                }\
            }\
        }\
    }\
};

:set ($romonConfig->"Switch1") \
{\
    "romonId"="CC:00:00:00:00:03";\
    "romonUser"="admin";\
    "identity"="Switch 1";\
    "bridges"=\
    {\
        "bridge"=\
        {\
            "pvid"="1";\
            "ports"=\
            {\
                "ether1"={"pvid"="1"};\
                "ether2"={"pvid"="1"};\
                "ether3"={"pvid"="1"};\
                "ether4"={"pvid"="1"};\
                "ether5"={"pvid"="1"};\
                "ether6"={"pvid"="1"};\
                "ether7"={"pvid"="1"};\
                "ether8"={"pvid"="1"};\
                "ether9"={"pvid"="1"};\
                "ether10"={"pvid"="1"};\
                "ether11"={"pvid"="1"};\
                "ether12"={"pvid"="1"};\
                "ether13"={"pvid"="1"};\
                "ether14"={"pvid"="1"};\
                "ether15"={"pvid"="1"};\
                "ether16"={"pvid"="1"};\
                "ether17"={"pvid"="1"};\
                "ether18"={"pvid"="1"};\
                "ether19"={"pvid"="1"};\
                "ether20"={"pvid"="1"};\
                "ether21"={"pvid"="1"};\
                "ether22"={"pvid"="1"};\
                "ether23"={"pvid"="1"};\
                "ether24"={"pvid"="1"}\
            };\
            "vlans"=\
            {\
                "10,20,30,100"=\
                {\
                    "tagged"="ether24";\
                    "untagged"=""\
                };\
                "10"=\
                {\
                    "tagged"="";\
                    "untagged"=""\
                }\
            }\
        }\
    }\
};

:set ($config->"romonConfig") $romonConfig;