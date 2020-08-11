-- 1. Se requiere modelar un puente de un solo sentido, el puente solo soporta el peso de 5
-- unidades de peso. Cada auto pesa 1 unidad, cada camioneta pesa 2 unidades y cada camión
-- 3 unidades. Suponga que hay una cantidad innumerable de vehículos (A autos, B
-- camionetas y C camiones).
-- a. Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.
-- b. Modifique la solución para que tengan mayor prioridad los camiones que el resto de los
-- vehículos.
-- https://ideone.com/ooNRuL

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio1 IS
	-- HEADERS DE TAREAS
	TASK Puente IS
		ENTRY EntrarPuenteAuto;
		ENTRY EntrarPuenteCamioneta;
		ENTRY EntrarPuenteCamion;
		ENTRY SalirPuente(tipo: IN String);
	END Puente;
	TASK TYPE Auto;
	TASK TYPE Camioneta;
	TASK TYPE Camion;

	-- DECLARACIÓN DE VARIABLES DE TASK TYPES
	arrAutos: ARRAY (1..5) OF Auto;
	arrCamioneta: ARRAY (1..4) OF Camioneta;
	arrCamion: ARRAY (1..3) OF Camion;

	-- CUERPO DE TAREAS
	TASK BODY Puente IS
		peso: Integer := 0;
	BEGIN
		LOOP
			SELECT
				WHEN ((EntrarPuenteCamion'count = 0) AND (peso + 1 <= 5)) => 
							ACCEPT EntrarPuenteAuto DO
								peso:= peso + 1;
							END EntrarPuenteAuto;
			OR
				WHEN ((EntrarPuenteCamion'count = 0) AND (peso + 2 <= 5)) => 
							ACCEPT EntrarPuenteCamioneta DO
								peso:= peso + 2;
							END EntrarPuenteCamioneta;
			OR
				WHEN (peso + 3 <= 5) => ACCEPT EntrarPuenteCamion DO
								peso:= peso + 3;
							END EntrarPuenteCamion;
			OR 
				ACCEPT SalirPuente(tipo: IN String) DO
					IF (tipo = "Auto") THEN peso:= peso - 1;
					ELSIF (tipo = "Camioneta") THEN peso:= peso - 2;
					ELSIF (tipo = "Camion") THEN peso:= peso - 3;
					END IF;
				END SalirPuente;
			END SELECT;
		END LOOP;
	END Puente;

	TASK BODY Auto IS
	BEGIN
		Puente.EntrarPuenteAuto;
		-- "el auto cruza el puente"
		Put_Line ("el auto cruza el puente");
		Puente.SalirPuente("Auto");
	END Auto;

	TASK BODY Camioneta IS
	BEGIN
		Puente.EntrarPuenteCamioneta;
		-- "la camioneta cruza el puente"
		Put_Line ("la camioneta cruza el puente");
		Puente.SalirPuente("Camioneta");
	END Camioneta;

	TASK BODY Camion IS
	BEGIN
		Puente.EntrarPuenteCamion;
		-- "el camion cruza el puente"
		Put_Line ("el camion cruza el puente");
		Puente.SalirPuente("Camion");
	END Camion;
BEGIN
	NULL;
END Ejercicio1;
