do {
    :put "Cargando setInterfaceTaggetVLAN...";
    
    :global setInterfaceTaggetVLAN;
    :set setInterfaceTaggetVLAN do={
        :local bridgeName "$1";
        :local vlanIds [:toarray "$2"];
        :local interfaceNames [:toarray "$3"];
        :put "vlanIds: $[:tostr $vlanIds]";
        :put "interfaceNames: $[:tostr $interfaceNames]";
        :foreach vlanId in=$vlanIds do={
            :local id [/interface bridge vlan find where vlan-ids="$vlanId" dynamic=no];
            :if (([:len $id] = 0)) do={
                :local interfaceName "";
                :foreach iName in=$interfaceNames do={
                    :set interfaceName "$interfaceName,$iName";
                };
                do {
                    :put "Creando VLAN en: $bridgeName / $vlanId / $interfaceName";
                    /interface bridge vlan add bridge=$bridgeName vlan-ids=$vlanId tagged="$interfaceName";
                } on-error={
                    :put "ERROR creando VLAN en: $bridgeName / $vlanId / $interfaceName";
                }
            } else={
                :foreach iName in=$interfaceNames do={
                    :local tagged [/interface bridge vlan get $id tagged];
                    :local interfaceName "";
                    :foreach iTagged in=$tagged do={
                        :if ([:len $interfaceName] = 0) do={
                            :set interfaceName "$iTagged";
                        } else={
                            :set interfaceName "$interfaceName,$iTagged";
                        }
                    };
                    :if (!($interfaceName~$iName)) do={
                        :set interfaceName "$interfaceName,$iName";
                        /interface bridge vlan set $id tagged="$interfaceName";
                    }
                };
            }
        }
    };
    
    :put "Cargando setInterfacePVID...";
    :global setInterfacePVID;
    :global setInterfacePVID do={
        /interface bridge port set [find bridge=$1 interface=$2] pvid=$3;
    };
    
    :put "Cargando setBridgePVID...";
    :global setBridgePVID;
    :global setBridgePVID do={
        /interface bridge set [find name=$1] pvid=$2
    };
    
    :put "Cargando setRomonIdentity...";
    :global setRomonIdentity;
    :global setRomonIdentity do={
        /system identity set name=$1;
    };

    :put "Modulo cargado.";
    
} on-error={
    :put "ERROR cargando modulo.";
}