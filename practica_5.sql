--Guia 5
--Cristobal Guzman

SELECT * FROM carrera;
SELECT * FROM alumno;
SELECT * FROM escolaridad_emp;
SELECT * FROM escuela;
SELECT * FROM empleado;
SELECT * FROM prestamo;

--1
SELECT  carreraid AS "IDENTIFICADOR DE CARRERA",
        COUNT(carreraid) AS "TOTAL ALUMNOS MATRICULADOS",
        'Le corresponden'||TO_CHAR(COUNT (carreraid)*30200,'$999G999G999')||
        ' del presupuesto total asignado para publicidad' AS "MONTO POR PUBLICIDAD"
FROM alumno
GROUP BY carreraid
ORDER BY "TOTAL ALUMNOS MATRICULADOS" DESC;

--2
SELECT  carreraid AS CARRERA,
        COUNT(carreraid) AS "TOTAL ALUMNOS"
FROM alumno
GROUP BY carreraid
HAVING COUNT(carreraid) > 4
ORDER BY carreraid;

--3
SELECT  run_jefe AS "RUN JEFE SIN DV",
        COUNT(run_jefe) AS "EMPLEADOS A CARGO",
        TO_CHAR(MAX(salario),'999G999G999') AS "SALARIO MAXIMO",
        COUNT(run_jefe)* 10||'% del salario maximo' AS "PORCENTAJE DE BONIFICACION",
        TO_CHAR((MAX(salario)/100)*COUNT(run_jefe),'L999G999G999') AS "BONIFICACION"
FROM empleado group by run_jefe
HAVING run_jefe IS NOT NULL
GROUP BY run_jefe
ORDER BY run_jefe;

--4
SELECT  id_escolaridad AS "ESCOLARIDAD",
       ( CASE   WHEN id_escolaridad = 10  THEN 'Basica'
                WHEN id_escolaridad = 20  THEN 'Media Cientifico Humanista'
                WHEN id_escolaridad = 30  THEN 'Media Tecnico Profesional'
                WHEN id_escolaridad = 40  THEN 'Superior Centro de Formacion Tecnica'
                WHEN id_escolaridad = 50  THEN 'Superior Instituto Profesional'
                ELSE 'Superior Universidad'END)"DESCRIPCION ESCOLARIDAD",
        COUNT(id_escolaridad) AS "TOTAL EMPLEADOS",
        TO_CHAR(MAX(salario),'L999G999G999') AS "SALARIO MAXIMO",
        TO_CHAR(MIN(salario),'L999G999G999') AS "SALARIO MINIMO",
        TO_CHAR(SUM(salario),'L999G999G999') AS "SALARIO TOTAL",
        TO_CHAR(AVG(salario),'L999G999G999') AS "SALARIO PROMEDIO"
FROM empleado
GROUP BY id_escolaridad
ORDER BY "TOTAL EMPLEADOS" DESC;

--5
SELECT  tituloid AS "CODIGO DEL LIBRO",
        COUNT(tituloid) AS "TOTAL DE VECES SOLICITADO"
        
FROM prestamo
GROUP BY tituloid
ORDER BY "TOTAL DE VECES SOLICITADO" DESC;