package controller;

import dao.UsuarioDAO;
import dao.ProfesionalDAO;
import dao.PacienteDAO;
import dao.CitaDAO;
import model.Usuario;
import model.Cita;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DashboardAdminServlet")
public class DashboardAdminServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private ProfesionalDAO profesionalDAO;
    private PacienteDAO pacienteDAO;
    private CitaDAO citaDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        profesionalDAO = new ProfesionalDAO();
        pacienteDAO = new PacienteDAO();
        citaDAO = new CitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Verificar que sea administrador (rol 1)
        if (usuario.getIdRol() != 1) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            // ========== ESTADÍSTICAS GENERALES (TARJETAS PRINCIPALES) ==========

            // Total de usuarios activos
            int totalUsuarios = usuarioDAO.contarUsuariosActivos();
            request.setAttribute("totalUsuarios", totalUsuarios);

            // Total de profesionales
            int totalProfesionales = profesionalDAO.contarProfesionales();
            request.setAttribute("totalProfesionales", totalProfesionales);

            // Total de pacientes
            int totalPacientes = pacienteDAO.contarPacientes();
            request.setAttribute("totalPacientes", totalPacientes);

            // Citas programadas hoy
            int citasHoy = citaDAO.contarCitasHoy();
            request.setAttribute("citasHoy", citasHoy);

            // ========== ESTADÍSTICAS SECUNDARIAS ==========
            // Citas pendientes de confirmación
            int citasPendientes = citaDAO.contarCitasPendientesTodas();
            request.setAttribute("citasPendientes", citasPendientes);

            // ========== ESTADÍSTICAS DEL MES ==========
            // Total de citas del mes actual
            int citasMes = citaDAO.contarCitasMesActual();
            request.setAttribute("citasMes", citasMes);

            // Citas completadas del mes
            int citasCompletadas = citaDAO.contarCitasCompletadasMes();
            request.setAttribute("citasCompletadas", citasCompletadas);

            // Citas canceladas del mes
            int citasCanceladas = citaDAO.contarCitasCanceladasMes();
            request.setAttribute("citasCanceladas", citasCanceladas);

            // Pacientes nuevos del mes
            int pacientesMes = pacienteDAO.contarPacientesMesActual();
            request.setAttribute("pacientesMes", pacientesMes);

            // ========== CITAS RECIENTES ==========
            // Obtener las últimas 10 citas registradas
            List<Cita> citasRecientes = citaDAO.obtenerCitasRecientes(10);
            request.setAttribute("citasRecientes", citasRecientes);

            // ========== ESTADÍSTICAS POR ROL (OPCIONAL) ==========
            // Contar usuarios por rol
            int admins = usuarioDAO.contarUsuariosPorRol(1);
            int profesionalesMedicos = usuarioDAO.contarUsuariosPorRol(2);
            int profesionalesNoMedicos = usuarioDAO.contarUsuariosPorRol(3);

            request.setAttribute("totalAdmins", admins);
            request.setAttribute("totalProfesionalesMedicos", profesionalesMedicos);
            request.setAttribute("totalProfesionalesNoMedicos", profesionalesNoMedicos);

            // Forward a la página principal del dashboard
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
