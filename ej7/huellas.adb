with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

Procedure huellas is
type randRange is range 1..100;
package Rand_Int is new ada.numerics.discrete_random(randRange);
use Rand_Int;

Task Especialista is
    entry Huella (valor: out randRange);
    entry Resultado (res: in randRange; cod: in randRange);
End Especialista;

Task type Servidor is 
    entry buscar (test: out randRange; codigo: out randRange);
end Servidor;

ArrS: array (1..8) of Servidor;

Task type Servidor_Admin; 

Task body Servidor is
    gen: Generator;
Begin
    reset(gen);
    accept buscar (test: out randRange; codigo: out randRange) do
        test:= random(gen);
        codigo:= random(gen);
    end buscar;
End Servidor;

Task body Servidor_Admin is
    res, valor, test, cod, codigo: randRange;
Begin
    Especialista.huella(valor);
    for i in 1..8 loop
        ArrS(i).buscar(test, codigo);
        if (test <  valor) then
            res:= test;
            cod:= codigo;
        end if;
    end loop;
    Especialista.resultado(res, cod);
End Servidor_Admin;

Task body Especialista is
    res_huella: randRange;
    codigo: randRange;
    gen : Generator;
Begin
    for i in 1..16 loop
        select
            accept Huella (valor: out randRange) do
                valor := random(gen);
            end huella;
        or
            accept resultado (res: in randRange; cod: in randRange) do
                codigo:= cod;
                res_huella:= res;
            end resultado;
        end select;
    end loop;
End Especialista;
Begin
    null;
End huellas;
