package dao;

import model.Profesional;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.GeneradorCodigos;

public class ProfesionalDAO {

    // ========== INSERTAR PROFESIONAL ==========
    public boolean insertarProfesional(Profesional profesional) {
        // ❌ QUITAR 'dni' del SQL - El DNI ya está en la tabla Usuarios
        String sql = "INSERT INTO Profesionales (id_usuario, id_especialidad, numero_licencia, telefono) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, profesional.getIdUsuario());
            stmt.setInt(2, profesional.getIdEspecialidad());
            stmt.setString(3, profesional.getNumeroLicencia());
            stmt.setString(4, profesional.getTelefono());
            // ❌ NO incluir DNI aquí

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

    // ========== LISTAR PROFESIONALES ==========
    public List<Profesional> listarProfesionales() {
        List<Profesional> profesionales = new ArrayList<>();
        // ✅ AGREGAR JOIN con Usuarios para obtener el DNI
        String sql = "SELECT p.*, u.dni FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "ORDER BY p.id_profesional";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Profesional profesional = new Profesional();
                profesional.setIdProfesional(rs.getInt("id_profesional"));
                profesional.setIdUsuario(rs.getInt("id_usuario"));
                profesional.setIdEspecialidad(rs.getInt("id_especialidad"));
                profesional.setNumeroLicencia(rs.getString("numero_licencia"));
                profesional.setTelefono(rs.getString("telefono"));
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));
                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    // ========== BUSCAR PROFESIONAL POR ID ==========
    public Profesional buscarProfesionalPorId(int idProfesional) {
        // ✅ AGREGAR JOIN con Usuarios para obtener el DNI
        String sql = "SELECT p.*, u.dni FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "WHERE p.id_profesional=?";
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));
                return profesional;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========== ACTUALIZAR PROFESIONAL ==========
    public boolean actualizarProfesional(Profesional profesional) {
        // ❌ QUITAR 'dni=?' del SQL - El DNI se actualiza en la tabla Usuarios
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

    // ========== ELIMINAR PROFESIONAL ==========
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
    public List<Profesional> listarProfesionalesConDetalles() {
        List<Profesional> profesionales = new ArrayList<>();
        // ✅ AGREGAR u.dni en el SELECT
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, u.dni, "
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios

                // Datos del usuario
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol"));
                profesional.setActivo(rs.getBoolean("activo"));

                // Datos adicionales
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesionalPorUsuario(
                                profesional.getIdUsuario(), // ✅ Usa idUsuario
                                profesional.getIdRol()
                        )
                );

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    public Profesional buscarProfesionalPorIdConDetalles(int idProfesional) {
        // ✅ AGREGAR u.dni en el SELECT
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, u.dni, "
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                // Datos del usuario
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol"));
                profesional.setActivo(rs.getBoolean("activo"));

                // Datos adicionales
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));

                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesionalPorUsuario(
                                profesional.getIdUsuario(), // ✅ Usa idUsuario
                                profesional.getIdRol()
                        )
                );

                return profesional;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Profesional buscarProfesionalPorUsuario(int idUsuario) {
        // ✅ AGREGAR JOIN para obtener DNI
        String sql = "SELECT p.*, u.dni FROM Profesionales p "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "WHERE p.id_usuario = ?";
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
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

    // ========== VALIDACIONES DE DNI (CAMBIAR A TABLA USUARIOS) ==========
    /**
     * Verifica si ya existe un usuario con ese DNI ✅ Busca en la tabla
     * Usuarios, no en Profesionales
     */
    public boolean existeDNI(String dni) {
        String sql = "SELECT COUNT(*) as total FROM Usuarios WHERE dni = ?";
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
     * Verifica si existe un DNI, excluyendo un usuario específico ✅ Busca en la
     * tabla Usuarios, no en Profesionales
     */
    public boolean existeDNIExceptoProfesional(String dni, int idProfesional) {
        String sql = "SELECT COUNT(*) as total FROM Usuarios u "
                + "INNER JOIN Profesionales p ON u.id_usuario = p.id_usuario "
                + "WHERE u.dni = ? AND p.id_profesional != ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
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

    // ========== ACTUALIZACIÓN OPTIMIZADA ==========
    public boolean actualizarDatosProfesional(Profesional profesional) {
        // ❌ QUITAR 'dni=?' - El DNI se actualiza en UsuarioDAO
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
    public List<Profesional> listarProfesionalesActivos() {
        List<Profesional> profesionales = new ArrayList<>();
        // ✅ AGREGAR u.dni en el SELECT
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.id_rol, u.activo, u.dni, "
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setIdRol(rs.getInt("id_rol"));
                profesional.setActivo(rs.getBoolean("activo"));
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setNombreRol(rs.getString("nombre_rol"));
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                profesional.setCodigoProfesional(
                        GeneradorCodigos.generarCodigoProfesionalPorUsuario(
                                profesional.getIdUsuario(), // ✅ Usa idUsuario
                                profesional.getIdRol()
                        )
                );

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

    public List<Profesional> listarProfesionalesPorEspecialidad(int idEspecialidad) {
        List<Profesional> profesionales = new ArrayList<>();
        // ✅ AGREGAR u.dni en el SELECT
        String sql = "SELECT p.*, u.nombre_completo, u.email, u.activo, u.dni, "
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
                profesional.setDni(rs.getString("dni")); // ✅ Leer desde usuarios
                profesional.setNombreUsuario(rs.getString("nombre_completo"));
                profesional.setEmailUsuario(rs.getString("email"));
                profesional.setActivo(rs.getBoolean("activo"));
                profesional.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                profesional.setBiografiaProfesional(rs.getString("biografia_profesional"));
                profesional.setAniosExperiencia(rs.getInt("anios_experiencia"));

                profesionales.add(profesional);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profesionales;
    }

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
        return 0;
    }

    public boolean actualizarProfesionalCompleto(Profesional profesional) {
        // ❌ QUITAR 'dni=?' - El DNI se actualiza en UsuarioDAO
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
        }
        return false;
    }
}
