-- ==========================================
-- M4 - Consultas de negocio
-- Base de datos: Ventas_Tech_DB
-- ==========================================

--------------------------------------------------
-- Consulta 1: Resumen ejecutivo mensual
--------------------------------------------------

SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta);


--------------------------------------------------
-- Consulta 2: Ranking de productos
--------------------------------------------------

SELECT TOP (5)
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


--------------------------------------------------
-- Consulta 3: Clientes recurrentes
--------------------------------------------------

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


--------------------------------------------------
-- Consulta 4: Meses por encima/debajo del promedio
--------------------------------------------------

SELECT
    mes,
    total_facturado,

    CASE
        WHEN total_facturado > Ticket_promedio
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS estado_mes
FROM
(
   SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta);
) AS resumen
ORDER BY mes;


--------------------------------------------------
-- Hallazgos
--------------------------------------------------

-- 1.La venta del Marzo fue por encima del promedio del mes.  
-- 2. El producto mas vendidos en unidades es uno de los más economícos. Mientras que el resto se vendieron aproximado 3.
-- 3. Existen clientes que realizaron más de una compra durante el período analizado.
