package dao;

import model.Especialidad;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EspecialidadDAO {

    // ========== CRUD BÁSICO ==========
    public List<Especialidad> listarEspecialidades() {
        List<Especialidad> especialidades = new ArrayList<>();
        String sql = "SELECT * FROM Especialidades ORDER BY nombre";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Especialidad esp = new Especialidad();
                esp.setIdEspecialidad(rs.getInt("id_especialidad"));
                esp.setNombre(rs.getString("nombre"));
                esp.setDescripcion(rs.getString("descripcion"));
                especialidades.add(esp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return especialidades;
    }

    public Especialidad buscarEspecialidadPorId(int idEspecialidad) {
        String sql = "SELECT * FROM Especialidades WHERE id_especialidad=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idEspecialidad);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Especialidad esp = new Especialidad();
                esp.setIdEspecialidad(rs.getInt("id_especialidad"));
                esp.setNombre(rs.getString("nombre"));
                esp.setDescripcion(rs.getString("descripcion"));
                return esp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertarEspecialidad(Especialidad especialidad) {
        String sql = "INSERT INTO Especialidades (nombre, descripcion) VALUES (?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, especialidad.getNombre());
            stmt.setString(2, especialidad.getDescripcion());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    especialidad.setIdEspecialidad(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizarEspecialidad(Especialidad especialidad) {
        String sql = "UPDATE Especialidades SET nombre=?, descripcion=? WHERE id_especialidad=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, especialidad.getNombre());
            stmt.setString(2, especialidad.getDescripcion());
            stmt.setInt(3, especialidad.getIdEspecialidad());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarEspecialidad(int idEspecialidad) {
        String sql = "DELETE FROM Especialidades WHERE id_especialidad=?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idEspecialidad);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== VALIDACIONES ==========
    public boolean existeNombre(String nombre) {
        String sql = "SELECT COUNT(*) as total FROM Especialidades WHERE nombre = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existeNombreExceptoEspecialidad(String nombre, int idEspecialidad) {
        String sql = "SELECT COUNT(*) as total FROM Especialidades WHERE nombre = ? AND id_especialidad != ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre);
            stmt.setInt(2, idEspecialidad);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== CONSULTAS ADICIONALES ==========
    public int contarProfesionalesPorEspecialidad(int idEspecialidad) {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Profesionales WHERE id_especialidad = ?";
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

    public List<Especialidad> listarEspecialidadesActivas() {
        List<Especialidad> especialidades = new ArrayList<>();
        String sql = "SELECT DISTINCT e.* FROM Especialidades e "
                + "INNER JOIN Profesionales p ON e.id_especialidad = p.id_especialidad "
                + "INNER JOIN Usuarios u ON p.id_usuario = u.id_usuario "
                + "WHERE u.activo = TRUE "
                + "ORDER BY e.nombre";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Especialidad esp = new Especialidad();
                esp.setIdEspecialidad(rs.getInt("id_especialidad"));
                esp.setNombre(rs.getString("nombre"));
                esp.setDescripcion(rs.getString("descripcion"));
                especialidades.add(esp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return especialidades;
    }

    public int contarEspecialidades() {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Especialidades";
        try (Connection conn = ConexionDB.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
}
