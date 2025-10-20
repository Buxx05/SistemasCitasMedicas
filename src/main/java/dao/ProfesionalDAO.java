package dao;

import model.Profesional;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.GeneradorCodigos;

public class ProfesionalDAO {

    public boolean insertarProfesional(Profesional profesional) {
        String sql = "INSERT INTO Profesionales (id_usuario, id_especialidad, numero_licencia, telefono) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, profesional.getIdUsuario());
            stmt.setInt(2, profesional.getIdEspecialidad());
            stmt.setString(3, profesional.getNumeroLicencia());
            stmt.setString(4, profesional.getTelefono());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    profesional.setIdProfesional(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Profesional> listarProfesionales() {
        List<Profesional> profesionales = new ArrayList<>();
        String sql = "SELECT * FROM Profesionales ORDER BY id_profesional";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));

                // ✅ AGREGAR estos campos
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    public Profesional buscarProfesionalPorId(int idProfesional) {
        String sql = "SELECT * FROM Profesionales WHERE id_profesional=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));

                // ✅ AGREGAR mapeo de nuevos campos
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                return profesional;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarProfesional(Profesional profesional) {
        String sql = "UPDATE Profesionales SET id_usuario=?, id_especialidad=?, numero_licencia=?, telefono=? WHERE id_profesional=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profesional.getIdUsuario());
            stmt.setInt(2, profesional.getIdEspecialidad());
            stmt.setString(3, profesional.getNumeroLicencia());
            stmt.setString(4, profesional.getTelefono());
            stmt.setInt(5, profesional.getIdProfesional());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarProfesional(int idProfesional) {
        String sql = "DELETE FROM Profesionales WHERE id_profesional=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfesional);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== MÉTODOS PARA DASHBOARD ADMIN ==========
    /**
     * Cuenta el total de profesionales registrados
     */
    public int contarProfesionales() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Profesionales";
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
     * Cuenta profesionales médicos (rol 2 del usuario vinculado)
     */
    public int contarProfesionalesMedicos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "WHERE u.id_rol = 2 AND u.activo = TRUE";
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
     * Cuenta profesionales por especialidad
     */
    public int contarProfesionalesPorEspecialidad(int idEspecialidad) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Profesionales WHERE id_especialidad = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idEspecialidad);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // ========== CONSULTAS MEJORADAS CON JOIN ==========
    /**
     * Lista todos los profesionales con información completa Incluye: nombre
     * usuario, email, especialidad, rol, estado
     */
    public List<Profesional> listarProfesionalesConDetalles() {
        List<Profesional> profesionales = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, "
                + "e.nombre AS nombre_especialidad, r.nombre AS nombre_rol "
                + "FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON p.id_especialidad = e.id_especialidad "
                + "INNER JOIN Roles r ON u.id_rol = r.id_rol "
                + "ORDER BY u.nombre_completo";

        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));

                // Datos del usuario
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol")); // ⬅️ AGREGAR ESTO
                profesional.setActivo(rs.getBoolean("activo"));

                // Datos adicionales
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));

                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                // ⬇️ MODIFICAR ESTA LÍNEA - Ahora usa idRol
                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesional(
                                profesional.getIdProfesional(),
                                profesional.getIdRol() // ⬅️ AGREGAR idRol
                        )
                );

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    /**
     * Busca un profesional por ID con información completa
     */
    public Profesional buscarProfesionalPorIdConDetalles(int idProfesional) {
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, "
                + "e.nombre AS nombre_especialidad, r.nombre AS nombre_rol "
                + "FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON p.id_especialidad = e.id_especialidad "
                + "INNER JOIN Roles r ON u.id_rol = r.id_rol "
                + "WHERE p.id_profesional = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfesional);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));

                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                // Datos del usuario
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol")); // ⬅️ AGREGAR ESTO
                profesional.setActivo(rs.getBoolean("activo"));

                // Datos adicionales
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));

                // ⬇️ MODIFICAR ESTA LÍNEA
                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesional(
                                profesional.getIdProfesional(),
                                profesional.getIdRol() // ⬅️ AGREGAR idRol
                        )
                );

                return profesional;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Busca un profesional por el ID del usuario Útil para verificar si un
     * usuario ya es profesional
     */
    public Profesional buscarProfesionalPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM Profesionales WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));

                // ✅ AGREGAR estos campos
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                return profesional;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// ========== VALIDACIONES ==========
    /**
     * Verifica si ya existe un profesional con ese número de licencia Útil al
     * crear un nuevo profesional
     */
    public boolean existeLicencia(String numeroLicencia) {
        String sql = "SELECT COUNT(*) as total FROM Profesionales WHERE numero_licencia = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numeroLicencia);
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
     * Verifica si existe una licencia, excluyendo un profesional específico
     * Útil al editar (puede mantener su propia licencia)
     */
    public boolean existeLicenciaExceptoProfesional(String numeroLicencia, int idProfesional) {
        String sql = "SELECT COUNT(*) as total FROM Profesionales "
                + "WHERE numero_licencia = ? AND id_profesional != ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numeroLicencia);
            stmt.setInt(2, idProfesional);
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
     * Verifica si un usuario ya está registrado como profesional Evita
     * duplicados al crear
     */
    public boolean usuarioEsProfesional(int idUsuario) {
        String sql = "SELECT COUNT(*) as total FROM Profesionales WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// ========== ACTUALIZACIÓN OPTIMIZADA ==========
    /**
     * Actualiza solo los datos profesionales (sin cambiar el usuario vinculado)
     * Para formularios de edición donde solo se cambia especialidad, licencia,
     * teléfono
     */
    public boolean actualizarDatosProfesional(Profesional profesional) {
        String sql = "UPDATE Profesionales SET id_especialidad=?, numero_licencia=?, telefono=? "
                + "WHERE id_profesional=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profesional.getIdEspecialidad());
            stmt.setString(2, profesional.getNumeroLicencia());
            stmt.setString(3, profesional.getTelefono());
            stmt.setInt(4, profesional.getIdProfesional());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

// ========== CONSULTAS ADICIONALES ==========
    /**
     * Lista profesionales activos (usuarios activos)
     */
    public List<Profesional> listarProfesionalesActivos() {
        List<Profesional> profesionales = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, "
                + "e.nombre AS nombre_especialidad, r.nombre AS nombre_rol "
                + "FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON p.id_especialidad = e.id_especialidad "
                + "INNER JOIN Roles r ON u.id_rol = r.id_rol "
                + "WHERE u.activo = TRUE "
                + "ORDER BY u.nombre_completo";

        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol")); // ⬅️ AGREGAR ESTO
                profesional.setActivo(rs.getBoolean("activo"));
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                // ⬇️ MODIFICAR ESTA LÍNEA
                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesional(
                                profesional.getIdProfesional(),
                                profesional.getIdRol() // ⬅️ AGREGAR idRol
                        )
                );

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    /**
     * Lista profesionales por especialidad
     */
    public List<Profesional> listarProfesionalesPorEspecialidad(int idEspecialidad) {
        List<Profesional> profesionales = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.activo, "
                + "e.nombre AS nombre_especialidad "
                + "FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "INNER JOIN Especialidades e ON p.id_especialidad = e.id_especialidad "
                + "WHERE p.id_especialidad = ? AND u.activo = TRUE "
                + "ORDER BY u.nombre_completo";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idEspecialidad);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setActivo(rs.getBoolean("activo"));
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                // ✅ En cada while (rs.next()) de estos métodos, agregar:
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    /**
     * Cuenta profesionales no médicos (rol 3)
     */
    public int contarProfesionalesNoMedicos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "WHERE u.id_rol = 3 AND u.activo = TRUE";
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
     * Obtiene el ID del profesional a partir del ID del usuario
     */
    public int obtenerIdProfesionalPorIdUsuario(int idUsuario) {
        String sql = "SELECT id_profesional FROM Profesionales WHERE id_usuario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id_profesional");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Retorna 0 si no encuentra
    }

    /**
     * Actualiza TODOS los datos del profesional incluyendo biografía y
     * experiencia Útil para formularios de perfil completo
     */
    public boolean actualizarProfesionalCompleto(Profesional profesional) {
        String sql = "UPDATE Profesionales SET id_especialidad=?, numero_licencia=?, telefono=?, "
                + "biografia_profesional=?, anios_experiencia=? WHERE id_profesional=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profesional.getIdEspecialidad());
            stmt.setString(2, profesional.getNumeroLicencia());
            stmt.setString(3, profesional.getTelefono());
            stmt.setString(4, profesional.getBiografiaProfesional());
            stmt.setInt(5, profesional.getAniosExperiencia());
            stmt.setInt(6, profesional.getIdProfesional());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
