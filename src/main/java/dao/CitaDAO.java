package dao;

import model.Cita;
import util.ConexionDB;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import util.GeneradorCodigos;

public class CitaDAO {

    public boolean insertarCita(Cita cita) {
        String sql = "INSERT INTO Citas (id_paciente, id_profesional, fecha_cita, hora_cita, motivo_consulta, estado, observaciones, id_recita) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, cita.getIdPaciente());
            stmt.setInt(2, cita.getIdProfesional());
            stmt.setString(3, cita.getFechaCita());
            stmt.setString(4, cita.getHoraCita());
            stmt.setString(5, cita.getMotivoConsulta());
            stmt.setString(6, cita.getEstado());
            stmt.setString(7, cita.getObservaciones());
            if (cita.getIdRecita() != null) {
                stmt.setInt(8, cita.getIdRecita());
            } else {
                stmt.setNull(8, java.sql.Types.INTEGER);
            }
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    cita.setIdCita(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Cita> listarCitasPorProfesional(int idProfesional) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT * FROM Citas WHERE id_profesional = ? ORDER BY fecha_cita DESC, hora_cita DESC";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setEstado(rs.getString("estado"));
                cita.setObservaciones(rs.getString("observaciones"));
                cita.setFechaCreacion(rs.getString("fecha_creacion"));
                cita.setIdRecita(rs.getObject("id_recita") != null ? rs.getInt("id_recita") : null);
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    public List<Cita> listarTodasCitas() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT * FROM Citas ORDER BY fecha_cita DESC, hora_cita DESC";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setEstado(rs.getString("estado"));
                cita.setObservaciones(rs.getString("observaciones"));
                cita.setFechaCreacion(rs.getString("fecha_creacion"));
                cita.setIdRecita(rs.getObject("id_recita") != null ? rs.getInt("id_recita") : null);
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    public Cita buscarCitaPorId(int idCita) {
        String sql = "SELECT * FROM Citas WHERE id_cita=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCita);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setEstado(rs.getString("estado"));
                cita.setObservaciones(rs.getString("observaciones"));
                cita.setFechaCreacion(rs.getString("fecha_creacion"));
                cita.setIdRecita(rs.getObject("id_recita") != null ? rs.getInt("id_recita") : null);
                return cita;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarCita(Cita cita) {
        String sql = "UPDATE Citas SET id_paciente=?, id_profesional=?, fecha_cita=?, hora_cita=?, motivo_consulta=?, estado=?, observaciones=?, id_recita=? WHERE id_cita=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cita.getIdPaciente());
            stmt.setInt(2, cita.getIdProfesional());
            stmt.setString(3, cita.getFechaCita());
            stmt.setString(4, cita.getHoraCita());
            stmt.setString(5, cita.getMotivoConsulta());
            stmt.setString(6, cita.getEstado());
            stmt.setString(7, cita.getObservaciones());
            if (cita.getIdRecita() != null) {
                stmt.setInt(8, cita.getIdRecita());
            } else {
                stmt.setNull(8, java.sql.Types.INTEGER);
            }
            stmt.setInt(9, cita.getIdCita());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarCita(int idCita) {
        String sql = "DELETE FROM Citas WHERE id_cita=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCita);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int contarCitasPorProfesionalEnMes(int idProfesional, int anio, int mes) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Citas WHERE id_profesional = ? AND YEAR(fecha_cita) = ? AND MONTH(fecha_cita) = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfesional);
            ps.setInt(2, anio);
            ps.setInt(3, mes);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int contarPacientesUnicosPorProfesional(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(DISTINCT id_paciente) FROM Citas WHERE id_profesional = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfesional);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public Map<String, Integer> contarCitasPorEstado(int idProfesional) {
        Map<String, Integer> map = new LinkedHashMap<>();  // ✅ Usar LinkedHashMap
        String sql = "SELECT estado, COUNT(*) FROM Citas WHERE id_profesional = ? GROUP BY estado";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfesional);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> contarCitasPorMesUltimos(int idProfesional, int cantidadMeses) {
        Map<String, Integer> map = new LinkedHashMap<>();

        // ✅ Pre-llenar con 0 para todos los meses
        LocalDate hoy = LocalDate.now();
        for (int i = cantidadMeses - 1; i >= 0; i--) {
            LocalDate mes = hoy.minusMonths(i);
            String mesFormato = mes.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            map.put(mesFormato, 0);  // Inicializar en 0
        }

        // Luego llenar con datos reales
        String sql = "SELECT DATE_FORMAT(fecha_cita, '%Y-%m') as mes, COUNT(*) as total "
                + "FROM Citas "
                + "WHERE id_profesional = ? "
                + "AND fecha_cita >= DATE_SUB(CURDATE(), INTERVAL ? MONTH) "
                + "GROUP BY mes ORDER BY mes";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfesional);
            ps.setInt(2, cantidadMeses - 1);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString("mes"), rs.getInt("total"));  // Sobrescribir con valor real
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ========== MÉTODOS ADICIONALES PARA DASHBOARD ADMIN ==========
    /**
     * Cuenta citas programadas para hoy
     */
    public int contarCitasHoy() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Citas WHERE fecha_cita = CURDATE()";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Cuenta citas pendientes (por atender) en todo el sistema
     */
    public int contarCitasPendientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Citas WHERE estado = 'PENDIENTE'";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Cuenta total de citas del mes actual
     */
    public int contarCitasMesActual() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Citas "
                + "WHERE MONTH(fecha_cita) = MONTH(CURDATE()) "
                + "AND YEAR(fecha_cita) = YEAR(CURDATE())";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Cuenta citas completadas del mes actual
     */
    public int contarCitasCompletadasMes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Citas "
                + "WHERE estado = 'COMPLETADA' "
                + "AND MONTH(fecha_cita) = MONTH(CURDATE()) "
                + "AND YEAR(fecha_cita) = YEAR(CURDATE())";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Cuenta citas canceladas del mes actual
     */
    public int contarCitasCanceladasMes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Citas "
                + "WHERE estado = 'CANCELADA' "
                + "AND MONTH(fecha_cita) = MONTH(CURDATE()) "
                + "AND YEAR(fecha_cita) = YEAR(CURDATE())";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Obtiene las citas recientes con información de paciente y profesional
     *
     * @param limite número máximo de citas a retornar
     */
    public List<Cita> obtenerCitasRecientes(int limite) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.id_cita, c.fecha_cita, c.hora_cita, c.estado, c.motivo_consulta, "
                + "c.id_paciente, c.id_profesional, "
                + "p.nombre_completo AS nombre_paciente, "
                + "u.nombre_completo AS nombre_profesional "
                + "FROM Citas c "
                + "INNER JOIN Pacientes p ON c.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "ORDER BY c.fecha_creacion DESC "
                + "LIMIT ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setEstado(rs.getString("estado"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setNombrePaciente(rs.getString("nombre_paciente"));
                cita.setNombreProfesional(rs.getString("nombre_profesional"));
                try {
                    if (cita.getFechaCita() != null && cita.getFechaCita().length() >= 4) {
                        int anio = Integer.parseInt(cita.getFechaCita().substring(0, 4));
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita(), anio));
                    }
                } catch (Exception e) {
                    cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                }
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    // ========== CONSULTAS CON JOIN (COMPLETAS) ==========
    /**
     * Lista todas las citas con detalles completos (nombres de paciente,
     * profesional, especialidad)
     */
    public List<Cita> listarCitasConDetalles() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "pac.email AS email_paciente, pac.telefono AS telefono_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Cita cita = mapearCitaCompleto(rs);
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Busca una cita por ID con detalles completos
     */
    public Cita buscarCitaPorIdConDetalles(int idCita) {
        Cita cita = null;
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombrePaciente, "
                + "pac.dni AS dniPaciente, "
                + "pac.telefono AS telefonoPaciente, "
                + "pac.email AS emailPaciente, "
                + "prof.nombre_completo AS nombreProfesional, "
                + "e.nombre AS nombreEspecialidad "
                + "FROM citas c "
                + "INNER JOIN pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN profesionales pr ON c.id_profesional = pr.id_profesional "
                + "INNER JOIN usuarios prof ON pr.id_usuario = prof.id_usuario "
                + "INNER JOIN especialidades e ON pr.id_especialidad = e.id_especialidad "
                + "WHERE c.id_cita = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCita);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setEstado(rs.getString("estado"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setObservaciones(rs.getString("observaciones"));

                // Datos del paciente
                cita.setNombrePaciente(rs.getString("nombrePaciente"));
                cita.setDniPaciente(rs.getString("dniPaciente"));
                cita.setTelefonoPaciente(rs.getString("telefonoPaciente"));
                cita.setEmailPaciente(rs.getString("emailPaciente"));

                // Datos del profesional
                cita.setNombreProfesional(rs.getString("nombreProfesional"));
                cita.setNombreEspecialidad(rs.getString("nombreEspecialidad"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cita;
    }

    /**
     * Lista citas de un profesional con detalles completos
     */
    public List<Cita> listarCitasPorProfesionalConDetalles(int idProfesional) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "pac.email AS email_paciente, pac.telefono AS telefono_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.id_profesional = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

// ========== FILTROS ADICIONALES ==========
    /**
     * Lista citas de un paciente específico con detalles
     */
    public List<Cita> listarCitasPorPacienteConDetalles(int idPaciente) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.id_paciente = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Lista citas por fecha específica con detalles
     */
    public List<Cita> listarCitasPorFechaConDetalles(String fecha) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.fecha_cita = ? "
                + "ORDER BY c.hora_cita ASC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fecha);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Lista citas por estado con detalles
     */
    public List<Cita> listarCitasPorEstadoConDetalles(String estado) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.estado = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, estado);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Lista citas en un rango de fechas con detalles
     */
    public List<Cita> listarCitasPorRangoFechasConDetalles(String fechaInicio, String fechaFin) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.fecha_cita BETWEEN ? AND ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fechaInicio);
            stmt.setString(2, fechaFin);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

// ========== VALIDACIONES ==========
    /**
     * Verifica si existe una cita en un horario específico para un profesional
     * Evita doble reserva (excluye citas canceladas)
     */
    public boolean existeCitaEnHorario(int idProfesional, String fecha, String hora) {
        String sql = "SELECT COUNT(*) as total FROM Citas "
                + "WHERE id_profesional = ? AND fecha_cita = ? AND hora_cita = ? "
                + "AND estado NOT IN ('CANCELADA')";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, fecha);
            stmt.setString(3, hora);
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
     * Verifica horario excluyendo una cita específica (para editar)
     */
    public boolean existeCitaEnHorarioExceptoCita(int idProfesional, String fecha, String hora, int idCita) {
        String sql = "SELECT COUNT(*) as total FROM Citas "
                + "WHERE id_profesional = ? AND fecha_cita = ? AND hora_cita = ? "
                + "AND id_cita != ? AND estado NOT IN ('CANCELADA')";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, fecha);
            stmt.setString(3, hora);
            stmt.setInt(4, idCita);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== CAMBIO DE ESTADO (USADOS POR PROFESIONALES) ==========
    /**
     * Cambia el estado de una cita
     */
    public boolean cambiarEstadoCita(int idCita, String nuevoEstado) {
        String sql = "UPDATE Citas SET estado = ? WHERE id_cita = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idCita);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ❌ OBSOLETO - Ya no se usa estado CONFIRMADA Mantener solo por
     * compatibilidad con código legacy
     */
    @Deprecated
    public boolean confirmarCita(int idCita) {
        return cambiarEstadoCita(idCita, "CONFIRMADA");
    }

    /**
     * Cancela una cita (PENDIENTE → CANCELADA) Usado por profesionales
     */
    public boolean cancelarCita(int idCita) {
        return cambiarEstadoCita(idCita, "CANCELADA");
    }

    /**
     * Completa una cita (PENDIENTE → COMPLETADA) Usado por profesionales
     */
    public boolean completarCita(int idCita) {
        return cambiarEstadoCita(idCita, "COMPLETADA");
    }

// ========== MÉTODOS DE MAPEO ==========
    /**
     * Mapea ResultSet a objeto Cita completo (con JOIN)
     */
    // En mapearCitaCompleto():
    private Cita mapearCitaCompleto(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setIdCita(rs.getInt("id_cita"));
        cita.setIdPaciente(rs.getInt("id_paciente"));
        cita.setIdProfesional(rs.getInt("id_profesional"));
        cita.setFechaCita(rs.getString("fecha_cita"));
        cita.setHoraCita(rs.getString("hora_cita"));
        cita.setMotivoConsulta(rs.getString("motivo_consulta"));
        cita.setEstado(rs.getString("estado"));
        cita.setObservaciones(rs.getString("observaciones"));
        cita.setFechaCreacion(rs.getString("fecha_creacion"));

        // Manejo de idRecita (puede ser null)
        int idRecita = rs.getInt("id_recita");
        cita.setIdRecita(rs.wasNull() ? null : idRecita);

        // Datos del JOIN (siempre presentes)
        cita.setNombrePaciente(rs.getString("nombre_paciente"));
        cita.setDniPaciente(rs.getString("dni_paciente"));
        cita.setNombreProfesional(rs.getString("nombre_profesional"));
        cita.setNombreEspecialidad(rs.getString("nombre_especialidad"));

        // Campos opcionales - verificar con ResultSetMetaData
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        boolean tieneEmailPaciente = false;
        boolean tieneTelefonoPaciente = false;

        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnName(i);
            if ("email_paciente".equalsIgnoreCase(columnName)) {
                tieneEmailPaciente = true;
            }
            if ("telefono_paciente".equalsIgnoreCase(columnName)) {
                tieneTelefonoPaciente = true;
            }
        }

        if (tieneEmailPaciente) {
            cita.setEmailPaciente(rs.getString("email_paciente"));
        }
        if (tieneTelefonoPaciente) {
            cita.setTelefonoPaciente(rs.getString("telefono_paciente"));
        }

        // ⬇️ AGREGAR ESTA LÍNEA - Generar código automáticamente
        try {
            if (cita.getFechaCita() != null && cita.getFechaCita().length() >= 4) {
                int anio = Integer.parseInt(cita.getFechaCita().substring(0, 4));
                cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita(), anio));
            } else {
                cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
            }
        } catch (Exception e) {
            cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
        }

        return cita;
    }

    // ========== MÉTODOS ESPECÍFICOS PARA DASHBOARD PROFESIONAL ==========
    /**
     * Lista las citas de un profesional para una fecha específica (agenda del
     * día)
     */
    public List<Cita> listarCitasDelDia(int idProfesional, String fecha) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "WHERE c.id_profesional = ? AND c.fecha_cita = ? "
                + "ORDER BY c.hora_cita ASC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, fecha);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setEstado(rs.getString("estado"));
                cita.setObservaciones(rs.getString("observaciones"));
                cita.setFechaCreacion(rs.getString("fecha_creacion"));
                int idRecita = rs.getInt("id_recita");
                cita.setIdRecita(rs.wasNull() ? null : idRecita);
                cita.setNombrePaciente(rs.getString("nombre_paciente"));
                cita.setDniPaciente(rs.getString("dni_paciente"));
                try {
                    if (cita.getFechaCita() != null && cita.getFechaCita().length() >= 4) {
                        int anio = Integer.parseInt(cita.getFechaCita().substring(0, 4));
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita(), anio));
                    }
                } catch (Exception e) {
                    cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                }
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Cuenta las citas pendientes de un profesional (estado CONFIRMADA)
     */
    public int contarCitasPendientes(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Citas "
                + "WHERE id_profesional = ? AND estado = 'PENDIENTE'";
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
     * Cuenta las citas completadas de un profesional
     */
    public int contarCitasCompletadas(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Citas "
                + "WHERE id_profesional = ? AND estado = 'COMPLETADA'";
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

    // En CitaDAO.java:
    public List<Cita> listarCitasPorProfesionalYEstado(int idProfesional, String estado) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "u.nombre_completo AS nombre_profesional, e.nombre AS nombre_especialidad "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "INNER JOIN Profesionales prof ON c.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "WHERE c.id_profesional = ? AND c.estado = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, estado);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCitaCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    /**
     * Lista citas de un profesional entre dos fechas con detalles
     */
    /**
     * Lista citas de un profesional entre dos fechas con detalles
     */
    public List<Cita> listarCitasPorProfesionalEntreFechas(int idProfesional, String fechaInicio, String fechaFin) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "pac.nombre_completo AS nombre_paciente, pac.dni AS dni_paciente, "
                + "pac.telefono AS telefono_paciente, pac.email AS email_paciente "
                + "FROM Citas c "
                + "INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente "
                + "WHERE c.id_profesional = ? "
                + "AND c.fecha_cita BETWEEN ? AND ? "
                + "ORDER BY c.fecha_cita ASC, c.hora_cita ASC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfesional);
            stmt.setString(2, fechaInicio);
            stmt.setString(3, fechaFin);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdProfesional(rs.getInt("id_profesional"));
                cita.setFechaCita(rs.getString("fecha_cita"));
                cita.setHoraCita(rs.getString("hora_cita"));
                cita.setMotivoConsulta(rs.getString("motivo_consulta"));
                cita.setEstado(rs.getString("estado"));
                cita.setObservaciones(rs.getString("observaciones"));
                cita.setFechaCreacion(rs.getString("fecha_creacion"));

                int idRecita = rs.getInt("id_recita");
                cita.setIdRecita(rs.wasNull() ? null : idRecita);

                cita.setNombrePaciente(rs.getString("nombre_paciente"));
                cita.setDniPaciente(rs.getString("dni_paciente"));
                cita.setTelefonoPaciente(rs.getString("telefono_paciente"));
                cita.setEmailPaciente(rs.getString("email_paciente"));
                try {
                    if (cita.getFechaCita() != null && cita.getFechaCita().length() >= 4) {
                        int anio = Integer.parseInt(cita.getFechaCita().substring(0, 4));
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita(), anio));
                    }
                } catch (Exception e) {
                    cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                }
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

    // Método para actualizar observaciones
    public boolean actualizarObservaciones(int idCita, String observaciones) {
        String sql = "UPDATE Citas SET observaciones = ? WHERE id_cita = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, observaciones);
            ps.setInt(2, idCita);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
