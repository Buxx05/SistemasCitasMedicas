package util;

/**
 * Utilidad para generar códigos automáticos en todo el sistema Centraliza la
 * lógica de códigos para usuarios, pacientes, citas, recetas, etc.
 */
public class GeneradorCodigos {

    // ========== CÓDIGOS DE USUARIOS POR ROL ==========
    /**
     * Genera código de usuario según el rol Rol 1: AD001, AD002... Rol 2:
     * PM001, PM002... Rol 3: PNM001, PNM002...
     */
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
    /**
     * Genera código de paciente Formato: PAC0001, PAC0002, PAC0003...
     */
    public static String generarCodigoPaciente(int idPaciente) {
        return formatearCodigo("PAC", idPaciente, 4);
    }

    // ========== CÓDIGOS DE CITAS CON AÑO ==========
    /**
     * Genera código de cita con año Formato: CIT25-0001, CIT25-0002... Donde 25
     * son los últimos 2 dígitos del año
     */
    public static String generarCodigoCita(int idCita, int anio) {
        // Obtener los últimos 2 dígitos del año
        int anioCorto = anio % 100;  // 2025 → 25

        return String.format("CIT%02d-%04d", anioCorto, idCita);
    }

    /**
     * Genera código de cita con el año actual
     */
    public static String generarCodigoCita(int idCita) {
        int anioActual = java.time.Year.now().getValue();
        return generarCodigoCita(idCita, anioActual);
    }

    /**
     * Genera código único para recetas médicas Formato: REC0001, REC0002, etc.
     */
    public static String generarCodigoReceta(int idReceta) {
        return String.format("REC%04d", idReceta);
    }

    /**
     * Genera código de receta con año y mes Formato: REC2025-10-0001,
     * REC2025-10-0002...
     */
    public static String generarCodigoRecetaConFecha(int idReceta, int anio, int mes) {
        return String.format("REC%d-%02d-%04d", anio, mes, idReceta);
    }

    // ========== CÓDIGOS DE PROFESIONALES ==========
    /**
     * Genera código de profesional Formato: PRO001, PRO002, PRO003...
     */
    public static String generarCodigoProfesional(int idProfesional, int idRol) {
        String prefijo;

        switch (idRol) {
            case 2:
                prefijo = "PM";    // Profesional Médico
                break;
            case 3:
                prefijo = "PNM";   // Profesional No Médico
                break;
            default:
                prefijo = "PRO";   // Genérico (por si acaso)
        }

        return formatearCodigo(prefijo, idProfesional, 3);
    }

    public static String generarCodigoProfesional(int idProfesional) {
        return formatearCodigo("PRO", idProfesional, 3);
    }

    // ========== CÓDIGOS DE ESPECIALIDADES ==========
    /**
     * Genera código de especialidad Formato: ESP01, ESP02, ESP03...
     */
    public static String generarCodigoEspecialidad(int idEspecialidad) {
        return formatearCodigo("ESP", idEspecialidad, 2);
    }

    // ========== CÓDIGOS DE HORARIOS ==========
    /**
     * Genera código de horario Formato: HOR001, HOR002, HOR003...
     */
    public static String generarCodigoHorario(int idHorario) {
        return formatearCodigo("HOR", idHorario, 3);
    }

    // ========== MÉTODO GENÉRICO PARA FORMATEAR ==========
    /**
     * Método genérico para formatear cualquier código
     *
     * @param prefijo Prefijo del código (ej: "PAC", "CIT", "REC")
     * @param numero Número a formatear
     * @param digitos Cantidad de dígitos con ceros a la izquierda
     * @return Código formateado
     */
    public static String formatearCodigo(String prefijo, int numero, int digitos) {
        String formato = "%s%0" + digitos + "d";
        return String.format(formato, prefijo, numero);
    }

    // ========== MÉTODO PERSONALIZADO ==========
    /**
     * Genera un código completamente personalizado Útil para casos especiales
     * no contemplados
     */
    public static String generarCodigoPersonalizado(String prefijo, int numero, int digitos, String sufijo) {
        String codigo = formatearCodigo(prefijo, numero, digitos);
        return sufijo != null && !sufijo.isEmpty() ? codigo + sufijo : codigo;
    }
}
