ALTER PROCEDURE USR_DESPACHO_DON(
	@@EmpresaID Int,
	@@FechaDesde DateTime,
	@@SoloPendientes Int = 1)
AS
BEGIN
  SELECT
    'Fecha' = a.fecha,
    'TransaccionID' = a.transaccionid,
    'Total' = a.importetotal,
    'Documento' = a.nombre,
    'Cliente' = c.nombre,
    'EmpresaID' = a.EmpresaId,
    'Link de pago' =  NULLIF(b.USR_Link, '')
  FROM bstransaccion AS a
  JOIN bsoperacion AS b
  ON a.transaccionid = b.transaccionid
  JOIN bsorganizacion AS c
  ON b.organizacionid = c.organizacionid
  WHERE transaccionsubtipoid=351
  AND a.fecha >= @@FechaDesde
  AND a.empresaid = @@EmpresaID
  AND 'abc' like case @@SoloPendientes when 1 then ISNULL( NULLIF(b.USR_Link, ''),'abc') else 'abc' end
 END
