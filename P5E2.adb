-- 2. Se quiere modelar la cola de un banco que atiende un solo empleado, los clientes llegan y si
-- esperan más de 10 minutos se retiran.
-- https://ideone.com/i8J2QZ

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio2 IS
	-- HEADERS DE TAREAS
	TASK Empleado IS
		ENTRY Pedido(msg: IN String; rta: OUT String);
	END Empleado;
	TASK TYPE Cliente;

	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrClientes: ARRAY (1..10) OF Cliente;

	-- CUERPO DE TAREAS
	TASK BODY Empleado IS
	BEGIN
		LOOP
			ACCEPT Pedido(msg: IN String; rta: OUT String) DO
				--rta:= ResolverPedido(msg);
				NULL;
			END Pedido;
		END LOOP;
	END Empleado;

	TASK BODY Cliente IS
		msg, rta: String(1..150);
	BEGIN
		--msg:= GenerarPedido();
		Put_Line("IN");
		SELECT
			Empleado.Pedido(msg, rta);
			Put_Line("OUT"); 
		OR DELAY (600.0); -- 10 minutos (0.00001 FORCE TIMEOUT)
			--NULL;
			Put_Line("TIMEOUT");
		END SELECT;
	END Cliente;
BEGIN
	NULL;
END Ejercicio2;
