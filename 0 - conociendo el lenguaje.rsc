#Comando de terminal

:put [/system identity get]

#Comentario

#Espacion en blanco (preferiblemente usarlos)
{ 
   :local a true;
   :local b false;	
   :put (a&&b);
   :put (a and b); 	
}

#Scope (alcance de una variable)

#Global Scope
:global telegramSendMessage;
:set telegramSendMessage do={
#   Local Scope
    :local telegramBotToken $1;
    :local telegramChatID $2;
    :local telegramMessage $3;
    :local isSend false;
    do {
        :local result [/tool fetch url=("https://api.telegram.org/bot" . $telegramBotToken . "/sendMessage\?chat_id=" . $telegramChatID \
            . "&text=" . $telegramMessage . "&parse_mode=Markdown") output=user as-value];
        :if (($result->"status") = "finished") do={
            :set isSend (($result->"data")~"\"ok\":true");
        }
    } on-error={
    }
    :return $isSend;
}

# Palabras reservadas

/system

    
and
or
in
menu item properties

#Delimitadore

()  []  {}  :   ;   $   / 

#Tipos de datos

num (number)	- 64bit signed integer, (9.223.372.036.854.775.807),
                  formato hexadecimal. Ejemplo 32, 0xA
bool (boolean)	- true o false.
str (string)	- secuenca de caracteres. Ejemplo "Esto es un string"
ip          	- IP address. Ejemplo 192.168.1.1
ip-prefix	    - IP prefix. Ejemplo 192.168.1.0/24
ip6         	- IPv6 address. Ejemplo 2001:0db8:85a3:0000:0000:8a2e:0370:7334
ip6-prefix	    - IPv6 prefix. Ejemplo 2001:0db8:85a3:0000:0000:0000:0000:0000/64
id (internal ID)- Id de cada item en un menu, hexadecimal, prefijo "*", secuencial
time        	- Fecha u hora. Ejemplo apr/29/2020, 01:00:00
array           - Secuencia de valores en un arreglo. Ejemplo {1;2;3},
                  {"token"<<="XXXXX-XXX";"id"=3598756}
nil             - Tipo de dato asignado a una varible sin valor especificado.

#Operadores

Aritmeticos     + - * / %
Relacional      < > = <= >= !=
Logicos         ! && and || or in
Operadores
bit a bit       ~ | ^ & << >>
Operadores de
concatenación   . ,
Otros
operadores      [] () $ ~ ->

#Comandos globales y operador global :

/            terminal  error    for      if     nothing  put      set      tobool  toip6  totime
:            delay     execute  foreach  len    parse    resolve  time     toid    tonum  typeof
environment  do        find     global   local  pick     return   toarray  toip    tostr  while 

/system

#Ciclos

do..while

:for index from=0 to=10 do={
    :put "Index: $index";
}

:foreach ip in={192.168.88.1;192.168.88.2;192.168.88.10} do={
    :put "Procesando IP: $ip";
}

#Condicinal if..else

 :if (true) do={
    :put "TRUE";
} else={
    :put "FALSE";
}

#Funciones

:global factorial;
:set factorial do={
    :global factorial;
    :local x [:tonum $1];
    :if ($x > 1) do={
        :return ($x * [$factorial ($x - 1)])
    }
    :if (($x = 0) or ($x = 1)) do={
        :return 1;
    }
    :return -1;
}

#Expresiones regulares

:put ("youtube.com"~"^.*(video|youtube|radio|music|dailymotion|deezer|laprese).+(com|es|com\\.ve|co\\.ve).*\$")
































