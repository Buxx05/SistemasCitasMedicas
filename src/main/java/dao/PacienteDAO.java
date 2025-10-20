package dao;

import model.Paciente;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.GeneradorCodigos;

public class PacienteDAO {

    public boolean insertarPaciente(Paciente paciente) {
        String sql = "INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, direccion, telefono, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, paciente.getNombreCompleto());
            stmt.setString(2, paciente.getDni());
            stmt.setString(3, paciente.getFechaNacimiento());
            stmt.setString(4, paciente.getGenero());
            stmt.setString(5, paciente.getDireccion());
            stmt.setString(6, paciente.getTelefono());
            stmt.setString(7, paciente.getEmail());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    paciente.setIdPaciente(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Paciente> listarPacientes() {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM Pacientes ORDER BY nombre_completo";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));

                // ⬇️ AGREGAR ESTA LÍNEA - Generar código automáticamente
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );

                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

    public Paciente buscarPacientePorId(int idPaciente) {
        String sql = "SELECT * FROM Pacientes WHERE id_paciente=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                return paciente;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarPaciente(Paciente paciente) {
        String sql = "UPDATE Pacientes SET nombre_completo=?, dni=?, fecha_nacimiento=?, genero=?, direccion=?, telefono=?, email=? WHERE id_paciente=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paciente.getNombreCompleto());
            stmt.setString(2, paciente.getDni());
            stmt.setString(3, paciente.getFechaNacimiento());
            stmt.setString(4, paciente.getGenero());
            stmt.setString(5, paciente.getDireccion());
            stmt.setString(6, paciente.getTelefono());
            stmt.setString(7, paciente.getEmail());
            stmt.setInt(8, paciente.getIdPaciente());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPaciente(int idPaciente) {
        String sql = "DELETE FROM Pacientes WHERE id_paciente=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== MÉTODOS PARA DASHBOARD ADMIN ==========
    /**
     * Cuenta el total de pacientes registrados
     */
    public int contarPacientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Pacientes";
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
     * Cuenta pacientes registrados hoy
     */
    public int contarPacientesHoy() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Pacientes WHERE DATE(fecha_registro) = CURDATE()";
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
     * Cuenta pacientes registrados en el mes actual
     */
    public int contarPacientesMesActual() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Pacientes "
                + "WHERE MONTH(fecha_registro) = MONTH(CURDATE()) "
                + "AND YEAR(fecha_registro) = YEAR(CURDATE())";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // ========== VALIDACIONES ==========
    /**
     * Verifica si ya existe un paciente con ese DNI Útil al crear un nuevo
     * paciente
     */
    public boolean existeDNI(String dni) {
        String sql = "SELECT COUNT(*) as total FROM Pacientes WHERE dni = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
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
     * Verifica si existe un DNI, excluyendo un paciente específico Útil al
     * editar (puede mantener su propio DNI)
     */
    public boolean existeDNIExceptoPaciente(String dni, int idPaciente) {
        String sql = "SELECT COUNT(*) as total FROM Pacientes WHERE dni = ? AND id_paciente != ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
            stmt.setInt(2, idPaciente);
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
     * Verifica si ya existe un paciente con ese email (opcional)
     */
    public boolean existeEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false; // Email vacío no se valida
        }
        String sql = "SELECT COUNT(*) as total FROM Pacientes WHERE email = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// ========== BÚSQUEDAS ADICIONALES ==========
    /**
     * Busca un paciente por su DNI
     */
    public Paciente buscarPacientePorDNI(String dni) {
        String sql = "SELECT * FROM Pacientes WHERE dni = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                return paciente;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lista pacientes cuyo nombre contenga el texto buscado Útil para búsqueda
     * en tiempo real
     */
    public List<Paciente> buscarPacientesPorNombre(String nombre) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM Pacientes WHERE nombre_completo LIKE ? ORDER BY nombre_completo";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + nombre + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

    /**
     * Lista pacientes por género
     */
    public List<Paciente> listarPacientesPorGenero(String genero) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM Pacientes WHERE genero = ? ORDER BY nombre_completo";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, genero);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

// ========== ESTADÍSTICAS ADICIONALES ==========
    /**
     * Cuenta pacientes por género
     */
    public int contarPacientesPorGenero(String genero) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Pacientes WHERE genero = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, genero);
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
     * Cuenta pacientes registrados en un rango de fechas
     */
    public int contarPacientesEntreFechas(String fechaInicio, String fechaFin) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Pacientes "
                + "WHERE DATE(fecha_registro) BETWEEN ? AND ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fechaInicio);
            stmt.setString(2, fechaFin);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // ========== MÉTODOS PARA PROFESIONALES ==========
    /**
     * Lista los pacientes que ha atendido un profesional específico Solo
     * muestra pacientes con al menos una cita COMPLETADA
     */
    public List<Paciente> listarPacientesPorProfesional(int idProfesional) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT DISTINCT p.* "
                + "FROM Pacientes p "
                + "INNER JOIN Citas c ON p.id_paciente = c.id_paciente "
                + "WHERE c.id_profesional = ? "
                + "  AND c.estado = 'COMPLETADA' "
                + "ORDER BY p.nombre_completo";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

    /**
     * Busca pacientes por DNI o nombre dentro de los pacientes del profesional
     * Solo busca entre pacientes que el profesional ha atendido
     */
    public List<Paciente> buscarPacientesPorDniONombre(String busqueda, int idProfesional) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT DISTINCT p.* "
                + "FROM Pacientes p "
                + "INNER JOIN Citas c ON p.id_paciente = c.id_paciente "
                + "WHERE c.id_profesional = ? "
                + "  AND (p.dni LIKE ? OR p.nombre_completo LIKE ?) "
                + "ORDER BY p.nombre_completo";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            stmt.setString(2, "%" + busqueda + "%");
            stmt.setString(3, "%" + busqueda + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

    /**
     * Obtiene estadísticas de un paciente con un profesional específico
     * Retorna: [totalCitas, citasCompletadas, citasCanceladas]
     */
    public int[] obtenerEstadisticasPaciente(int idPaciente, int idProfesional) {
        int[] stats = new int[3]; // [total, completadas, canceladas]

        String sql = "SELECT "
                + "  COUNT(*) as total, "
                + "  SUM(CASE WHEN estado = 'COMPLETADA' THEN 1 ELSE 0 END) as completadas, "
                + "  SUM(CASE WHEN estado = 'CANCELADA' THEN 1 ELSE 0 END) as canceladas "
                + "FROM Citas "
                + "WHERE id_paciente = ? AND id_profesional = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfesional);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getInt("total");
                stats[1] = rs.getInt("completadas");
                stats[2] = rs.getInt("canceladas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Obtiene la fecha de la última cita de un paciente con un profesional
     * Retorna null si no hay citas
     */
    public String obtenerUltimaCita(int idPaciente, int idProfesional) {
        String ultimaFecha = null;
        String sql = "SELECT MAX(fecha_cita) as ultima_fecha "
                + "FROM Citas "
                + "WHERE id_paciente = ? AND id_profesional = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfesional);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ultimaFecha = rs.getString("ultima_fecha");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ultimaFecha;
    }

    /**
     * Lista pacientes del profesional con información adicional Incluye: última
     * cita, total de citas, citas completadas
     */
    public List<Paciente> listarPacientesConEstadisticas(int idProfesional) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT DISTINCT p.*, "
                + "  MAX(c.fecha_cita) as ultima_cita, "
                + "  COUNT(c.id_cita) as total_citas, "
                + "  SUM(CASE WHEN c.estado = 'COMPLETADA' THEN 1 ELSE 0 END) as citas_completadas "
                + "FROM Pacientes p "
                + "INNER JOIN Citas c ON p.id_paciente = c.id_paciente "
                + "WHERE c.id_profesional = ? "
                + "GROUP BY p.id_paciente "
                + "ORDER BY MAX(c.fecha_cita) DESC";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setIdPaciente(rs.getInt("id_paciente"));
                paciente.setNombreCompleto(rs.getString("nombre_completo"));
                paciente.setDni(rs.getString("dni"));
                paciente.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                paciente.setFechaRegistro(rs.getString("fecha_registro"));

                // ✅ Mapear campos adicionales
                paciente.setUltimaCita(rs.getString("ultima_cita"));
                paciente.setTotalCitas(rs.getInt("total_citas"));
                paciente.setCitasCompletadas(rs.getInt("citas_completadas"));
                paciente.setCodigoPaciente(
                        GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente())
                );
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }

}
