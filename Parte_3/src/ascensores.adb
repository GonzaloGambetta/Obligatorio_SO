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
   end ascensor;
   task body ascensor is
      Piso_actual : Integer := 1;
      Disponible : Boolean := True;
   begin
      if numero = 1
      then
         Piso_actual1 := Piso_actual;
      else
         Piso_actual2 := Piso_actual;
      end if;
      Put_Line("El ascensor " & numero'Image & " esta en " & Piso_actual'Image);
      loop
            accept pedir(desde : Integer; hasta : Integer) do
               Disponible := false;
               for I in 1 .. abs(Piso_actual - desde) loop
                  begin
                     delay 1.0;
                  end;
               end loop;
               Piso_actual := desde;
               Put_Line("El ascensor " & numero'Image & " esta en " & Piso_actual'Image);
               for I in 1 .. abs(Piso_actual - hasta) loop
                  begin
                     delay 1.0;
                  end;
               end loop;
               Piso_actual := hasta;
               Put_Line("El ascensor " & numero'Image & " esta en " & Piso_actual'Image);
               Disponible := true;
               Ada.Text_IO.Put_Line ("El ascensor "& numero'Image &" TERMINO");
            end pedir;
            accept liberar;
         
      end loop;
   end ascensor;
   
   type listaAscensores is array (Integer range <>) of ascensor;
   Ascensores : listaAscensores(1 .. Cant_ascensores);
   
   task type gestor is
   end;
   task body gestor is
      Piso_ascensor : Integer;
      Distancia_min : Integer := Cant_pisos;
   begin
      Put_Line("El ascensor ");
      for I in 1 .. Cant_pedidos loop
         begin
            for J in 1 .. Cant_ascensores loop
               if J = 1
               then
                  Piso_ascensor := Piso_actual1;
               else
                  Piso_ascensor := Piso_actual2;
               end if;
               Put_Line(Piso_ascensor'Image);
               if abs(Piso_ascensor - Pedidos(I).desde) < Distancia_min
               then
                  Distancia_min := abs(Piso_ascensor - Pedidos(I).desde);
                  Ascensores(I).pedir(Pedidos(I).desde, Pedidos(I).hasta);
               end if;
            end loop;
         end;
      end loop;
   end gestor;

begin
   llenarPedidos;
   delay 10.0;
   null;
end ascensores;
