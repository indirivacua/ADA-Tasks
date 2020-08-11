-- 10.Se debe modelar un sumador de factoriales con 1 administrador y 10 Calculadores. El
-- administrador determina (mediante la función rand()) para cada Calculador el número del
-- cual debe calcular el factorial; suma el resultado de los 10 calculadores y luego imprime el
-- resultado final.
-- https://ideone.com/vy9bN5

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio10 IS
	-- HEADER DE TAREAS
	TASK Administrador IS
		ENTRY Numero(num: OUT Integer);
		ENTRY Resultado(fact: IN Integer);
	END Administrador;
	TASK TYPE Calculador;

	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrCalculadores: ARRAY (1..10) OF Calculador;

	-- CUERPO DE TAREAS
	TASK BODY Administrador IS
		total, i: Integer := 0;
	BEGIN
		FOR i IN 1..20 LOOP -- 10 ACCEPT de Numero y 10 ACCEPT de Resultado
			SELECT
				ACCEPT Numero(num: OUT Integer) DO
					num:= 5; --num:= rand();
				END Numero;
			OR
				ACCEPT Resultado(fact: IN Integer) DO
					total:= total + fact;
				END Resultado;
			END SELECT;
		END LOOP;
		Put_Line("Suma Total: " & Integer'Image(total));
	END Administrador;

	TASK BODY Calculador IS
		num, factorial: Integer := 1;
	BEGIN
		Administrador.Numero(num);
		FOR i IN 2..num LOOP
			factorial:= factorial * i;
		END LOOP;
		Put_Line(Integer'Image(factorial));
		Administrador.Resultado(factorial);
	END Calculador;
BEGIN
	NULL;
END Ejercicio10;
