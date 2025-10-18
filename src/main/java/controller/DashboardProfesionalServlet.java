package controller;

import dao.CitaDAO;
import dao.ProfesionalDAO;
import model.Usuario;
import model.Cita;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/DashboardProfesionalServlet")
public class DashboardProfesionalServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private ProfesionalDAO profesionalDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        profesionalDAO = new ProfesionalDAO();
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

        // Solo profesionales (rol 2 y 3)
        if (usuario.getIdRol() != 2 && usuario.getIdRol() != 3) {
            response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
            return;
        }

        try {
            // Obtener ID del profesional
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                session.setAttribute("error", "No se encontró información del profesional. Contacta al administrador.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // ========== ESTADÍSTICAS ==========
            // Total de citas este mes
            int totalCitasMes = citaDAO.contarCitasPorProfesionalEnMes(
                    idProfesional,
                    LocalDate.now().getYear(),
                    LocalDate.now().getMonthValue()
            );

            // Citas completadas
            int citasCompletadas = citaDAO.contarCitasCompletadas(idProfesional);

            // Citas pendientes (CONFIRMADA)
            int citasPendientes = citaDAO.contarCitasPendientes(idProfesional);

            // Total de pacientes únicos atendidos
            int totalPacientesUnicos = citaDAO.contarPacientesUnicosPorProfesional(idProfesional);

            // ========== AGENDA DEL DÍA ==========
            String hoy = LocalDate.now().toString(); // Formato: 2025-10-17
            List<Cita> citasHoy = citaDAO.listarCitasDelDia(idProfesional, hoy);

            // Validar null
            if (citasHoy == null) {
                citasHoy = new ArrayList<>();
            }

            // ========== GRÁFICOS ==========
            // Citas por estado
            Map<String, Integer> citasPorEstado = citaDAO.contarCitasPorEstado(idProfesional);
            if (citasPorEstado == null) {
                citasPorEstado = new HashMap<>();
            }

            Gson gson = new Gson();
            String citasPorEstadoJson = gson.toJson(citasPorEstado);

            // Citas por mes (últimos 6 meses)
            Map<String, Integer> citasPorMes = citaDAO.contarCitasPorMesUltimos(idProfesional, 6);
            if (citasPorMes == null) {
                citasPorMes = new HashMap<>();
            }

            String citasPorMesJson = gson.toJson(citasPorMes);

            // ========== ATRIBUTOS PARA JSP ==========
            request.setAttribute("totalCitasMes", totalCitasMes);
            request.setAttribute("citasCompletadas", citasCompletadas);
            request.setAttribute("citasPendientes", citasPendientes);
            request.setAttribute("totalPacientesUnicos", totalPacientesUnicos);
            request.setAttribute("citasHoy", citasHoy);
            request.setAttribute("citasPorEstadoJson", citasPorEstadoJson);
            request.setAttribute("citasPorMesJson", citasPorMesJson);

            request.getRequestDispatcher("/profesional/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el dashboard: " + e.getMessage());
            request.getRequestDispatcher("/profesional/dashboard.jsp").forward(request, response);
        }
    }
}
