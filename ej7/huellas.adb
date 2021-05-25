-- corregido -- 
with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

Procedure hello is
type randRange is range 1..100;
package Rand_Int is new ada.numerics.discrete_random(randRange);
use Rand_Int;

Task Especialista is
    entry Huella (valor: out randRange);
    entry Resultado (res: in randRange; cod: in randRange);
End Especialista;

Task type Servidor;

arrayS: array (1..8) of Servidor;

Task body Servidor is
    gen: Generator;
    res, valor, cod : randRange;
Begin
    loop
        Especialista.huella(valor);
        put_line("soy un servidor buscando por huella:" & randRange'image(valor));
        reset(gen);
        res:= random(gen);
        cod:= random(gen);
        put_line("servidor: huella encontrada es: " & randRange'Image(res)
         & " con codigo: " & randRange'Image(cod));
        Especialista.resultado(res, cod);
    end loop;
End Servidor;


Task body Especialista is
    valor : randRange;
    codigo: randRange := 1;
    gen : Generator;
    i,j: integer :=0;
    counter : integer;
Begin
   while j < 3 loop
        counter := 0;
        valor := random(gen);
        put_line("especialista huella:" & randRange'Image(valor));
        for i in 1..16 loop
            select
                when (counter < 9) =>
                    accept Huella (valor: out randRange) do
                        put_line("especialista enviando huella");
                    end huella;
            or 
                accept resultado (res: in randRange; cod: in randRange) do
                    if (res > valor) then
                        codigo:= cod;
                        valor:= res;
                    end if;
                    counter := counter + 1;
                put_line("especialista recibiendo mensaje" & integer'image(counter) & " res: "
                    & randRange'image(res) & "cod" 
                    & randRange'image(cod));
                end resultado;
            end select;
        end loop;
        put_line("especialista tiene huella: " & randRange'Image(valor)
            & " con codigo: " & randRange'Image(codigo));
        j:= j + 1;
        put_line("while loop: " & integer'image(j));
    end loop;
End Especialista;
Begin
    null;
End hello;
