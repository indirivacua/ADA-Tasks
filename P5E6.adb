-- 6. En una empresa hay 5 controladores de temperatura y una Central. Cada controlador toma
-- la temperatura del ambiente cada 10 minutos y se la envía a una central para que analice el
-- dato y le indique que hacer. Cuando la central recibe una temperatura que es mayor de 40
-- grados, detiene a ese controlador durante 1 hora.
-- https://ideone.com/A68zxI

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio6 IS
	-- HEADER DE TAREAS
	TASK Central IS
		ENTRY Temperatura(temp: IN Integer; rta: OUT Boolean);
	END Central;
	TASK TYPE Controlador;

	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrControladores: ARRAY (1..5) OF Controlador;

	-- CUERPO DE TAREAS
	TASK BODY Central IS
	BEGIN
		LOOP
			ACCEPT Temperatura(temp: IN Integer; rta: OUT Boolean) DO
				Put_Line("ACEPTADO");
				IF (temp > 40) THEN
					rta:= true;
				END IF;
			END Temperatura;
		END LOOP;
	END Central;
	
	TASK BODY Controlador IS
		temp: Integer;
		accion: Boolean;
	BEGIN
		LOOP
			temp:= 41; --temp:= TomarTemperatura();
			Central.Temperatura(temp, accion);
			IF (accion = true) THEN
				Put_Line("DEMORADO 1 HORA");
				DELAY 3600.0; -- 1 hora
			ELSE
				Put_Line("DEMORADO 10 MINUTOS");
				DELAY 600.0; -- 10 minutos
			END IF;
		END LOOP;
	END Controlador;
BEGIN
	NULL;
END Ejercicio6;
