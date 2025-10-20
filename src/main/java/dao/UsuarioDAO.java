package dao;

import model.Usuario;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.GeneradorCodigos;

public class UsuarioDAO {

    public Usuario autenticar(String email, String password) {
        String sql = "SELECT * FROM Usuarios WHERE email = ? AND password = ? AND activo = TRUE";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("email"));
                // NO guardar password en sesión
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setActivo(rs.getBoolean("activo"));

                // Agregar foto de perfil si existe
                String fotoPerfil = rs.getString("foto_perfil");
                usuario.setFotoPerfil(fotoPerfil);

                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertarUsuario(Usuario usuario) {
        String sql = "INSERT INTO Usuarios (nombre_completo, email, password, id_rol) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, usuario.getNombreCompleto());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getPassword());
            stmt.setInt(4, usuario.getIdRol());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    usuario.setIdUsuario(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Usuario> listarUsuarios() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM Usuarios ORDER BY id_rol, nombre_completo";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("email"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }

    public Usuario buscarUsuarioPorId(int idUsuario) {
        String sql = "SELECT * FROM Usuarios WHERE id_usuario=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setActivo(rs.getBoolean("activo"));
                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarUsuario(Usuario usuario) {
        String sql = "UPDATE Usuarios SET nombre_completo=?, email=?, password=?, id_rol=?, activo=? WHERE id_usuario=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, usuario.getNombreCompleto());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getPassword());
            stmt.setInt(4, usuario.getIdRol());
            stmt.setBoolean(5, usuario.isActivo());
            stmt.setInt(6, usuario.getIdUsuario());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarUsuario(int idUsuario) {
        String sql = "DELETE FROM Usuarios WHERE id_usuario=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== MÉTODOS PARA DASHBOARD ADMIN ==========
    /**
     * Cuenta el total de usuarios activos en el sistema
     */
    public int contarUsuariosActivos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Usuarios WHERE activo = TRUE";
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
     * Cuenta usuarios por rol específico (solo activos)
     */
    public int contarUsuariosPorRol(int idRol) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Usuarios WHERE id_rol = ? AND activo = TRUE";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idRol);
            ResultSet rs = stmt.executeQuery();
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
     * Verifica si un email ya existe en la base de datos Útil al crear un nuevo
     * usuario
     */
    public boolean existeEmail(String email) {
        String sql = "SELECT COUNT(*) as total FROM Usuarios WHERE email = ?";
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

    /**
     * Verifica si un email ya existe, excluyendo un usuario específico Útil al
     * editar un usuario (puede mantener su propio email)
     */
    public boolean existeEmailExceptoUsuario(String email, int idUsuario) {
        String sql = "SELECT COUNT(*) as total FROM Usuarios WHERE email = ? AND id_usuario != ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, idUsuario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// ========== CONSULTAS MEJORADAS CON JOIN ==========
    /**
     * Lista todos los usuarios con el nombre del rol incluido Usa JOIN para
     * evitar consultas adicionales
     */
    public List<Usuario> listarUsuariosConRol() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.*, r.nombre as nombre_rol "
                + "FROM Usuarios u "
                + "INNER JOIN Roles r ON u.id_rol = r.id_rol "
                + "ORDER BY u.nombre_completo";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("email"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setNombreRol(rs.getString("nombre_rol"));

                // ⬇️ AGREGAR ESTA LÍNEA
                usuario.setCodigoUsuario(GeneradorCodigos.generarCodigoUsuario(
                        usuario.getIdRol(),
                        usuario.getIdUsuario()
                ));

                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }

    /**
     * Busca un usuario por ID con el nombre del rol incluido Usa JOIN para
     * traer el nombre del rol en una sola consulta
     */
    public Usuario buscarUsuarioPorIdConRol(int idUsuario) {
        String sql = "SELECT u.*, r.nombre as nombre_rol "
                + "FROM Usuarios u "
                + "INNER JOIN Roles r ON u.id_rol = r.id_rol "
                + "WHERE u.id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setNombreRol(rs.getString("nombre_rol")); // Nombre del rol
                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Actualiza un usuario SIN cambiar la contraseña Útil cuando el usuario no
     * quiere cambiar su password
     */
    public boolean actualizarUsuarioSinPassword(Usuario usuario) {
        String sql = "UPDATE Usuarios SET nombre_completo=?, email=?, id_rol=?, activo=? WHERE id_usuario=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, usuario.getNombreCompleto());
            stmt.setString(2, usuario.getEmail());
            stmt.setInt(3, usuario.getIdRol());
            stmt.setBoolean(4, usuario.isActivo());
            stmt.setInt(5, usuario.getIdUsuario());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== MÉTODOS PARA PERFIL ==========
    /**
     * Actualiza el perfil del usuario (sin contraseña)
     */
    /**
     * Actualiza el perfil del usuario (sin contraseña ni foto)
     */
    public boolean actualizarPerfil(Usuario usuario) {
        String sql = "UPDATE Usuarios SET nombre_completo = ?, telefono = ?, "
                + "direccion = ?, biografia = ? WHERE id_usuario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNombreCompleto());
            stmt.setString(2, usuario.getTelefono());
            stmt.setString(3, usuario.getDireccion());
            stmt.setString(4, usuario.getBiografia());
            stmt.setInt(5, usuario.getIdUsuario());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cambia la contraseña del usuario
     */
    public boolean cambiarPassword(int idUsuario, String passwordAntigua, String passwordNueva) {
        // 1. Verificar que la contraseña antigua sea correcta
        String sqlVerificar = "SELECT password FROM Usuarios WHERE id_usuario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmtVerificar = conn.prepareStatement(sqlVerificar)) {

            stmtVerificar.setInt(1, idUsuario);
            ResultSet rs = stmtVerificar.executeQuery();

            if (rs.next()) {
                String passwordActual = rs.getString("password");

                // Comparar contraseña (si está hasheada, usa el método de comparación apropiado)
                if (!passwordActual.equals(passwordAntigua)) {
                    return false; // Contraseña antigua incorrecta
                }

                // 2. Actualizar con la nueva contraseña
                String sqlActualizar = "UPDATE Usuarios SET password = ? WHERE id_usuario = ?";
                try (PreparedStatement stmtActualizar = conn.prepareStatement(sqlActualizar)) {
                    stmtActualizar.setString(1, passwordNueva);
                    stmtActualizar.setInt(2, idUsuario);
                    return stmtActualizar.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Actualiza solo la foto de perfil
     */
    public boolean actualizarFotoPerfil(int idUsuario, String nombreArchivo) {
        String sql = "UPDATE Usuarios SET foto_perfil = ? WHERE id_usuario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nombreArchivo);
            stmt.setInt(2, idUsuario);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Busca usuario por ID con información completa (incluyendo nuevos campos)
     */
    public Usuario buscarUsuarioPorIdCompleto(int idUsuario) {
        String sql = "SELECT * FROM Usuarios WHERE id_usuario = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setDni(rs.getString("dni"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setDireccion(rs.getString("direccion"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));

                // Nuevos campos
                usuario.setFotoPerfil(rs.getString("foto_perfil"));
                usuario.setBiografia(rs.getString("biografia"));
                usuario.setFechaActualizacion(rs.getString("fecha_actualizacion"));

                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Actualiza el perfil profesional (solo para profesionales)
     */
    public boolean actualizarPerfilProfesional(int idProfesional, String biografiaProfesional, int aniosExperiencia) {
        String sql = "UPDATE Profesionales SET biografia_profesional = ?, anios_experiencia = ? "
                + "WHERE id_profesional = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, biografiaProfesional);
            stmt.setInt(2, aniosExperiencia);
            stmt.setInt(3, idProfesional);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
