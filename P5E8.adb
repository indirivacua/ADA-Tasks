-- 8. En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos
-- de U Usuarios de a uno a la vez y de acuerdo al orden en que se hacen los pedidos.
-- Cada usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la
-- respuesta del mismo que le indica si está todo bien o hay algún error. Mientras haya algún
-- error vuelve a trabajar con el documento y a enviarlo al servidor. Cuando el servidor le
-- responde que está todo bien el usuario se retira. Cuando un usuario envía un pedido espera
-- a lo sumo 2 minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto
-- y vuelve a intentarlo (usando el mismo documento).
-- https://ideone.com/QNI0VO

WITH Ada.Text_IO; USE Ada.Text_IO;  
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

PROCEDURE Ejercicio8 IS
	-- HEADER DE TAREAS
	TASK Servidor IS
		ENTRY Pedido(doc: IN String; rta: OUT Boolean);
	END Servidor;
	TASK TYPE Usuario;
	
	-- DECLARACION DE VARIABLES DE TASK TYPES
	arrUsuarios: ARRAY (1..5) OF Usuario;

	-- CUERPO DE TAREAS
	TASK BODY Servidor IS
	BEGIN
		LOOP
			ACCEPT Pedido(doc: IN String; rta: OUT Boolean) DO
				--rta:= CorregirDocumento(doc);
				rta:= true;
			END Pedido;
		END LOOP;
	END Servidor;

	TASK BODY Usuario IS
		documento: String(1..150);
		respuesta: Boolean := false;
	BEGIN
		--TrabajarDocumento(documento);
		Put_Line("TRABAJAR DOC");
		WHILE (respuesta /= true) LOOP
			SELECT
				Servidor.Pedido(documento, respuesta);
				IF (respuesta /= true) THEN
					--TrabajarDocumento(documento);
					Put_Line("CORREGIR DOC");
				END IF;
			OR DELAY (120.0); -- 2 minutos
				DELAY 60.0; -- 1 minuto
			END SELECT;
		END LOOP;
		Put_Line("TERMINE ME VOY");
	END Usuario;
BEGIN
	NULL;
END Ejercicio8;
