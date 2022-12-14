--CASO 1
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUN CLIENTE",
INITCAP(C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO) AS "NOMBRE CLIENTE",
TO_CHAR(FECHA_NACIMIENTO,'DD "De" Month') AS "FECHA DE NACIMIENTO",
SR.DIRECCION||'/'||UPPER(R.NOMBRE_REGION) AS "DIRECCION"
FROM CLIENTE C
JOIN SUCURSAL_RETAIL SR ON SR.COD_REGION = C.COD_REGION
                        AND SR.COD_PROVINCIA = C.COD_PROVINCIA
                        AND SR.COD_COMUNA = C.COD_COMUNA
JOIN REGION R ON R.COD_REGION = SR.COD_REGION
WHERE EXTRACT(MONTH FROM FECHA_NACIMIENTO) = 9
--WHERE EXTRACT(MONTH FROM FECHA_NACIMIENTO) = EXTRACT(MONTH FROM SYSDATE)+1
AND C.COD_REGION = 13
ORDER BY "FECHA DE NACIMIENTO" ASC, APPATERNO;

--CASO 2
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUT CLIENTE",
C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO AS "NOMBRE CLIENTE",
TO_CHAR(SUM(TTC.MONTO_TRANSACCION),'$99G999G999') AS "MONTO COMPRAS/AVANCE/S. AVANCE",
TO_CHAR((SUM(TTC.MONTO_TRANSACCION)/10000)*250,'$99G999G999') AS "TOTAL DE PUNTOS ACUMULADOS"
FROM CLIENTE C
INNER JOIN TARJETA_CLIENTE TC ON TC.NUMRUN = C.NUMRUN
INNER JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.NRO_TARJETA = TC.NRO_TARJETA
WHERE EXTRACT(YEAR FROM TTC.FECHA_TRANSACCION) = 2021
GROUP BY C.NUMRUN,C.DVRUN,C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO
ORDER BY "MONTO COMPRAS/AVANCE/S. AVANCE"
;

--CASO 3

SELECT TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY') AS "FECHA TRANSACCION",
TTT.NOMBRE_TPTRAN_TARJETA AS "TIPO DE TRANSACCION",
TO_CHAR(SUM(TTC.MONTO_TOTAL_TRANSACCION),'$99G999G999') AS "MONTO AVANCE/S. AVANCE",
TO_CHAR(SUM(TTC.MONTO_TOTAL_TRANSACCION * (ASB.PORC_APORTE_SBIF/100)),'$99G990G999') AS "APORTE A LA SBIF"
FROM TRANSACCION_TARJETA_CLIENTE TTC
JOIN TIPO_TRANSACCION_TARJETA TTT ON TTC.COD_TPTRAN_TARJETA = TTT.COD_TPTRAN_TARJETA
JOIN APORTE_SBIF ASB ON TTC.MONTO_TOTAL_TRANSACCION BETWEEN ASB.MONTO_INF_AV_SAV AND ASB.MONTO_SUP_AV_SAV
WHERE TTT.COD_TPTRAN_TARJETA IN (102,103)
AND EXTRACT(YEAR FROM TTC.FECHA_TRANSACCION) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY'),TTT.NOMBRE_TPTRAN_TARJETA
ORDER BY "FECHA TRANSACCION","TIPO DE TRANSACCION";

--CASO 3 CON SUBCONSULTA
SELECT MONTO.FECHA_TRANSACCION AS "MES",
MONTO.TIPO_TRANSACCION,
TO_CHAR(MONTO.MONTO_AVANCE_SAVANCE,'$99G999G999') AS "TOTAL",
TO_CHAR(MONTO.MONTO_AVANCE_SAVANCE*(ASB.PORC_APORTE_SBIF/100),'$99G999G999') AS "APORTE SBIF"
FROM(
    SELECT TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY') AS "FECHA_TRANSACCION",
    TTT.NOMBRE_TPTRAN_TARJETA AS "TIPO_TRANSACCION",
    SUM(TTC.MONTO_TOTAL_TRANSACCION) AS "MONTO_AVANCE_SAVANCE"
    FROM TRANSACCION_TARJETA_CLIENTE TTC
    JOIN TIPO_TRANSACCION_TARJETA TTT ON TTC.COD_TPTRAN_TARJETA = TTT.COD_TPTRAN_TARJETA
    WHERE TTT.COD_TPTRAN_TARJETA IN (102,103)
    AND EXTRACT(YEAR FROM TTC.FECHA_TRANSACCION) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY'),TTT.NOMBRE_TPTRAN_TARJETA) MONTO
JOIN APORTE_SBIF ASB ON MONTO.MONTO_AVANCE_SAVANCE BETWEEN ASB.MONTO_INF_AV_SAV AND ASB.MONTO_SUP_AV_SAV

--CASO 4
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUN CLIENTE",
C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO AS "NOMBRE CLIENTE",
RTRIM(TO_CHAR(NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0),'$99G999G999')) AS "COMPRAS/AVANCES/S.AVANCES",
CASE WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) BETWEEN 0 AND 100000 THEN 'SIN CATEGORIZACION'
WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) BETWEEN 100001 AND 1000000 THEN 'BRONCE'
WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
WHEN NVL(SUM(TTC.MONTO_TOTAL_TRANSACCION),0) > 15000000 THEN 'PLATINUM'
END AS "CATEGORIZACION CLIENTE"
FROM CLIENTE C
INNER JOIN TARJETA_CLIENTE TC ON TC.NUMRUN = C.NUMRUN
LEFT JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.NRO_TARJETA = TC.NRO_TARJETA
GROUP BY TO_CHAR(C.NUMRUN,'09G999G999')||'-'||DVRUN,PNOMBRE,SNOMBRE,APPATERNO,APMATERNO
ORDER BY APPATERNO,"COMPRAS/AVANCES/S.AVANCES" DESC

--CASO 5
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUN CLIENTE",
INITCAP(C.PNOMBRE||' '||CONCAT(SUBSTR(C.SNOMBRE,0,1),'.')||' '||C.APPATERNO||' '||C.APMATERNO) AS "NOMBRE CLIENTE",
TRUNC(SUM(TTC.MONTO_TOTAL_TRANSACCION)/TC.CUPO_DISP_SP_AVANCE) AS "TOTAL DE SUPER AVANCE VIGENTE",
TO_CHAR(SUM(TTC.MONTO_TOTAL_TRANSACCION),'$99G999G999') AS "MONTO TOTAL SUPER AVANCE"
FROM CLIENTE C
INNER JOIN TARJETA_CLIENTE TC ON TC.NUMRUN = C.NUMRUN
LEFT JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.NRO_TARJETA = TC.NRO_TARJETA
WHERE TTC.COD_TPTRAN_TARJETA = 103
GROUP BY TO_CHAR(C.NUMRUN,'09G999G999')||'-'||DVRUN,PNOMBRE,SNOMBRE,APPATERNO,APMATERNO,TC.CUPO_DISP_SP_AVANCE
ORDER BY APPATERNO;

--CASO 6 INFORME 1
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUN CLIENTE",
INITCAP(C.PNOMBRE||' '||CONCAT(SUBSTR(C.SNOMBRE,0,1),'.')||' '||C.APPATERNO||' '||C.APMATERNO) AS "NOMBRE CLIENTE",
C.DIRECCION AS "DIRECCION",
R.NOMBRE_REGION AS "REGION",
COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 101 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "COMPRAS VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 101 THEN TTC.MONTO_TOTAL_TRANSACCION 
                            ELSE null END), 'L999g999g999'), '0') as "MONTO TOTAL COMPRA",
COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 102 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "AVANCE VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 102 THEN TTC.MONTO_TOTAL_TRANSACCION 
                            ELSE null END), 'L999g999g999'), '0') as "MONTO TOTAL AVANCE",
COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 103 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "SUPER AVANCE VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 103 THEN TTC.MONTO_TOTAL_TRANSACCION  
                            ELSE null END), 'L999g999g999'), '0') as "MONTO TOTAL S AVANCE"
FROM CLIENTE C
INNER JOIN REGION R ON R.COD_REGION = C.COD_REGION
INNER JOIN TARJETA_CLIENTE TC ON TC.NUMRUN = C.NUMRUN
LEFT JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.NRO_TARJETA = TC.NRO_TARJETA
GROUP BY TO_CHAR(C.NUMRUN,'09G999G999')||'-'||DVRUN,PNOMBRE,SNOMBRE,APPATERNO,APMATERNO,C.DIRECCION,R.NOMBRE_REGION
ORDER BY APPATERNO;

--CASO 6 INFORME 2 
SELECT SR.ID_SUCURSAL AS "SUCURSAL"
,R.NOMBRE_REGION AS "REGION"
,P.NOMBRE_PROVINCIA AS "PROVINCIA"
,C.NOMBRE_COMUNA AS "COMUNA"
,SR.DIRECCION
,COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 101 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "COMPRAS VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 101 THEN TTC.MONTO_TOTAL_TRANSACCION 
                            ELSE null END), 'L999G999G999'), '0') as "MONTO TOTAL COMPRA",
COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 102 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "AVANCE VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 102 THEN TTC.MONTO_TOTAL_TRANSACCION 
                            ELSE null END), 'L999G999G999'), '0') as "MONTO TOTAL AVANCE",
COALESCE(COUNT(CASE WHEN TTC.COD_TPTRAN_TARJETA = 103 THEN TTC.NRO_TARJETA 
                            ELSE null END), 0) as "SUPER AVANCE VIGENTE",
COALESCE(TO_CHAR(SUM(CASE WHEN TTC.COD_TPTRAN_TARJETA = 103 THEN TTC.MONTO_TOTAL_TRANSACCION  
                            ELSE null END), 'L999G999G999'), '0') as "MONTO TOTAL S. AVANCE"
FROM SUCURSAL_RETAIL SR
LEFT JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.ID_SUCURSAL = SR.ID_SUCURSAL

JOIN REGION R ON R.COD_REGION = SR.COD_REGION
JOIN COMUNA C ON C.COD_COMUNA = SR.COD_COMUNA
            AND C.COD_PROVINCIA = SR.COD_PROVINCIA
            AND C.COD_REGION = SR.COD_REGION
JOIN PROVINCIA P ON P.COD_PROVINCIA = SR.COD_PROVINCIA
            AND P.COD_REGION = SR.COD_REGION
GROUP BY SR.ID_SUCURSAL,R.NOMBRE_REGION,SR.DIRECCION,C.NOMBRE_COMUNA,P.NOMBRE_PROVINCIA
ORDER BY R.NOMBRE_REGION,SR.ID_SUCURSAL ASC;