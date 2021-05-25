-- corregido -- 
with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

Procedure huella is
type randRange is range 1..9999;
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
    reset(gen);
    loop
        Especialista.huella(valor);
        put_line("Servidor, recibo huella" & randRange'image(valor));
        res:= random(gen);
        cod:= random(gen);
        Especialista.resultado(res, cod);
    end loop;
End Servidor;


Task body Especialista is
    mihuella,  miresultado : randRange;
    codigo, micodigo: randRange := 1;
    gen : Generator;
    N, whileIndex, counter: integer;
Begin
   reset(gen);
   N := 10;
   whileIndex := 0;
   while whileIndex < N loop
        counter := 1;
        mihuella := random(gen);
        put_line("Buscar huella:" & randRange'Image(mihuella));
        for i in 1..16 loop
            select
                when (counter < 9) =>
                    accept Huella (valor: out randRange) do
                    put_line("Enviando huella" & 
                        randRange'image(mihuella) & ", mensaje n." 
                        & integer'image(counter));
                        valor:= mihuella;
                        counter := counter + 1;
                    end Huella;
            or 
                accept resultado (res: in randRange; cod: in randRange) do
                    micodigo:=cod;
                    miresultado:=res;
                    put_line("Resultado de servidor es: "
                    & randRange'image(res) & " con cod: " 
                    & randRange'image(cod));
                end resultado;
            end select;
            if (miresultado > mihuella) then
                codigo:= micodigo;
                mihuella:= miresultado;
            end if;
        end loop;
            put_line("Mejor resultado es: " & randRange'Image(mihuella)
            & " con codigo: " & randRange'Image(codigo));
        whileIndex := whileIndex + 1;
    end loop;
End Especialista;
Begin
    null;
End huella;
