-- 4. Se dispone de un sistema compuesto por 1 central y 2 procesos. Los procesos envían
-- señales a la central. La central comienza su ejecución tomando una señal del proceso 1,
-- luego toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
-- señal de proceso 2, recibe señales del mismo proceso durante 3 minutos.
-- El proceso 1 envía una señal que es considerada vieja (se deshecha) si en 2 minutos no fue
-- recibida.
-- El proceso 2 envía una señal, si no es recibida en ese instante espera 1 minuto y vuelve a
-- mandarla (no se deshecha).
-- https://ideone.com/pTuNY1

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio4 IS
	-- HEADER DE TAREAS
	TASK Central IS
		ENTRY SignalProc1(data: IN Integer);
		ENTRY SignalProc2(data: IN Integer);
		ENTRY Timeout;
	END Central;
	TASK Timer IS
		ENTRY Empezar;
	END Timer;
	TASK Proceso1;
	TASK Proceso2;

	-- CUERPO DE TAREAS
	TASK BODY Central IS
		stop: Boolean;
	BEGIN
		ACCEPT SignalProc1(data: IN Integer) DO
			--ProcesarSignal(data);
			Put_Line("PROC 1 INICIAL");
		END SignalProc1;
		LOOP
			stop:= false;
			SELECT
				ACCEPT SignalProc1(data: IN Integer) DO
					--ProcesarSignal(data);
					Put_Line("PROC 1");
				END SignalProc1;
			OR
				ACCEPT SignalProc2(data: IN Integer) DO
					--ProcesarSignal(data);
					Put_Line("PROC 2");
				END SignalProc2;
				Timer.Empezar;
				WHILE (stop = false) LOOP
					SELECT
						WHEN (Timeout'count = 0) =>
							ACCEPT SignalProc2(data: IN Integer) DO
								--ProcesarSignal(data);
								Put_Line("PROC 2 BUCLE");
							END SignalProc2;
					OR
						ACCEPT Timeout;
						Put_Line("TIMEOUT");
						stop:= true;
					END SELECT;
				END LOOP;
			END SELECT;
		END LOOP;
	END Central;

	TASK BODY Timer IS
	BEGIN
		LOOP
			ACCEPT Empezar;
			DELAY 180.0; -- 3 minutos (0.00001 FORCE TIMEOUT)
			Central.Timeout; 
		END LOOP;
	END Timer;

	TASK BODY Proceso1 IS
		signalData: Integer;
	BEGIN
		LOOP
			--signalData:= GenerarSignal();
			SELECT
				Central.SignalProc1(signalData);
			OR DELAY (120.0); -- 2 minutos
				NULL;
			END SELECT;
		END LOOP;
	END Proceso1;

	TASK BODY Proceso2 IS
		signalData: Integer;
	BEGIN
		--signalData:= GenerarSignal();
		LOOP
			SELECT
				Central.SignalProc2(signalData);
			ELSE
				DELAY 60.0; -- 1 minuto (0.00001 FORCE SEND)
				Central.SignalProc2(signalData);
			END SELECT;
		END LOOP;
	END Proceso2;
BEGIN
	NULL;
END Ejercicio4;
