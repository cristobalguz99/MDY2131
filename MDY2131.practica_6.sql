--CASO 1
SELECT * FROM PROFESION_OFICIO;


SELECT TO_CHAR(CLI.NUMRUN,'09G999G999')||'-'||CLI.DVRUN AS "RUN CLIENTE",
INITCAP(CLI.PNOMBRE)||' '||INITCAP(CLI.SNOMBRE)||' '||INITCAP(CLI.APPATERNO)||' '||INITCAP(CLI.APMATERNO) AS "NOMBRE CLIENTE",
PRO.NOMBRE_PROF_OFIC AS "PROFESION/OFICIO",
TO_CHAR(CLI.FECHA_NACIMIENTO,'DD')||' de '||TO_CHAR(CLI.FECHA_NACIMIENTO,'month') AS "FECHA NACIMIENTO"
FROM CLIENTE CLI
JOIN PROFESION_OFICIO PRO ON PRO.COD_PROF_OFIC = CLI.COD_PROF_OFIC
WHERE EXTRACT(MONTH FROM CLI.FECHA_NACIMIENTO) = 9
ORDER BY "FECHA NACIMIENTO" ASC, CLI.APPATERNO;

--CASO 2
SELECT TO_CHAR(CLI.NUMRUN,'09G999G999')||'-'||CLI.DVRUN AS "RUN CLIENTE",
CLI.PNOMBRE||' '||CLI.SNOMBRE||' '||CLI.APPATERNO||' '||CLI.APMATERNO AS "NOMBRE CLIENTE",
TO_CHAR(SUM(CRC.MONTO_SOLICITADO),'$99G999G999') AS "MONTO SOLICITADO",
TO_CHAR((SUM(CRC.MONTO_SOLICITADO)/100000)*1200,'$99G999G999') AS "TOTAL PESOS TODOSUMA"
FROM CLIENTE CLI
JOIN CREDITO_CLIENTE CRC ON CRC.NRO_CLIENTE = CLI.NRO_CLIENTE
WHERE EXTRACT(YEAR FROM CRC.FECHA_SOLIC_CRED) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY CLI.NUMRUN, CLI.DVRUN, CLI.PNOMBRE, CLI.SNOMBRE, CLI.APPATERNO, CLI.APMATERNO
ORDER BY "TOTAL PESOS TODOSUMA" ASC, APPATERNO DESC;

--CASO 3
SELECT TO_CHAR(CRC.FECHA_SOLIC_CRED,'mmyyyy') AS "MES TRANSACCION",
CRE.NOMBRE_CREDITO AS "TIPO CREDITO",
SUM(MONTO_CREDITO) AS "MONTO SOLICITADO CREDITO",
CASE WHEN SUM(MONTO_CREDITO) BETWEEN 100000 AND 1000000 THEN SUM(MONTO_CREDITO)*0.01
WHEN SUM(MONTO_CREDITO) BETWEEN 1000001 AND 2000000 THEN SUM(MONTO_CREDITO)*0.02
WHEN SUM(MONTO_CREDITO) BETWEEN 2000001 AND 4000000 THEN SUM(MONTO_CREDITO)*0.03
WHEN SUM(MONTO_CREDITO) BETWEEN 4000001 AND 6000000 THEN SUM(MONTO_CREDITO)*0.04
WHEN SUM(MONTO_CREDITO) > 6000000 THEN SUM(MONTO_CREDITO)*0.07
END "APORTE A LA SBIF"
FROM CREDITO_CLIENTE CRC
JOIN CREDITO CRE ON CRE.COD_CREDITO = CRC.COD_CREDITO
WHERE EXTRACT(YEAR FROM FECHA_SOLIC_CRED) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY TO_CHAR(CRC.FECHA_SOLIC_CRED,'mmyyyy'),CRE.NOMBRE_CREDITO
ORDER BY "MES TRANSACCION","TIPO CREDITO"

--CASO 4
SELECT TO_CHAR(NUMRUN,'09G999G999')||'-'||DVRUN AS "RUT CLIENTE",
PNOMBRE||' '||SNOMBRE||' '||APPATERNO||' '||APMATERNO AS "NOMBRE DEL CLIENTE",
TO_CHAR(SUM(PIC.MONTO_TOTAL_AHORRADO),'$99G999G999') AS "MONTO TOTAL AHORRADO",
CASE WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 100000 AND 1000000 THEN 'BRONCE'
WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) > 15000000 THEN 'PLATINUM'
END "CATEGORIA CLIENTE"
FROM CLIENTE CLI
JOIN PRODUCTO_INVERSION_CLIENTE PIC ON PIC.NRO_CLIENTE = CLI.NRO_CLIENTE
GROUP BY NUMRUN,DVRUN,PNOMBRE,SNOMBRE,APPATERNO,APMATERNO
ORDER BY APPATERNO ASC, "MONTO TOTAL AHORRADO" DESC;

--CASO 5
SELECT EXTRACT(YEAR FROM SYSDATE) AS "A�O TRIBUTARIO",
TO_CHAR(NUMRUN,'09G999G999')||'-'||DVRUN AS "RUT CLIENTE",
INITCAP(PNOMBRE)||' '||SUBSTR(SNOMBRE,0,1)||'. '||INITCAP(APPATERNO)||' '||INITCAP(APMATERNO) AS "NOMBRE DEL CLIENTE",
COUNT(PIC.NRO_CLIENTE) AS "TOTAL PROD. INV AFECTADOS IMPTO",
TO_CHAR(SUM(PIC.MONTO_TOTAL_AHORRADO),'$99G999G999') AS "MONTO TOTAL AHORRADO"
FROM CLIENTE CLI
JOIN PRODUCTO_INVERSION_CLIENTE PIC ON PIC.NRO_CLIENTE = CLI.NRO_CLIENTE
HAVING SUM(PIC.MONTO_TOTAL_AHORRADO) > 7833186 
GROUP BY EXTRACT(YEAR FROM SYSDATE), NUMRUN,DVRUN,PNOMBRE,SNOMBRE,APPATERNO,APMATERNO
ORDER BY APPATERNO;

--CASO 6 PARTE 1
SELECT TO_CHAR(NUMRUN,'09G999G999')||'-'||DVRUN AS "RUT CLIENTE",
INITCAP(PNOMBRE)||' '||INITCAP(SNOMBRE)||' '||INITCAP(APPATERNO)||' '||INITCAP(APMATERNO) AS "NOMBRE DEL CLIENTE",
COUNT(CRC.NRO_CLIENTE) AS "TOTAL CREDITOS SOLICITADOS",
RTRIM(TO_CHAR(SUM(CRC.MONTO_SOLICITADO),'$99G999G999')) AS "MONTO TOTAL CREDITOS"
FROM CLIENTE CLI
JOIN CREDITO_CLIENTE CRC ON CRC.NRO_CLIENTE = CLI.NRO_CLIENTE
WHERE EXTRACT(YEAR FROM FECHA_OTORGA_CRED) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY NUMRUN, DVRUN, PNOMBRE,SNOMBRE,APPATERNO,APMATERNO
ORDER BY APPATERNO;

--CASO 6 PARTE 2
SELECT TO_CHAR(NUMRUN,'09G999G999')||'-'||DVRUN AS "RUT CLIENTE",
INITCAP(PNOMBRE)||' '||INITCAP(SNOMBRE)||' '||INITCAP(APPATERNO)||' '||INITCAP(APMATERNO) AS "NOMBRE DEL CLIENTE",
COALESCE(TO_CHAR(MAX(CASE WHEN MOV.COD_TIPO_MOV = 1 THEN MOV.MONTO_MOVIMIENTO
                            ELSE NULL END), 'L99G999G999'), 'NO REALIZO') AS "ABONO",
COALESCE(TO_CHAR(MAX(CASE WHEN MOV.COD_TIPO_MOV = 2 THEN MOV.MONTO_MOVIMIENTO 
                            ELSE null END), 'L99G999G999'), 'NO REALIZO') AS "RESCATES"
FROM CLIENTE CLI
JOIN MOVIMIENTO MOV ON MOV.NRO_CLIENTE = CLI.NRO_CLIENTE
WHERE EXTRACT(YEAR FROM MOV.FECHA_MOVIMIENTO) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY TO_CHAR(NUMRUN,'09G999G999')||'-'||DVRUN, PNOMBRE,SNOMBRE,APPATERNO,APMATERNO
ORDER BY APPATERNO;