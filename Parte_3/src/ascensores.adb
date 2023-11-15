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
   
   type asc is record 
      disponible : Boolean;
      piso_actual : Integer;
   end record;
      
   type listaAsc is array (Integer range <>) of asc;
   Ascensores : listaAsc(1 .. Cant_ascensores);

   procedure llenarAsc is
      ascAux : asc;
   begin
   for I in 1 .. Cant_ascensores loop
      begin
         ascAux.disponible := True;
         ascAux.piso_actual := 1;
         Ascensores(I) := ascAux;	
      end;
   end loop;
   end llenarAsc;

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
      Entry terminar;
   end ascensor;
   task body ascensor is
      Piso_actual : Integer := 1;
      Disponible : Boolean := True;
   begin
      Put_Line("El ascensor " & numero'Image & " esta en " & Piso_actual'Image);
      loop
         select
            accept pedir(desde : Integer; hasta : Integer) do
               Disponible := false;
               Ascensores(numero).disponible := False;
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
               Ascensores(numero).disponible := True;
            end pedir;
            or
            accept terminar;
            Ada.Text_IO.Put_Line ("El ascensor "& numero'Image &" TERMINO");
            exit;
         end select;
      end loop;
   end ascensor;
   
   type listaAscensores is array (Integer range <>) of ascensor;
   Ascensores2 : listaAscensores(1 .. Cant_ascensores);
   
   task type gestor is
   end;
   task body gestor is
      Cola_EnEspera : listaPedidos(1 .. Cant_pedidos);
      Cola_Atendidos : listaPedidos(1 .. Cant_pedidos);
   begin
      llenarPedidos;
      llenarAsc;
      
      for I in 1 .. Cant_pedidos loop
         declare
            Ascensor_disponible : Integer := 1;
            Distancia_min : Integer := Cant_pisos;
         begin
            for J in 1 .. Cant_ascensores loop
               if Ascensores(J).Disponible and abs(Ascensores(J).Piso_actual - Pedidos(I).desde) < Distancia_min
               then
                  Ascensor_disponible := J;
                  Distancia_min := abs(Ascensores(J).Piso_actual - Pedidos(I).desde);
               end if;
            end loop;
            
            if Ascensores(Ascensor_Disponible).Disponible then
               Ascensores2(Ascensor_Disponible).pedir(Pedidos(I).desde, Pedidos(I).hasta);
               Cola_Atendidos(I) := Pedidos(I);
            else
               Cola_EnEspera(I) := Pedidos(I);
            end if;
         end;
      end loop;
   end gestor;

begin
   delay 10.0;
   null;
end ascensores;