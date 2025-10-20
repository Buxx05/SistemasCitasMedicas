package dao;

import model.RecetaMedica;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecetaMedicaDAO {

    // ========== CREAR ==========
    /**
     * Inserta una nueva receta médica
     */
    public boolean insertarReceta(RecetaMedica receta) {
        String sql = "INSERT INTO RecetasMedicas "
                + "(id_cita, id_profesional, id_paciente, fecha_emision, "
                + "indicaciones, medicamentos, dosis, frecuencia, duracion, fecha_vigencia, observaciones) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, receta.getIdCita());
            stmt.setInt(2, receta.getIdProfesional());
            stmt.setInt(3, receta.getIdPaciente());
            stmt.setString(4, receta.getFechaEmision());
            stmt.setString(5, receta.getIndicaciones());
            stmt.setString(6, receta.getMedicamentos());
            stmt.setString(7, receta.getDosis());
            stmt.setString(8, receta.getFrecuencia());
            stmt.setString(9, receta.getDuracion());
            stmt.setString(10, receta.getFechaVigencia());
            stmt.setString(11, receta.getObservaciones());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    receta.setIdReceta(generatedKeys.getInt(1));
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
     * Lista todas las recetas de un profesional
     */
    public List<RecetaMedica> listarRecetasPorProfesional(int idProfesional) {
        List<RecetaMedica> recetas = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_profesional = ? "
                + "ORDER BY r.fecha_emision DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recetas.add(mapearReceta(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recetas;
    }

    /**
     * Lista solo recetas vigentes de un profesional
     */
    public List<RecetaMedica> listarRecetasVigentesPorProfesional(int idProfesional) {
        List<RecetaMedica> recetas = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_profesional = ? "
                + "AND r.fecha_vigencia >= CURDATE() "
                + "ORDER BY r.fecha_emision DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recetas.add(mapearReceta(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recetas;
    }

    /**
     * Lista todas las recetas de un paciente
     */
    public List<RecetaMedica> listarRecetasPorPaciente(int idPaciente) {
        List<RecetaMedica> recetas = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_paciente = ? "
                + "ORDER BY r.fecha_emision DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recetas.add(mapearReceta(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recetas;
    }

    /**
     * Lista recetas de un paciente con un profesional específico
     */
    public List<RecetaMedica> listarRecetasPorPacienteYProfesional(int idPaciente, int idProfesional) {
        List<RecetaMedica> recetas = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_paciente = ? AND r.id_profesional = ? "
                + "ORDER BY r.fecha_emision DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recetas.add(mapearReceta(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recetas;
    }

    /**
     * Lista recetas de una cita específica
     */
    public List<RecetaMedica> listarRecetasPorCita(int idCita) {
        List<RecetaMedica> recetas = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_cita = ? "
                + "ORDER BY r.fecha_emision DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCita);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recetas.add(mapearReceta(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recetas;
    }

    // ========== BUSCAR ==========
    /**
     * Busca una receta por ID
     */
    public RecetaMedica buscarRecetaPorId(int idReceta) {
        String sql = "SELECT r.*, "
                + "       p.id_paciente, " // ✅ AGREGADO
                + "       p.nombre_completo AS nombre_paciente, "
                + "       p.dni AS dni_paciente, "
                + "       u.nombre_completo AS nombre_profesional, "
                + "       e.nombre AS nombre_especialidad, "
                + "       c.id_cita, " // ✅ AGREGADO
                + "       c.fecha_cita, "
                + "       c.hora_cita, "
                + "       c.motivo_consulta "
                + "FROM RecetasMedicas r "
                + "INNER JOIN Pacientes p ON r.id_paciente = p.id_paciente "
                + "INNER JOIN Profesionales prof ON r.id_profesional = prof.id_profesional "
                + "INNER JOIN Usuarios u ON prof.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON prof.id_especialidad = e.id_especialidad "
                + "INNER JOIN Citas c ON r.id_cita = c.id_cita "
                + "WHERE r.id_receta = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idReceta);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearReceta(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========== ACTUALIZAR ==========
    /**
     * Actualiza una receta médica
     */
    public boolean actualizarReceta(RecetaMedica receta) {
        String sql = "UPDATE RecetasMedicas "
                + "SET indicaciones = ?, medicamentos = ?, dosis = ?, "
                + "frecuencia = ?, duracion = ?, fecha_vigencia = ?, observaciones = ? "
                + "WHERE id_receta = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, receta.getIndicaciones());
            stmt.setString(2, receta.getMedicamentos());
            stmt.setString(3, receta.getDosis());
            stmt.setString(4, receta.getFrecuencia());
            stmt.setString(5, receta.getDuracion());
            stmt.setString(6, receta.getFechaVigencia());
            stmt.setString(7, receta.getObservaciones());
            stmt.setInt(8, receta.getIdReceta());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== ELIMINAR ==========
    /**
     * Elimina una receta médica
     */
    public boolean eliminarReceta(int idReceta) {
        String sql = "DELETE FROM RecetasMedicas WHERE id_receta = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idReceta);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== ESTADÍSTICAS ==========
    /**
     * Cuenta recetas emitidas por un profesional
     */
    public int contarRecetasPorProfesional(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM RecetasMedicas WHERE id_profesional = ?";

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
     * Cuenta recetas vigentes de un profesional
     */
    public int contarRecetasVigentesPorProfesional(int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM RecetasMedicas "
                + "WHERE id_profesional = ? AND fecha_vigencia >= CURDATE()";

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
     * Cuenta recetas de un paciente con un profesional
     */
    public int contarRecetasPorPacienteYProfesional(int idPaciente, int idProfesional) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM RecetasMedicas "
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
     * Mapea ResultSet a objeto RecetaMedica
     */
    private RecetaMedica mapearReceta(ResultSet rs) throws SQLException {
        RecetaMedica receta = new RecetaMedica();

        // ✅ IDs principales (ya vienen de r.*)
        receta.setIdReceta(rs.getInt("id_receta"));
        receta.setIdCita(rs.getInt("id_cita"));
        receta.setIdProfesional(rs.getInt("id_profesional"));
        receta.setIdPaciente(rs.getInt("id_paciente"));

        // Datos de la receta
        receta.setFechaEmision(rs.getString("fecha_emision"));
        receta.setIndicaciones(rs.getString("indicaciones"));
        receta.setMedicamentos(rs.getString("medicamentos"));
        receta.setDosis(rs.getString("dosis"));
        receta.setFrecuencia(rs.getString("frecuencia"));
        receta.setDuracion(rs.getString("duracion"));
        receta.setFechaVigencia(rs.getString("fecha_vigencia"));
        receta.setObservaciones(rs.getString("observaciones"));

        // Datos del JOIN
        receta.setNombrePaciente(rs.getString("nombre_paciente"));
        receta.setDniPaciente(rs.getString("dni_paciente"));
        receta.setNombreProfesional(rs.getString("nombre_profesional"));
        receta.setNombreEspecialidad(rs.getString("nombre_especialidad"));
        receta.setFechaCita(rs.getString("fecha_cita"));
        receta.setHoraCita(rs.getString("hora_cita"));
        receta.setMotivoConsulta(rs.getString("motivo_consulta"));

        return receta;
    }
}
