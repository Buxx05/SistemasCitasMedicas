package dao;

import model.HorarioProfesional;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class HorarioProfesionalDAO {

    // ========== CRUD BÁSICO ==========
    /**
     * Inserta un nuevo horario
     */
    public boolean insertarHorario(HorarioProfesional horario) {
        String sql = "INSERT INTO HorariosProfesional (id_profesional, dia_semana, hora_inicio, "
                + "hora_fin, duracion_consulta, activo) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, horario.getIdProfesional());
            stmt.setString(2, horario.getDiaSemana());
            stmt.setString(3, horario.getHoraInicio());
            stmt.setString(4, horario.getHoraFin());
            stmt.setInt(5, horario.getDuracionConsulta());
            stmt.setBoolean(6, horario.isActivo());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    horario.setIdHorario(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lista horarios de un profesional específico
     */
    public List<HorarioProfesional> listarHorariosPorProfesional(int idProfesional) {
        List<HorarioProfesional> horarios = new ArrayList<>();
        String sql = "SELECT * FROM HorariosProfesional WHERE id_profesional = ? "
                + "ORDER BY FIELD(dia_semana, 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO'), hora_inicio";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                HorarioProfesional h = mapearHorarioBasico(rs);
                horarios.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

    /**
     * Lista todos los horarios
     */
    public List<HorarioProfesional> listarTodosHorarios() {
        List<HorarioProfesional> horarios = new ArrayList<>();
        String sql = "SELECT * FROM HorariosProfesional ORDER BY id_profesional, dia_semana, hora_inicio";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                HorarioProfesional h = mapearHorarioBasico(rs);
                horarios.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

    /**
     * Busca un horario por ID
     */
    public HorarioProfesional buscarHorarioPorId(int idHorario) {
        String sql = "SELECT * FROM HorariosProfesional WHERE id_horario = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idHorario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapearHorarioBasico(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Actualiza un horario existente
     */
    public boolean actualizarHorario(HorarioProfesional horario) {
        String sql = "UPDATE HorariosProfesional SET id_profesional=?, dia_semana=?, hora_inicio=?, "
                + "hora_fin=?, duracion_consulta=?, activo=? WHERE id_horario=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, horario.getIdProfesional());
            stmt.setString(2, horario.getDiaSemana());
            stmt.setString(3, horario.getHoraInicio());
            stmt.setString(4, horario.getHoraFin());
            stmt.setInt(5, horario.getDuracionConsulta());
            stmt.setBoolean(6, horario.isActivo());
            stmt.setInt(7, horario.getIdHorario());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un horario
     */
    public boolean eliminarHorario(int idHorario) {
        String sql = "DELETE FROM HorariosProfesional WHERE id_horario = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idHorario);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== CONSULTAS ESPECÍFICAS ==========
    /**
     * Busca horarios activos de un profesional para un día específico
     */
    public List<HorarioProfesional> buscarHorariosPorDia(int idProfesional, String diaSemana) {
        List<HorarioProfesional> horarios = new ArrayList<>();
        String sql = "SELECT * FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND dia_semana = ? AND activo = TRUE";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, diaSemana);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                horarios.add(mapearHorarioBasico(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

    /**
     * Lista horarios con información del profesional (JOIN)
     */
    public List<HorarioProfesional> listarHorariosConDetalles() {
        List<HorarioProfesional> horarios = new ArrayList<>();
        String sql = "SELECT h.*, u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM HorariosProfesional h "
                + "INNER JOIN Profesionales p ON h.id_profesional = p.id_profesional "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON p.id_especialidad = e.id_especialidad "
                + "ORDER BY u.nombre_completo, h.dia_semana, h.hora_inicio";

        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                HorarioProfesional h = mapearHorarioCompleto(rs);
                horarios.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

    // ========== VALIDACIONES ==========
    /**
     * ✅ MEJORADO: Verifica si ya existe un horario que se superpone con el
     * nuevo
     */
    public boolean existeSolapamiento(int idProfesional, String diaSemana, String horaInicio, String horaFin) {
        String sql = "SELECT COUNT(*) as total FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND dia_semana = ? "
                + "AND (? < hora_fin AND ? > hora_inicio)";  // ✅ Lógica simplificada

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, diaSemana);
            stmt.setString(3, horaInicio);  // Nuevo inicio
            stmt.setString(4, horaFin);     // Nuevo fin

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ MEJORADO: Verifica solapamiento excluyendo un horario específico (para
     * editar)
     */
    public boolean existeSolapamientoExcepto(int idProfesional, String diaSemana, String horaInicio, String horaFin, int idHorario) {
        String sql = "SELECT COUNT(*) as total FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND dia_semana = ? AND id_horario != ? "
                + "AND (? < hora_fin AND ? > hora_inicio)";  // ✅ Lógica simplificada

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, diaSemana);
            stmt.setInt(3, idHorario);
            stmt.setString(4, horaInicio);
            stmt.setString(5, horaFin);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ NUEVO: Verifica si un profesional trabaja un día específico
     */
    public boolean trabajaEnDia(int idProfesional, String diaSemana) {
        String sql = "SELECT COUNT(*) as total FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND dia_semana = ? AND activo = TRUE";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, diaSemana);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== GENERACIÓN DE BLOQUES DE HORARIOS ==========
    /**
     * Genera bloques de horarios disponibles para un profesional en una fecha
     * específica Excluye los horarios ya ocupados por citas
     */
    public List<String> generarBloquesDisponibles(int idProfesional, String fecha, String diaSemana) {
        List<String> bloquesDisponibles = new ArrayList<>();

        try {
            // 1. Obtener configuración de horarios del profesional para ese día
            List<HorarioProfesional> configuraciones = buscarHorariosPorDia(idProfesional, diaSemana);

            if (configuraciones.isEmpty()) {
                return bloquesDisponibles; // No trabaja ese día
            }

            // 2. Para cada configuración (puede tener varios rangos en el mismo día)
            for (HorarioProfesional config : configuraciones) {
                List<String> bloques = generarBloques(
                        config.getHoraInicio(),
                        config.getHoraFin(),
                        config.getDuracionConsulta()
                );
                bloquesDisponibles.addAll(bloques);
            }

            // 3. Obtener horas ya ocupadas (citas existentes)
            List<String> horasOcupadas = obtenerHorasOcupadas(idProfesional, fecha);

            // 4. Filtrar bloques ocupados
            bloquesDisponibles.removeAll(horasOcupadas);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bloquesDisponibles;
    }

    /**
     * Genera bloques de tiempo entre hora inicio y hora fin Ejemplo: 08:00 -
     * 12:00 con duración 30 → [08:00, 08:30, 09:00, 09:30, 10:00, 10:30, 11:00,
     * 11:30]
     */
    private List<String> generarBloques(String horaInicio, String horaFin, int duracionMinutos) {
        List<String> bloques = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");

        try {
            LocalTime inicio = LocalTime.parse(horaInicio, formatter);
            LocalTime fin = LocalTime.parse(horaFin, formatter);

            LocalTime actual = inicio;
            while (actual.isBefore(fin)) {
                bloques.add(actual.format(formatter));
                actual = actual.plusMinutes(duracionMinutos);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bloques;
    }

    /**
     * Obtiene las horas ya ocupadas por citas en una fecha específica
     */
    private List<String> obtenerHorasOcupadas(int idProfesional, String fecha) {
        List<String> horasOcupadas = new ArrayList<>();
        String sql = "SELECT hora_cita FROM Citas "
                + "WHERE id_profesional = ? AND fecha_cita = ? AND estado != 'CANCELADA'";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, fecha);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String hora = rs.getString("hora_cita");
                // Convertir formato de TIME a HH:mm
                if (hora != null && hora.length() >= 5) {
                    horasOcupadas.add(hora.substring(0, 5)); // "10:30:00" → "10:30"
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return horasOcupadas;
    }

    // ========== ESTADÍSTICAS Y UTILIDADES ==========
    /**
     * ✅ NUEVO: Cuenta horarios activos de un profesional
     */
    public int contarHorariosActivos(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND activo = TRUE";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * ✅ NUEVO: Activa o desactiva un horario
     */
    public boolean cambiarEstadoHorario(int idHorario, boolean activo) {
        String sql = "UPDATE HorariosProfesional SET activo = ? WHERE id_horario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, activo);
            stmt.setInt(2, idHorario);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== MÉTODOS DE MAPEO ==========
    /**
     * Mapea ResultSet a objeto HorarioProfesional (básico)
     */
    private HorarioProfesional mapearHorarioBasico(ResultSet rs) throws SQLException {
        HorarioProfesional h = new HorarioProfesional();
        h.setIdHorario(rs.getInt("id_horario"));
        h.setIdProfesional(rs.getInt("id_profesional"));
        h.setDiaSemana(rs.getString("dia_semana"));
        h.setHoraInicio(rs.getString("hora_inicio"));
        h.setHoraFin(rs.getString("hora_fin"));
        h.setDuracionConsulta(rs.getInt("duracion_consulta"));
        h.setActivo(rs.getBoolean("activo"));

        try {
            h.setFechaCreacion(rs.getString("fecha_creacion"));
        } catch (SQLException e) {
            // Si no existe el campo, se ignora
        }

        return h;
    }

    /**
     * Mapea ResultSet a objeto HorarioProfesional (con JOIN)
     */
    private HorarioProfesional mapearHorarioCompleto(ResultSet rs) throws SQLException {
        HorarioProfesional h = mapearHorarioBasico(rs);
        h.setNombreProfesional(rs.getString("nombre_profesional"));
        h.setNombreEspecialidad(rs.getString("nombre_especialidad"));
        return h;
    }

    /**
     * Obtiene horarios activos de un profesional para un día específico
     */
    public List<HorarioProfesional> obtenerHorariosPorDia(int idProfesional, String diaSemana) {
        List<HorarioProfesional> horarios = new ArrayList<>();
        String sql = "SELECT * FROM HorariosProfesional "
                + "WHERE id_profesional = ? AND dia_semana = ? AND activo = TRUE "
                + "ORDER BY hora_inicio";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfesional);
            stmt.setString(2, diaSemana);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                HorarioProfesional horario = new HorarioProfesional();
                horario.setIdHorario(rs.getInt("id_horario"));
                horario.setIdProfesional(rs.getInt("id_profesional"));
                horario.setDiaSemana(rs.getString("dia_semana"));
                horario.setHoraInicio(rs.getString("hora_inicio"));
                horario.setHoraFin(rs.getString("hora_fin"));
                horario.setDuracionConsulta(rs.getInt("duracion_consulta"));
                horario.setActivo(rs.getBoolean("activo"));
                horarios.add(horario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

}
