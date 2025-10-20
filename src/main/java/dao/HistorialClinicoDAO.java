package dao;

import model.HistorialClinico;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialClinicoDAO {

    // ========== CREAR ==========
    /**
     * Inserta una nueva entrada en el historial clínico
     */
    public boolean insertarHistorial(HistorialClinico historial) {
        String sql = "INSERT INTO HistorialClinico "
                + "(id_paciente, id_profesional, id_cita, fecha_registro, fecha_hora_registro, "
                + "sintomas, diagnostico, tratamiento, observaciones) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, historial.getIdPaciente());
            stmt.setInt(2, historial.getIdProfesional());

            if (historial.getIdCita() != null) {
                stmt.setInt(3, historial.getIdCita());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setString(4, historial.getFechaRegistro());
            stmt.setString(5, historial.getFechaHoraRegistro());
            stmt.setString(6, historial.getSintomas());
            stmt.setString(7, historial.getDiagnostico());
            stmt.setString(8, historial.getTratamiento());
            stmt.setString(9, historial.getObservaciones());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    historial.setIdHistorial(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== LISTAR ==========
    /**
     * Lista todas las entradas del historial de un paciente con un profesional
     * específico
     */
    public List<HistorialClinico> listarHistorialPorPacienteYProfesional(int idPaciente, int idProfesional) {
        List<HistorialClinico> historiales = new ArrayList<>();
        String sql = "SELECT h.*, "
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita "
                + "FROM HistorialClinico h "
                + "INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON h.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "LEFT JOIN Citas c ON h.id_cita = c.id_cita "
                + "WHERE h.id_paciente = ? AND h.id_profesional = ? "
                + "ORDER BY h.fecha_hora_registro DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                historiales.add(mapearHistorial(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historiales;
    }

    /**
     * Lista todas las entradas del historial de un paciente (todos los
     * profesionales)
     */
    public List<HistorialClinico> listarHistorialPorPaciente(int idPaciente) {
        List<HistorialClinico> historiales = new ArrayList<>();
        String sql = "SELECT h.*, "
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita "
                + "FROM HistorialClinico h "
                + "INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON h.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "LEFT JOIN Citas c ON h.id_cita = c.id_cita "
                + "WHERE h.id_paciente = ? "
                + "ORDER BY h.fecha_hora_registro DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                historiales.add(mapearHistorial(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historiales;
    }

    // ========== BUSCAR ==========
    /**
     * Busca una entrada específica del historial por ID
     */
    public HistorialClinico buscarHistorialPorId(int idHistorial) {
        String sql = "SELECT h.*, "
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita "
                + "FROM HistorialClinico h "
                + "INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON h.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "LEFT JOIN Citas c ON h.id_cita = c.id_cita "
                + "WHERE h.id_historial = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idHistorial);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearHistorial(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========== ACTUALIZAR ==========
    /**
     * Actualiza una entrada del historial
     */
    public boolean actualizarHistorial(HistorialClinico historial) {
        String sql = "UPDATE HistorialClinico "
                + "SET sintomas = ?, diagnostico = ?, tratamiento = ?, observaciones = ? "
                + "WHERE id_historial = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, historial.getSintomas());
            stmt.setString(2, historial.getDiagnostico());
            stmt.setString(3, historial.getTratamiento());
            stmt.setString(4, historial.getObservaciones());
            stmt.setInt(5, historial.getIdHistorial());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== ELIMINAR ==========
    /**
     * Elimina una entrada del historial
     */
    public boolean eliminarHistorial(int idHistorial) {
        String sql = "DELETE FROM HistorialClinico WHERE id_historial = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idHistorial);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== ESTADÍSTICAS ==========
    /**
     * Cuenta el total de entradas del historial de un paciente
     */
    public int contarEntradasPorPaciente(int idPaciente) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM HistorialClinico WHERE id_paciente = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
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
     * Cuenta entradas del historial entre un paciente y un profesional
     */
    public int contarEntradasPorPacienteYProfesional(int idPaciente, int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM HistorialClinico "
                + "WHERE id_paciente = ? AND id_profesional = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfesional);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // ========== MÉTODO AUXILIAR ==========
    /**
     * Mapea ResultSet a objeto HistorialClinico
     */
    private HistorialClinico mapearHistorial(ResultSet rs) throws SQLException {
        HistorialClinico historial = new HistorialClinico();
        historial.setIdHistorial(rs.getInt("id_historial"));
        historial.setIdPaciente(rs.getInt("id_paciente"));
        historial.setIdProfesional(rs.getInt("id_profesional"));

        // ✅ MEJORADO: Obtener id_cita del ResultSet
        int idCita = rs.getInt("id_cita");
        historial.setIdCita(rs.wasNull() ? null : idCita);

        historial.setFechaRegistro(rs.getString("fecha_registro"));
        historial.setFechaHoraRegistro(rs.getString("fecha_hora_registro"));
        historial.setSintomas(rs.getString("sintomas"));
        historial.setDiagnostico(rs.getString("diagnostico"));
        historial.setTratamiento(rs.getString("tratamiento"));
        historial.setObservaciones(rs.getString("observaciones"));

        // Datos del JOIN
        historial.setNombrePaciente(rs.getString("nombre_paciente"));
        historial.setDniPaciente(rs.getString("dni_paciente"));
        historial.setNombreProfesional(rs.getString("nombre_profesional"));
        historial.setNombreEspecialidad(rs.getString("nombre_especialidad"));
        historial.setFechaCita(rs.getString("fecha_cita"));
        historial.setHoraCita(rs.getString("hora_cita"));

        return historial;
    }
}
