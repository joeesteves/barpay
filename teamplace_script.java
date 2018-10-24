String sessionID = params.getSessionID();
DBHelper dbh = params.getDBHelper();
CasoBPMAccionVO accion = params.get("Accion");

String titulo = accion.getAtributo("Titulo").getValor();

String updateDesc = "update bstransaccion set descripcion='" + accion.getAtributo("Descripcion").getValor() + "' where transaccionid =" + titulo;

dbh.executeUpdate(updateDesc);
