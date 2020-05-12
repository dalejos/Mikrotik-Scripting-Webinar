#Function addressType
#   Parametros:
#   $1: La IP.
#   Comentario: Funcion que retorna el tipo de direccion IP (UNKNOW, PRIVATE, RESERVED, PUBLIC)
#   Retorna: Un string.

:global addressType;
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

#Function addressType
#   Parametros:
#   $1: La IP.
#   Comentario: Funcion que retorna el tipo de direccion IP (UNKNOW, PRIVATE, RESERVED, PUBLIC) version 2.
#   Retorna: Un string.

:global addressType;
:set addressType do={
    :local ipAddress [:toip $1];
    :if ([:typeof $ipAddress] != "ip") do={
        :return "UNKNOW";
    }
    :local isPrivate (($ipAddress in 10.0.0.0/8) or ($ipAddress in 172.16.0.0/12) or ($ipAddress in 192.168.0.0/16));
    :if ($isPrivate) do={
        :return "PRIVATE";
    }
    :local isReserved (($ipAddress in 0.0.0.0/8) or ($ipAddress in 127.0.0.0/8) or ($ipAddress in 169.254.0.0/16) \
                        or ($ipAddress in 224.0.0.0/4) or ($ipAddress in 240.0.0.0/4));
    :if ($isReserved) do={
        :return "RESERVED";
    }
    :return "PUBLIC";
}











