with ada.numerics.discrete_random;
with Ada.Text_IO; use ADA.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line;
with Ada.Strings;
with Ada.Task_Identification; use Ada.Task_Identification;

procedure ascensores is
   Cant_ascensores : Integer := 2;
   Cant_pisos : Integer := 10;
   Cant_pedidos : integer := 15;
   Piso_actual1 : Integer := 1;
   Piso_actual2 : Integer := 1;
   Disponible1 : Boolean := True;
   Disponible2 : Boolean := True;
   Cont_pedidos : Integer := 1;

   subtype My_Range is Integer range 1 .. Cant_pisos;
   package Random_Numbers is new Ada.Numerics.Discrete_Random (My_Range);
   use Random_Numbers;
   Gen : Generator;

   type pedido is record 
      desde : Integer;
      hasta : Integer;
 
   end record;

   type listaPedidos is array (Integer range <>) of pedido;
   Pedidos : listaPedidos(1 .. Cant_pedidos);
   
   procedure llenarPedidos is
      pedidoAux : pedido;
   begin
      for I in 1 .. Cant_pedidos loop
         reset(Gen);
         pedidoAux.desde := Random(Gen);
         reset(Gen);
         pedidoAux.hasta := Random(Gen);
         Pedidos(I) := pedidoAux;
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
   end;
   task body ascensor is
      id_tarea:Task_Id := Null_Task_Id;
      Piso_actual : Integer := 1;
      Disponible : Boolean;
      Demora : Integer;
   begin
      id_tarea:= Current_Task;
      loop
         accept pedir(desde : Integer; hasta : Integer) do
            Cont_pedidos := Cont_pedidos + 1;
            Put_Line("El ascensor " & numero'Image & " se mueve del piso " & Piso_actual'Image & " al " & desde'Image);
            Disponible := false;
            if numero = 1 then
               Disponible1 := Disponible;
            else
               Disponible2 := Disponible;
            end if;
            Demora := abs(Piso_actual - desde);
            delay Duration(Demora);
            Piso_actual := desde;
            Put_Line("El ascensor " & numero'Image & " se mueve del piso " & Piso_actual'Image & " al " & hasta'Image);
            Demora := abs(Piso_actual - hasta);
            delay Duration(Demora);
            Piso_actual := hasta;
            Disponible := true;
            if numero = 1 then
               Disponible1 := Disponible;
               Piso_actual1 := Piso_actual;
            else
               Disponible2 := Disponible;
               Piso_actual2 := Piso_actual;
            end if;
            Put_Line ("El ascensor "& numero'Image &" TERMINO");
         end;
      end loop;
   end ascensor;
   
   type listaAscensores is array (Integer range <>) of ascensor;
   Ascensores : listaAscensores(1 .. Cant_ascensores);
   
   task type gestor is
   end;
   task body gestor is
      DistanciaA1 : Integer;
      DistanciaA2 : Integer;
   begin
      llenarPedidos;
      while Cont_pedidos <= Cant_pedidos loop
         if (Disponible1 = True) and (Disponible2 = True) then
            DistanciaA1 := abs(Piso_actual1 - Pedidos(Cont_pedidos).desde);
            DistanciaA2 := abs(Piso_actual2 - Pedidos(Cont_pedidos).desde);
            if DistanciaA2 < DistanciaA1 then
               Ascensores(2).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta); 
               Ascensores(1).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta);
            else  
               Ascensores(1).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta);
               Ascensores(2).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta);
            end if;
         elsif Disponible1 = True then
            Ascensores(1).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta); 
         elsif Disponible2 = True then
            Ascensores(2).pedir(Pedidos(Cont_pedidos).desde, Pedidos(Cont_pedidos).hasta);
         end if;
      end loop;
   end gestor;
   
   type listaGestores is array (Integer range <>) of gestor;
   MiGestor : gestor;

begin
   null;
end ascensores;
