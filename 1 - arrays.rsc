#Manejo de arrays

#Array sencillo
:global myArray {1; 2; 3; "cuatro"; 00:05:00};

:put ("La longitud del array es: " . [:len $myArray]);

:for i from=0 to=([:len $myArray]-1) do={
    :put ("El valor en $i: " . ($myArray->$i));
}

:foreach v in=$myArray do={
    :put "El valor es: $v";
}

:foreach k,v in=$myArray do={
    :put "El valor en $k: $v";
}

:put ("El valor en 0 es: " . $myArray->0);

:set ($myArray->0) 192.168.88.1;

:put ("El valor en 0 es: " . $myArray->0);

#Arrays con keys
:global myArray {"uno"=1; "dos"=2; "tres"=3; "4"="cuatro"; "hora"=00:05:00};

:put ("La longitud del array es: " . [:len $myArray]);

#No funciona con indice numerico
:for i from=0 to=([:len $myArray]-1) do={
    :put ("El valor en $i: " . ($myArray->$i));
}

:foreach v in=$myArray do={
    :put "El valor es: $v";
}

:foreach k,v in=$myArray do={
    :put "El valor en $k: $v";
}

#No funciona con indice numerico
:put ("El valor en 0 es: " . $myArray->0);

:put ("La hora es: " . $myArray->"hora");

:set ($myArray->"hora") 10:00:00;

:put ("El valor en 0 es: " . $myArray->"hora");

#Crear arreglo dinamicamente

:global myArray [:toarray ""];

:put ("La longitud del array es: " . [:len $myArray]);

:set ($myArray->"ip") 192.168.88.1;
:set ($myArray->"interface") "ether1";

:foreach k,v in=$myArray do={
    :put "El valor en $k: $v";
}

#Paradigma objetos

#                                                              
:global config {"telegram"={"botToken"="XXXXXXXXXX:XXXX_XXXXXXXXXXXXXXXX_XXXXX-XXXXXXX"; "chatID"="XXXXXXXXX"}};

:put ("Config: " . [:tostr $config]);
:put ("Telegram: " . [:tostr ($config->"telegram")]);
:put ("Telegram botToken: " . $config->"telegram"->"botToken");
:put ("Telegram chatID: " . $config->"telegram"->"chatID");

:global config { \
    "telegram"={ \
        "botToken"="XXXXXXXXXX:XXXX_XXXXXXXXXXXXXXXX_XXXXX-XXXXXXX"; \
        "chatID"="XXXXXXXXX" \
    }; \
    "dyndns"={ \
        "user"="dyndnsUser"; \
        "password"="dyndnsPassword"; \
        "host"="dyndnsHost"; \
        "interface"="publicInterface" \
    } \
};

{
    :local etherId [/interface ethernet find name="ether1"];
    :local etherName [/interface ethernet get $etherId name];
    :local defaultName [/interface ethernet get $etherId default-name];
    :local isRunning [/interface ethernet get $etherId running];
    :local etherSpeed [/interface ethernet get $etherId speed];

    :put "";
    :put "Informacion sobre la interface.";
    :put "Name        : $etherName";
    :put "Default name: $defaultName";
    :put "Running     : $isRunning";
    :put "Speed       : $etherSpeed";
    :put "";
}

{
    :local etherInfo [/interface ethernet get [find name="ether1"]];

    :put "";
    :put "Informacion sobre la interface.";
    :put ("Name        : " . $etherInfo->"name");
    :put "Default name: $($etherInfo->"default-name")";
    :put "Running     : $($etherInfo->"running")";
    :put "Speed       : $($etherInfo->"speed")";
    :put "";
}









:if ([:len [/system script job find script="script-telegram-active-users"]] > 1) do={
    :return 255;
}

:global lastUser;
:global messages;
:global telegramSendMessage;
:global telegramBotToken;
:global telegramChatID;

:local addressType;
:set addressType do={
    :local ipAddress [:toip $1];
    :if ([:len $ipAddress] = 0) do={
        :return "UNKNOW";
    }
    :local isPrivate  ((10.0.0.0 = ($ipAddress&255.0.0.0)) \
                        or (172.16.0.0 = ($ipAddress&255.240.0.0)) \
                        or  (192.168.0.0 = ($ipAddress&255.255.0.0)));
    :if ($isPrivate) do={
        :return "PRIVATE";
    }
    :local isReserved ((0.0.0.0 = ($ipAddress&255.0.0.0)) \
                        or (127.0.0.0 = ($ipAddress&255.0.0.0)) \
                        or (169.254.0.0 = ($ipAddress&255.255.0.0)) \
                        or (224.0.0.0 = ($ipAddress&240.0.0.0)) \
                        or (240.0.0.0 = ($ipAddress&240.0.0.0)));
    :if ($isReserved) do={
        :return "RESERVED";
    }
    :return "PUBLIC";
}

:local identity [/system identity get name];

:foreach id in=[/user active find] do={
    :local lastIndex [:tonum ("0x" . [:pick $id 1 [:len $id]])];
    :if ($lastUser < $lastIndex) do={
        :set lastUser $lastIndex;
        :local userData [/user active get $id];
        :local name ($userData->"name");
        :local when ($userData->"when");
        :local address ($userData->"address");
        :local via ($userData->"via");
        :local ipType [$addressType $address];
        :if ($ipType="PUBLIC") do={
            :local lUrl "http://ip-api.com/csv/$address?fields=status,message,country,countryCode,as,asname,query";
            :local result [/tool fetch url=$lUrl mode=http as-value output=user];
            :local arrayResult [:toarray ($result->"data")];
            :if ([:typeof $arrayResult] = "array") do={
                :if ([:pick $arrayResult 0] = "success") do={
                    :set ipType "country: *$($arrayResult->2) - $($arrayResult->1)*%0A\
                                 as: *$($arrayResult->3)*";
                }
            }
        }
        :set ($messages->"id-$lastIndex") "*$identity*%0A\
                                           at: *$when*%0A\
                                           user: *$name*%0A\
                                           from: *$address*%0A\
                                           via: *$via*%0A\
                                           $ipType";
    }
}

:foreach id,message in=$messages do={
    :local send [$telegramSendMessage $telegramBotToken $telegramChatID $message];
    
    :if ($send) do={
        :set ($messages->"$id");
    }
}