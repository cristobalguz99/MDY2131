--GUIA 7
--CRISTOBAL GUZMAN  

--1
SELECT 
    TO_CHAR     (cli.numrun, '09G999G999')||'-'|| cli.dvrun AS "RUN CLIENTE", 
    INITCAP       (cli.pnombre||' '||cli.snombre||' '||cli.appaterno ||' '|| cli.apmaterno) AS "NOMBRE CLIENTE",
    TO_CHAR     (cli.fecha_nacimiento, 'DD "de" Month') AS "FECHA",
    sr.direccion ||' '|| UPPER(reg.nombre_region) AS "Direccion"
    
FROM cliente cli
    JOIN sucursal_retail sr ON cli.cod_comuna = sr.cod_comuna
            AND cli.cod_provincia = sr.cod_provincia
            AND cli.cod_region = sr.cod_region
    JOIN region reg ON cli.cod_region = reg.cod_region
WHERE EXTRACT (MONTH FROM cli.fecha_nacimiento)=09
        AND cli.cod_region =13
ORDER BY "FECHA", "NOMBRE CLIENTE" DESC;
    
    
--3
SELECT 
    TO_CHAR(ttc.fecha_transaccion, 'MMYYYY') AS MES
    , ttt.nombre_tptran_tarjeta AS "TIPO TRANSACCION"
    , TO_CHAR(SUM(ttc.monto_total_transaccion), '$999g999g999') AS MONTO
    , TO_CHAR(ROUND(SUM(ttc.monto_total_transaccion*aps.porc_aporte_sbif/100)), '$999g999g999') AS RESULTADO
    
FROM transaccion_tarjeta_cliente ttc
    JOIN tipo_transaccion_tarjeta ttt ON ttc.cod_tptran_tarjeta = ttt.cod_tptran_tarjeta
    JOIN aporte_sbif aps ON ttc.monto_transaccion BETWEEN aps.monto_inf_av_sav AND aps.monto_sup_av_sav
WHERE ttt.cod_tptran_tarjeta <> 101
GROUP BY TO_CHAR(ttc.fecha_transaccion, 'MMYYYY')
    , ttt.nombre_tptran_tarjeta
    
ORDER BY MES    
    ;
    
--3 Con subconsulta


    