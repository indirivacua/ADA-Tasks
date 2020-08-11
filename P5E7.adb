-- 7. En un campo dividido en 4 secciones (Norte, Sur, Este y Oeste) se deben hacer rollos de
-- pasto, para lo cual se cuenta con 4 máquinas enrolladoras y un coordinador. El coordinador
-- indica a cada máquina la sección en la cual le toca trabajar (cada máquina va a una sección
-- diferente) y al final imprime (el coordinador) la cantidad total de rollos realizados en todo el
-- campo.
-- https://ideone.com/wMKjVz

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio7 IS
	-- HEADER DE TAREAS
	TASK Coordinador IS
		ENTRY Seccion(sec: OUT Integer);
		ENTRY Cantidad(cant: IN Integer);
	END Coordinador;
	TASK TYPE Maquina;

	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrMaquina: ARRAY (1..4) OF Maquina;

	-- CUERPO DE TAREAS
	TASK BODY Coordinador IS
		arrSecciones: ARRAY (1..4) OF Integer := (1, 2, 3, 4);
		cantTotal, i: Integer := 0;
		index: Integer := 1;
	BEGIN
		FOR i IN 1..8 LOOP -- 4 ACCEPT de Seccion y 4 ACCEPT de Cantidad
			SELECT
				ACCEPT  Seccion(sec: OUT Integer) DO
					sec:= arrSecciones(index);
				END Seccion;
				index:= index + 1;
			OR
				ACCEPT Cantidad(cant: IN Integer) DO
					cantTotal:= cantTotal + cant;
				END Cantidad;
			END SELECT;
		END LOOP;
		Put_Line("Cantidad Total: " & Integer'Image(cantTotal));
	END Coordinador;

	TASK BODY Maquina IS
		sec: Integer;
		cant: Integer := 0;
	BEGIN
		Coordinador.Seccion(sec);
		--TrabajarSeccion(sec, cant);
		Put_Line(Integer'Image(sec));
		cant:= cant + sec;
		Coordinador.Cantidad(cant);
	END Maquina;
BEGIN
	NULL;
END Ejercicio7;
