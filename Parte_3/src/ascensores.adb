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
   Piso_actual1 : Integer := 1;
   Piso_actual2 : Integer := 1;
   Disponible1 : Boolean := True;
   Disponible2 : Boolean := True;

   subtype My_Range is Integer range 1 .. Cant_pisos;
   package Random_Numbers is new Ada.Numerics.Discrete_Random (My_Range);
   use Random_Numbers;
   Gen : Generator;

   type pedido is record 
      desde : Integer;
      hasta : Integer;
      atendido : Boolean := False;
   end record;

   type listaPedidos is array (Integer range <>) of pedido;
   Pedidos : listaPedidos(1 .. Cant_pedidos);
   
   procedure llenarPedidos is
      pedidoAux : pedido;
   begin
   for I in 1 .. Cant_pedidos loop
      begin
         Reset (Gen);
         pedidoAux.desde := Random(Gen);
         Reset (Gen);
         pedidoAux.hasta := Random(Gen);
         Pedidos(I) := pedidoAux;	
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
   
   task type ascensor (numero: integer:= 1+(counter.get_next mod Cant_ascensores)) is
      Entry pedir (desde : Integer; hasta : Integer);
      Entry liberar;
   end;
   task body ascensor is
      id_tarea:Task_Id := Null_Task_Id;
      Piso_actual : Integer;
      Disponible : Boolean;
      Demora : Integer;
   begin
      id_tarea:= Current_Task;
      Piso_actual := 1;
      Disponible := True;
      loop
         accept pedir(desde : Integer; hasta : Integer) do
            Put_Line("El ascensor " & numero'Image & " se mueve del piso " & Piso_actual'Image & " al " & desde'Image);
            Disponible := false;
            if numero = 1 then
               Disponible1 := false;
            else
               Disponible2 := false;
            end if;
            Demora := abs(Piso_actual - desde);
            for I in 1 .. Demora loop
               begin
                  delay 1.0;
               end;
            end loop;
            Piso_actual := desde;
            Put_Line("El ascensor " & numero'Image & " se mueve del piso " & Piso_actual'Image & " al " & hasta'Image);
            for I in 1 .. abs(Piso_actual - hasta) loop
               begin
                  delay 1.0;
               end;
            end loop;
            Piso_actual := hasta;
            Disponible := true;
            if numero = 1 then
               Piso_actual1 := Piso_actual;
               Disponible1 := True;
            else
               Piso_actual2 := Piso_actual;
               Disponible2 := True;
            end if;
            Disponible := true;
         end;
         accept liberar;
         Put_Line ("El ascensor "& numero'Image &" TERMINO");
      end loop;
   end ascensor;
   
   type listaAscensores is array (Integer range <>) of ascensor;
   Ascensores : listaAscensores(1 .. Cant_ascensores);
   
   task type gestor (numero: integer:= 1+(counter.get_next mod Cant_pedidos)) is
   end;
   task body gestor is
      id_tarea:Task_Id := Null_Task_Id;
      DistanciaA1 : Integer;
      DistanciaA2 : Integer;
   begin
      llenarPedidos;
      id_tarea:= Current_Task;
         if Disponible1 and Disponible2 then
            DistanciaA1 := abs(Piso_actual1 - Pedidos(numero).desde);
            DistanciaA2 := abs(Piso_actual2 - Pedidos(numero).desde);
            if DistanciaA1 < DistanciaA2 then
               Ascensores(1).pedir(Pedidos(numero).desde, Pedidos(numero).hasta);
               Ascensores(1).liberar;
            else
               Ascensores(2).pedir(Pedidos(numero).desde, Pedidos(numero).hasta);
               Ascensores(2).liberar;
            end if;
         elsif Disponible1 then
            Ascensores(1).pedir(Pedidos(numero).desde, Pedidos(numero).hasta);
            Ascensores(1).liberar;
         else
            Ascensores(2).pedir(Pedidos(numero).desde, Pedidos(numero).hasta);
            Ascensores(2).liberar;
         end if;
   end gestor;
   
   type listaGestores is array (Integer range <>) of gestor;
   Gestiones : listaGestores(1 .. Cant_pedidos);

begin
   null;
end ascensores;