with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

-- Se quiere modelar la cola de un banco que a tiende un solo empleado, los clientes llegan y si esperan más de 10 minutos  se retiran.

procedure clientes_banco is
   type randRange is range 1..100;
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   
   task type cliente; 
   arrC: array (1..10) of cliente;
   
   task empleado is
      entry atencion (datos: in out randRange);
   end empleado;

   task body empleado is
      gen : Generator;
   begin
      reset(gen);
      loop
        accept atencion (datos: in out randRange ) do
            Put_Line("Atendi");
            datos := random(gen);
        end atencion;
      end loop;
   end empleado;
   
   task body cliente is 
      datos : randRange;
   begin
      datos := 1;
      select 
          empleado.atencion(datos);
          Put_Line("Me atendieron");
      or delay 2.0; 
          put_line("esperando");
      end select;
      put_line("como cliente ahora mis datos son:");
      Put_line(randRange'Image(datos));
  end cliente;
  
begin
   null;
end clientes_banco;
