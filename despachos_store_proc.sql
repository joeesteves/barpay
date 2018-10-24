ALTER PROCEDURE USR_DESPACHO_DON(
	@@EmpresaID Int,
	@@FechaDesde DateTime)
AS
BEGIN
  SELECT
    'Fecha' = a.fecha,
    'TransaccionID' = a.transaccionid,
    'Total' = a.importetotal,
    'Documento' = a.nombre,
    'EmpresaID' = a.EmpresaId,
    'Link de pago' = b.USR_Link
  FROM bstransaccion AS a
  JOIN bsoperacion AS b
  ON a.transaccionid = b.transaccionid
  WHERE transaccionsubtipoid=351
  AND a.fecha >= @@FechaDesde
  AND a.empresaid = @@EmpresaID
  AND b.USR_Link IS NULL
 END
