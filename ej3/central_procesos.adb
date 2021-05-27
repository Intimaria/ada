with Ada.Text_IO; use Ada.Text_IO;
-- 3. Se dispone de un sistema compuesto por 1 central y 2 procesos Los procesos envían señales a la central. La central comienza su ejecución tomando una señal del proceso 1, luego toma aleatoriamente señales de cualquiera de los dos indefinidamente Al recibir unnseñal de proceso 2, recibe señales del mismo proceso durante 3 minutos. El proceso 1 envía una señal que es considerada vieja (se deshecha) si en 2 minutos no fue recibida. El proceso 2 envía una señal, si no es recibida en ese instante espera 1 minuto y vuelve a mandarla (no se deshecha).
procedure hello is 
Task proceso1;
Task proceso2;

Task central is 
    entry p1(s1: in integer);
    entry p2(s2: in integer);
    entry finTiempo;
end central;

Task timer is 
    entry iniciar;
end timer;

Task body proceso1 is 
s1: integer  := 0;
begin
loop
    s1:= s1 + 1;
    select 
        central.p1(s1);
    else delay 6.0;
        put_line("espere un minuto y deshecho");
    end select;
end loop;
end proceso1;


Task body proceso2 is 
s2: integer := 20;
begin
loop
    select 
        central.p2(s2);
    else
        delay 0.01;
        put_line("espero dos minutos");
    end select;
end loop;
end proceso2;

Task body timer  is 
begin
    loop
        accept iniciar;
        delay 0.03;
        central.finTiempo;
    end loop;
end timer;
    

Task body central  is 
senal1: integer;
senal2: integer;
fin: boolean := false;
begin 
    accept p1(s1: in integer);
    loop
        select
            accept p1(s1: in integer) do 
                senal1 := s1;
                put_line("senal 1" & integer'image(senal1));
            end p1;
        or 
            accept p2(s2: in integer);
            timer.iniciar;
            put_line("iniciar timer");
            fin := false;
            while not fin loop
                select 
                    when finTiempo'count = 0 => 
                    accept p2(s2: in integer) do
                      senal2:= s2;
                      put_line("senal2: " & integer'image(senal2));
                    end p2;
                or
                    accept finTiempo do
                        fin := true;
                        put_line("fin tiempo");
                    end finTiempo;
                end select;
            end loop;
        or accept finTiempo;
        end select;
    end loop;
end central;

begin
  null;
end Hello;
