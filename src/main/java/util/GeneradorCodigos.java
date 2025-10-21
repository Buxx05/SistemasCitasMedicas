package util;

public class GeneradorCodigos {

    // ========== CÓDIGOS DE USUARIOS POR ROL ==========
    public static String generarCodigoUsuario(int idRol, int idUsuario) {
        String prefijo = obtenerPrefijoRol(idRol);
        return formatearCodigo(prefijo, idUsuario, 3);
    }

    private static String obtenerPrefijoRol(int idRol) {
        switch (idRol) {
            case 1:
                return "AD";    // Administrador
            case 2:
                return "PM";    // Profesional Médico
            case 3:
                return "PNM";   // Profesional No Médico
            default:
                return "USR";
        }
    }

    // ========== CÓDIGOS DE PACIENTES ==========
    public static String generarCodigoPaciente(int idPaciente) {
        return formatearCodigo("PAC", idPaciente, 4);
    }

    // ========== CÓDIGOS DE CITAS CON AÑO ==========
    public static String generarCodigoCita(int idCita, int anio) {
        int anioCorto = anio % 100;
        return String.format("CIT%02d-%04d", anioCorto, idCita);
    }

    public static String generarCodigoCita(int idCita) {
        int anioActual = java.time.Year.now().getValue();
        return generarCodigoCita(idCita, anioActual);
    }

    public static String generarCodigoReceta(int idReceta) {
        return String.format("REC%04d", idReceta);
    }

    public static String generarCodigoRecetaConFecha(int idReceta, int anio, int mes) {
        return String.format("REC%d-%02d-%04d", anio, mes, idReceta);
    }

    // ========== CÓDIGOS DE PROFESIONALES ==========
    /**
     * ✅ NUEVO: Genera código de profesional basado en el ID del usuario
     * vinculado Esto asegura que el profesional tenga el mismo código que su
     * usuario
     *
     * @param idUsuario ID del usuario vinculado al profesional
     * @param idRol Rol del usuario (2=Médico, 3=No Médico)
     * @return Código del profesional (ej: PM010, PNM015)
     */
    public static String generarCodigoProfesionalPorUsuario(int idUsuario, int idRol) {
        // Reutiliza la lógica de generarCodigoUsuario para consistencia
        return generarCodigoUsuario(idRol, idUsuario);
    }

    /**
     * @deprecated Usar generarCodigoProfesionalPorUsuario() para consistencia
     * Este método genera códigos basados en id_profesional, lo cual causa
     * duplicación
     */
    @Deprecated
    public static String generarCodigoProfesional(int idProfesional, int idRol) {
        String prefijo;
        switch (idRol) {
            case 2:
                prefijo = "PM";
                break;
            case 3:
                prefijo = "PNM";
                break;
            default:
                prefijo = "PRO";
        }
        return formatearCodigo(prefijo, idProfesional, 3);
    }

    /**
     * @deprecated Usar generarCodigoProfesionalPorUsuario() para consistencia
     */
    @Deprecated
    public static String generarCodigoProfesional(int idProfesional) {
        return formatearCodigo("PRO", idProfesional, 3);
    }

    // ========== CÓDIGOS DE ESPECIALIDADES ==========
    public static String generarCodigoEspecialidad(int idEspecialidad) {
        return formatearCodigo("ESP", idEspecialidad, 2);
    }

    // ========== CÓDIGOS DE HORARIOS ==========
    public static String generarCodigoHorario(int idHorario) {
        return formatearCodigo("HOR", idHorario, 3);
    }

    // ========== MÉTODO GENÉRICO PARA FORMATEAR ==========
    public static String formatearCodigo(String prefijo, int numero, int digitos) {
        String formato = "%s%0" + digitos + "d";
        return String.format(formato, prefijo, numero);
    }

    // ========== MÉTODO PERSONALIZADO ==========
    public static String generarCodigoPersonalizado(String prefijo, int numero, int digitos, String sufijo) {
        String codigo = formatearCodigo(prefijo, numero, digitos);
        return sufijo != null && !sufijo.isEmpty() ? codigo + sufijo : codigo;
    }
}
