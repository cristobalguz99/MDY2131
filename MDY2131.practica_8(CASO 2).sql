--caso 2
SELECT
    E.NOMBRE
    , M.MED_RUN
    , M.PNOMBRE
    , M.APATERNO
FROM MEDICO M
    JOIN ESPECIALIDAD_MEDICO EM ON M.MED_RUN=EM.MED_RUN
    RIGHT JOIN ESPECIALIDAD E ON EM.ESP_ID=E.ESP_ID
WHERE E.ESP_ID IN (
                        SELECT
                            E.ESP_id
                        FROM ATENCION A
                            RIGHT OUTER JOIN ESPECIALIDAD E ON e.esp_id = a.esp_id
                        WHERE EXTRACT (YEAR FROM A.FECHA_ATENCION)= EXTRACT(YEAR FROM SYSDATE)-1 OR A.FECHA_ATENCION IS NULL
                        GROUP BY e.nombre, E.ESP_ID
                        HAVING COUNT(A.ATE_ID)<10
                        )
ORDER BY E.NOMBRE
    ;

--SUBCONSULTA DE CASO 2
SELECT
    COUNT(A.ATE_ID)
    , e.nombre
    , E.ESP_id
FROM ATENCION A
    JOIN ESPECIALIDAD E ON e.esp_id = a.esp_id
WHERE EXTRACT (YEAR FROM A.FECHA_ATENCION)= EXTRACT(YEAR FROM SYSDATE)
GROUP BY e.nombre, E.ESP_ID
