with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

Procedure huella is
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

    Task Servidor_Admin; 

    Task body Servidor is
        gen: Generator;
    Begin
        loop
        reset(gen);
        accept buscar (test: out randRange; codigo: out randRange) do
            put_line("soy un servidor buscando");
            test:= random(gen);
            codigo:= random(gen);
        end buscar;
        end loop;
    End Servidor;

    Task body Servidor_Admin is
        res, valor, test, cod, codigo: randRange;
    Begin
        loop
        Especialista.huella(valor);
        for i in 1..8 loop
            ArrS(i).buscar(test, codigo);
            if (test > valor) then
                res:= test;
                cod:= codigo;
            put_line("Servidor: " & integer'Image(i) &
            " huella encontrada es: " & randRange'Image(test)
            & " con codigo: " & randRange'Image(cod));
            end if;
        end loop;
        put_line("Admin, enviando huella: " & randRange'Image(res)
            & " con codigo: " & randRange'Image(cod));
        Especialista.resultado(res, cod);
        end loop;

    End Servidor_Admin;

    Task body Especialista is
        res_huella: randRange;
        codigo: randRange;
        gen : Generator;
        i : integer :=0;
    Begin
        reset(gen);
        while i < 3 loop
            for i in 1..16 loop
                put_line("especialista en loop");
                select
                    accept Huella (valor: out randRange) do
                        valor := random(gen);
                        put_line("especialista enviando huella");
                    end huella;
                or
                        accept resultado (res: in randRange; cod: in randRange) do
                            codigo:= cod;
                            res_huella:= res;
                            put_line("especialista recibiendo resultado");
                        end resultado;
                end select;
            end loop;
            put_line("especialista tiene huella: " & randRange'Image(res_huella)
                & " con codigo: " & randRange'Image(codigo));
            i := i + 1;
        end loop;
    End Especialista;
Begin
    null;
End huella;
