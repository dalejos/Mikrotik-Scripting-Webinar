#Version: 3.0 alpha
#Fecha: 22-03-2020
#RouterOS 6.46.4 y superior.
#Comentario: 

:global toSafeRomonCommand;
:set toSafeRomonCommand do={
    :local command $1;
    :local safeCommand "";
    :local lastLetter "";
    :local currentLetter "";
    :local hexChar "";
    :for i from=0 to=[:len $command] do={
        :set currentLetter [:pick $command $i];
        :if (!(($currentLetter = "\r") or ($currentLetter = "\n"))) do={
            :set safeCommand "$safeCommand$currentLetter";
        }
        :set lastLetter $currentLetter;
    }
    :return $safeCommand;
}

#Function executeRomonCommand
#   Parametros:
#   $1: romon address
#   $2: romon user
#   $3: command
#   Comentario:
#   Retorna:

:global executeRomonCommand;
:set executeRomonCommand do={
    /tool romon ssh address=$1 user=$2 command=$3;
}

:global loadRomonLibrary;
:set loadRomonLibrary do={
    :global executeRomonCommand;
    :global toSafeRomonCommand;
    :local romonId $1;
    :local romonUser $2;
    :local scripName $3;
    :local romonCommand [$toSafeRomonCommand [/system script get [find name=$scripName] source]];
    $executeRomonCommand $romonId $romonUser $romonCommand;
}

#Function setRomonIdentity
#   Parametros:
#   $1: romon address
#   $2: romon user
#   $3: identity
#   Comentario:
#   Retorna:

:global setRomonIdentity;
:set setRomonIdentity do={
    :global executeRomonCommand;
    :local command "\$setRomonIdentity \"$3\";";
    $executeRomonCommand $1 $2 $command;
}

#Function setInterfacePVID
#   Parametros:
#   $1: romon address
#   $2: romon user
#   $3: brigge
#   $4: interface
#   $5: pvid
#   Comentario:
#   Retorna:

:global setInterfacePVID;
:set setInterfacePVID do={
    :global executeRomonCommand;
    :local command "\$setInterfacePVID \"$3\" \"$4\" \"$5\";";
    $executeRomonCommand $1 $2 $command;
}

#Function setBridgePVID
#   Parametros:
#   $1: romon address
#   $2: romon user
#   $3: brigge
#   $4: pvid
#   Comentario:
#   Retorna:

:global setBridgePVID;
:set setBridgePVID do={
    :global executeRomonCommand;
    :local command "\$setBridgePVID \"$3\" \"$4\";";
    $executeRomonCommand $1 $2 $command;
}

#Function setInterfaceTaggetVLAN
#   Parametros:
#   $1: romon address
#   $2: romon user
#   $3: bridge
#   $4: interfaces
#   $5: vlans
#   Comentario:
#   Retorna:

:global setInterfaceTaggetVLAN;
:set setInterfaceTaggetVLAN do={
    :global executeRomonCommand;
    :local command "\$setInterfaceTaggetVLAN \"$3\" \"$4\" \"$5\";";
    $executeRomonCommand $1 $2 $command;
}

:global applyRomonConfig;
:set applyRomonConfig do={
    :global config;
    :global loadRomonLibrary;
    :global setRomonIdentity;
    :global setBridgePVID;
    :global setInterfacePVID;
    :global setInterfaceTaggetVLAN;
    
    :local romonConfig ($config->"romonConfig");
    
    :foreach id,romonItem in=$romonConfig do={
        :put "";
        :put "Id       : $id";
        :put "romonId  : $($romonItem->"romonId")";
        :put "romonUser: $($romonItem->"romonUser")";
        :put "identity : $($romonItem->"identity")";
        $loadRomonLibrary ($romonItem->"romonId") ($romonItem->"romonUser") "module-romon-client";
        $setRomonIdentity ($romonItem->"romonId") ($romonItem->"romonUser") ($romonItem->"identity");
        
        :foreach bridgeName,bridgeItem in=($romonItem->"bridges") do={
            :put "";
            :put "    bridge  : $bridgeName";
            :put "    PVID    : $($bridgeItem->"pvid")";
            $setBridgePVID ($romonItem->"romonId") ($romonItem->"romonUser") $bridgeName ($bridgeItem->"pvid");

            :foreach etherName,etherItem in=($bridgeItem->"ports") do={
                :put "        ether: $etherName, PVID: $($etherItem->"pvid")";
                $setInterfacePVID ($romonItem->"romonId") ($romonItem->"romonUser") $bridgeName $etherName ($etherItem->"pvid");
            }
            :foreach vlans,vlanItem in=($bridgeItem->"vlans") do={
                :put "        vlans: $vlans, tagged: $($vlanItem->"tagged")";
                $setInterfaceTaggetVLAN ($romonItem->"romonId") ($romonItem->"romonUser") $bridgeName $vlans ($vlanItem->"tagged");
            }
        }    
    }
}

:global showRomonConfig;
:set showRomonConfig do={
    :global config;
    :local romonConfig ($config->"romonConfig");
    
    :foreach id,romonItem in=$romonConfig do={
        :put "";
        :put "Id       : $id";
        :put "romonId  : $($romonItem->"romonId")";
        :put "romonUser: $($romonItem->"romonUser")";
        :put "identity : $($romonItem->"identity")";
        
        :foreach bridgeName,bridgeItem in=($romonItem->"bridges") do={
            :put "";
            :put "    bridge  : $bridgeName";
            :put "    PVID    : $($bridgeItem->"pvid")";

            :foreach etherName,etherItem in=($bridgeItem->"ports") do={
                :put "        ether: $etherName, PVID: $($etherItem->"pvid")";
            }
            :foreach vlans,vlanItem in=($bridgeItem->"vlans") do={
                :put "        vlans: $vlans, tagged: $($vlanItem->"tagged")";
            }
        }    
    }
}