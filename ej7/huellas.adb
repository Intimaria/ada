with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

procedure huellas is
type randRange is range 1..100;
package Rand_Int is new ada.numerics.discrete_random(randRange);
use Rand_Int;

task type servidor is 
    entry huella (test: in out randRange; codigo: out randRange);
end servidor;

type arrS is array (1..8) of servidor;
arrayS : arrS;

task admin;

task body servidor is 
    codigo: randRange;
    test : randRange;
    valor : randRange;
    gen : Generator;
begin 
    reset(gen);
    loop
        select 
            accept huella  (test: in out randRange; codigo: out randRange) do
                put_line("buscando");
                valor := random(gen);
                if test < valor then
                    test := valor;
                end if;
                put_line("Servidor, encontrada es:" & randRange'Image(valor));
                codigo := random(gen);
            end huella;
        end select;
    end loop;
end servidor;

task body admin is 
codigo:randRange;
test: randRange;
begin 
    test:=1;
    loop
      for i in 1..8 loop
               arrayS (i).huella(test, codigo);
               Put_Line("admin: Task:" & Integer'Image(i) & " codigo"
           & randRange'Image(codigo) & " test"
           & randRange'Image(test));
      end loop;
    end loop;
    put_line("huella:" & randRange'Image(test));
end admin;
begin
   null;
end huellas;
