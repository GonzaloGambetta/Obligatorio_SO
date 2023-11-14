with ada.numerics.discrete_random;
with Ada.Text_IO; use ADA.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line;
with Ada.Strings;
with Ada.Task_Identification; use Ada.Task_Identification;

procedure ascensores is
   Cant_ascensores : Integer := 2;
   Cant_pisos : integer := 10;
   Cant_pedidos : integer := 15;

   type pedido is record 
      desde : Integer;
      hasta : Integer;
   end record;

   type listaPedidos is array (Integer range <>) of pedido;
   Pedidos : listaPedidos(1 .. Cant_pedidos);

   procedure llenarPedidos is
   begin
      for I in 1 .. Cant_pedidos loop
         pedidoAux : pedido;
         begin
            pedido1.desde := 1;
         end;
      end loop;
   end llenarPedidos;

   package counter is
      function get_next return integer;
    private
      data: integer := 0;
   end counter;
   package body counter is
      function get_next return integer is
         return_val: integer;
      begin
         return_val := data;
         data := data + 1;
      return return_val;
    end get_next;
  end counter;

   -- Hay filosofos numerados
   task type filosofo (numero: integer:= 1+( counter.get_next mod Cant_de_filosofos) ) is
   end;
   task body filosofo is
      id_tarea:Task_Id := Null_Task_Id;
      primerpalito, segundopalito, temp : integer;
   begin
      id_tarea:= Current_Task;
      Ada.Text_IO.Put_Line ("Soy el filosofo " & numero'Image & "  " & Image(id_tarea) );
      primerpalito:=numero;
      segundopalito:=((numero+1) mod Cant_de_filosofos);
      if segundopalito<primerpalito then
         temp:=segundopalito;
         segundopalito:=primerpalito;
         primerpalito:=temp;
      end if;
      for I in 1 .. Cant_Loops loop

      	Ada.Text_IO.Put_Line ("El fil�sofo "& numero'Image &" est� PENSANDO.");
               MisPalitos(primerpalito).tomar(numero);
               MisPalitos(segundopalito).tomar(numero);
      	Ada.Text_IO.Put_Line ("El fil�sofo "& numero'Image &" est� COMIENDO.");
               MisPalitos(segundopalito).liberar;
               MisPalitos(primerpalito).liberar;
      end loop;
      Ada.Text_IO.Put_Line ("El fil�sofo "& numero'Image &" TERMINO.");
   end filosofo;

    --- array de filosofos
    type Listafilosofos is array (Integer range <>) of filosofo;

    -- Mis filosofos
    Misfilosofos : Listafilosofos(1 .. Cant_de_Filosofos);




begin  --   filosofos
   delay 10.0; -- para esperar que todos terminen.
   null;
end filosofos;


