-- 9. Hay una empresa de servicios que tiene un Recepcionista, N Clientes que hacen reclamos y
-- E Empleados que los resuelven. Cada vez que un cliente debe hacer un reclamo, espera a
-- que el Recepcionista lo atienda y le dé un Número de Reclamo, y luego continúa trabajando.
-- Los empleados cuando están libres le piden un reclamo para resolver al Recepcionista y lo
-- resuelven. El Recepcionista recibe los reclamos de los clientes y les entrega el Número de
-- Reclamo, o bien atiende los pedidos de más trabajo de los Empleados (cuando hay reclamos
-- sin resolver le entrega uno al empleado para que trabaje); siempre le debe dar prioridad a los
-- pedidos de los Empleados. Nota: los clientes, empleados y recepcionista trabajan
-- infinitamente.
-- https://ideone.com/dC5QvF

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio9 IS
	-- HEADER DE TAREAS
	TASK Recepcionista IS
		ENTRY Reclamo(msg: IN Integer; nro: OUT Integer);
		ENTRY Pedido(msg: OUT Integer);
	END Recepcionista;
	TASK TYPE Empleado;
	TASK TYPE Cliente;

	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrEmpleados: ARRAY (1..3) OF Empleado;
	arrClientes: ARRAY (1..5) OF Cliente;

	-- CUERPO DE TAREAS
	TASK BODY Recepcionista IS
		reclamos: ARRAY (1..20) OF Integer;
		nro_rec_local, index_read, index_write: Integer := 1;
	BEGIN
		LOOP
			SELECT
				WHEN ((Pedido'count = 0) OR (index_read = index_write)) => -- EMPTY RECLAMOS
					ACCEPT Reclamo(msg: IN Integer; nro: OUT Integer) DO
						reclamos(index_write):= msg;
						nro:= nro_rec_local;
					END Reclamo;
					Put_Line("reclamos(index_write): " & Integer'Image(reclamos(index_write)) 
								& "  (index_write: " & Integer'Image(index_write) & ")");
					nro_rec_local:= nro_rec_local + 1;
					index_write:= (index_write + 1) MOD 20;
			OR
				WHEN (index_read /= index_write) => -- NOT EMPTY RECLAMOS
					ACCEPT Pedido(msg: OUT Integer) DO
						msg:= reclamos(index_read);
					END Pedido;
					Put_Line("reclamos(index_read) : " & Integer'Image(reclamos(index_read)) 
								& "  (index_read : " & Integer'Image(index_read) & ")");
					index_read:= (index_read + 1) MOD 20;
			END SELECT;
		END LOOP;
	END Recepcionista;

	TASK BODY Empleado IS
		rec: Integer;
	BEGIN
		LOOP
			Recepcionista.Pedido(rec);
			--ResolverReclamo(rec);
			Put_Line("EMPLEADO REC   : " & Integer'Image(rec));
		END LOOP;
	END Empleado;

	TASK BODY Cliente IS
		rec: Integer := 0;
		nro_rec: Integer;
	BEGIN
		LOOP
			--rec:= GenerarReclamo();
			rec:= rec + 1;
			Put_Line("CLIENTE REC    : " & Integer'Image(rec));
			Recepcionista.Reclamo(rec, nro_rec);
			Put_Line("CLIENTE NRO_REC: " & Integer'Image(nro_rec) 
						& "  (REC:"  & Integer'Image(rec) & ")");
		END LOOP;
	END Cliente;
BEGIN
	NULL;
END Ejercicio9;
