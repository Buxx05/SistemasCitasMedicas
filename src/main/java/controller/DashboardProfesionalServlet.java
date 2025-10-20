package controller;

import dao.CitaDAO;
import dao.ProfesionalDAO;
import model.Usuario;
import model.Cita;
import util.GeneradorCodigos;
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
            session.setAttribute("error", "Esta sección es solo para profesionales médicos");
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

            // ========== FECHA ACTUAL ==========
            LocalDate fechaActual = LocalDate.now();
            String hoy = fechaActual.toString(); // Formato: 2025-10-19

            // ========== ESTADÍSTICAS GENERALES ==========
            // Total de citas este mes
            int totalCitasMes = citaDAO.contarCitasPorProfesionalEnMes(
                    idProfesional,
                    fechaActual.getYear(),
                    fechaActual.getMonthValue()
            );

            // Citas completadas
            int citasCompletadas = citaDAO.contarCitasCompletadas(idProfesional);

            // Citas pendientes
            int citasPendientes = citaDAO.contarCitasPendientes(idProfesional);

            // Total de pacientes únicos atendidos
            int totalPacientesUnicos = citaDAO.contarPacientesUnicosPorProfesional(idProfesional);

            // ========== AGENDA DEL DÍA ==========
            List<Cita> citasHoy = citaDAO.listarCitasDelDia(idProfesional, hoy);

            // Validar null y generar códigos
            if (citasHoy == null) {
                citasHoy = new ArrayList<>();
            } else {
                // Generar códigos para las citas del día
                for (Cita cita : citasHoy) {
                    if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                    }
                }
            }

            // ========== ESTADÍSTICAS ADICIONALES ==========
            // Tasa de asistencia del mes (porcentaje)
            double tasaAsistencia = 0.0;
            if (totalCitasMes > 0) {
                tasaAsistencia = (citasCompletadas * 100.0) / totalCitasMes;
            }

            // Promedio de citas por día del mes
            int diasTranscurridos = fechaActual.getDayOfMonth();
            double promedioCitasDia = diasTranscurridos > 0 ? (double) totalCitasMes / diasTranscurridos : 0.0;

            // ========== GRÁFICOS ==========
            // Citas por estado
            Map<String, Integer> citasPorEstado = citaDAO.contarCitasPorEstado(idProfesional);
            if (citasPorEstado == null) {
                citasPorEstado = new HashMap<>();
                // Valores por defecto si no hay datos
                citasPorEstado.put("PENDIENTE", 0);
                citasPorEstado.put("COMPLETADA", 0);
                citasPorEstado.put("CANCELADA", 0);
            }

            Gson gson = new Gson();
            String citasPorEstadoJson = gson.toJson(citasPorEstado);

            // Citas por mes (últimos 6 meses)
            Map<String, Integer> citasPorMes = citaDAO.contarCitasPorMesUltimos(idProfesional, 6);
            if (citasPorMes == null) {
                citasPorMes = new LinkedHashMap<>(); // Mantener orden
            }

            String citasPorMesJson = gson.toJson(citasPorMes);

            // ========== ATRIBUTOS PARA JSP ==========
            // Estadísticas principales
            request.setAttribute("totalCitasMes", totalCitasMes);
            request.setAttribute("citasCompletadas", citasCompletadas);
            request.setAttribute("citasPendientes", citasPendientes);
            request.setAttribute("totalPacientesUnicos", totalPacientesUnicos);

            // Estadísticas adicionales
            request.setAttribute("tasaAsistencia", Math.round(tasaAsistencia));
            request.setAttribute("promedioCitasDia", String.format("%.1f", promedioCitasDia));

            // Agenda del día
            request.setAttribute("citasHoy", citasHoy);
            request.setAttribute("totalCitasHoy", citasHoy.size());
            request.setAttribute("fechaHoy", hoy);

            // Datos para gráficos
            request.setAttribute("citasPorEstadoJson", citasPorEstadoJson);
            request.setAttribute("citasPorMesJson", citasPorMesJson);

            // ID del profesional (útil para JavaScript)
            request.setAttribute("idProfesional", idProfesional);

            request.getRequestDispatcher("/profesional/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession sesion = request.getSession();
            sesion.setAttribute("error", "Error al cargar el dashboard: " + e.getMessage());
            // ✅ Enviar flag de error para mostrar mensaje en JSP
            request.setAttribute("errorCargaDatos", true);
            request.getRequestDispatcher("/profesional/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
