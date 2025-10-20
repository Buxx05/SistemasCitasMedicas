package controller;

import dao.CitaDAO;
import dao.ProfesionalDAO;
import model.Usuario;
import model.Cita;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.*;

@WebServlet("/CalendarioServlet")
public class CalendarioServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Solo profesionales (rol 2 y 3)
        if (usuario.getIdRol() != 2 && usuario.getIdRol() != 3) {
            // ✅ Mejorado: mensaje más específico
            session.setAttribute("error", "Esta sección es solo para profesionales médicos");
            response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "ver";
        }

        switch (accion) {
            case "ver":
                mostrarCalendario(request, response, usuario);
                break;
            case "detalle":
                obtenerDetalleCita(request, response, usuario);
                break;
            default:
                mostrarCalendario(request, response, usuario);
        }
    }

    /**
     * Muestra el calendario de citas del profesional
     */
    private void mostrarCalendario(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                // ✅ Consistente con SweetAlert2 (tipo "error")
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Obtener mes y año
            String mesParam = request.getParameter("mes");
            String anioParam = request.getParameter("anio");

            LocalDate hoy = LocalDate.now();
            int mes = mesParam != null ? Integer.parseInt(mesParam) : hoy.getMonthValue();
            int anio = anioParam != null ? Integer.parseInt(anioParam) : hoy.getYear();

            YearMonth yearMonth = YearMonth.of(anio, mes);
            LocalDate primerDia = yearMonth.atDay(1);
            LocalDate ultimoDia = yearMonth.atEndOfMonth();

            // Obtener citas del mes
            List<Cita> citasDelMes = citaDAO.listarCitasPorProfesionalEntreFechas(
                    idProfesional,
                    primerDia.toString(),
                    ultimoDia.toString()
            );

            // Convertir a eventos para FullCalendar
            List<Map<String, Object>> eventos = new ArrayList<>();

            for (Cita cita : citasDelMes) {
                Map<String, Object> evento = new HashMap<>();
                evento.put("id", cita.getIdCita());

                // Título: Paciente - Hora
                String nombrePaciente = cita.getNombrePaciente() != null ? cita.getNombrePaciente() : "Sin nombre";
                String hora = cita.getHoraCita() != null && cita.getHoraCita().length() >= 5
                        ? cita.getHoraCita().substring(0, 5)
                        : "??:??";

                evento.put("title", nombrePaciente + " - " + hora);
                evento.put("start", cita.getFechaCita() + "T" + cita.getHoraCita());
                evento.put("allDay", false);
                evento.put("estado", cita.getEstado());

                // ✅ COLORES CORRECTOS (Amarillo: Pendiente, Verde: Completada, Rojo: Cancelada)
                String className = "";
                String color = "#6c757d";
                String textColor = "#ffffff";

                switch (cita.getEstado()) {
                    case "PENDIENTE":
                        className = "evento-pendiente";
                        color = "#ffc107"; // warning (amarillo)
                        textColor = "#000000";
                        break;
                    case "CONFIRMADA":
                        className = "evento-confirmada";
                        color = "#ffc107"; // warning (amarillo) - igual que pendiente
                        textColor = "#000000";
                        break;
                    case "COMPLETADA":
                        className = "evento-completada";
                        color = "#28a745"; // success (verde)
                        textColor = "#ffffff";
                        break;
                    case "CANCELADA":
                        className = "evento-cancelada";
                        color = "#dc3545"; // danger (rojo)
                        textColor = "#ffffff";
                        break;
                    default:
                        className = "evento-default";
                        color = "#6c757d"; // secondary (gris)
                        textColor = "#ffffff";
                }

                evento.put("className", className);
                evento.put("backgroundColor", color);
                evento.put("borderColor", color);
                evento.put("textColor", textColor);

                // Información adicional para el tooltip
                evento.put("extendedProps", new HashMap<String, Object>() {
                    {
                        put("nombrePaciente", nombrePaciente);
                        put("dniPaciente", cita.getDniPaciente());
                        put("motivoConsulta", cita.getMotivoConsulta());
                        put("estado", cita.getEstado());
                    }
                });

                eventos.add(evento);
            }

            // Convertir a JSON
            Gson gson = new Gson();
            String eventosJson = gson.toJson(eventos);

            // Calcular estadísticas del mes
            Map<String, Integer> estadisticas = calcularEstadisticasMes(citasDelMes);

            request.setAttribute("idProfesional", idProfesional);
            request.setAttribute("mes", mes);
            request.setAttribute("anio", anio);
            request.setAttribute("nombreMes", primerDia.getMonth().getDisplayName(TextStyle.FULL, new Locale("es", "ES")));
            request.setAttribute("eventosJson", eventosJson);
            request.setAttribute("totalCitas", estadisticas.get("total"));
            request.setAttribute("citasPendientes", estadisticas.get("pendientes"));
            request.setAttribute("citasConfirmadas", estadisticas.get("confirmadas"));
            request.setAttribute("citasCompletadas", estadisticas.get("completadas"));
            request.setAttribute("citasCanceladas", estadisticas.get("canceladas"));

            request.getRequestDispatcher("/profesional/calendario.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // ✅ Agregado: manejo específico para errores de formato
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Los parámetros de mes y año deben ser numéricos válidos");
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            // ✅ Mejorado: mensaje más descriptivo
            session.setAttribute("error", "Error al cargar el calendario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    /**
     * Obtiene el detalle de una cita específica (AJAX)
     */
    private void obtenerDetalleCita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                response.getWriter().write("{\"error\": \"No se encontró información del profesional\"}");
                return;
            }

            String idParam = request.getParameter("idCita");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.getWriter().write("{\"error\": \"ID de cita no especificado\"}");
                return;
            }

            int idCita = Integer.parseInt(idParam);

            // Buscar cita con detalles completos
            Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);

            if (cita == null) {
                response.getWriter().write("{\"error\": \"Cita no encontrada\"}");
                return;
            }

            // Verificar que la cita pertenece al profesional
            if (cita.getIdProfesional() != idProfesional) {
                response.getWriter().write("{\"error\": \"No tienes permiso para ver esta cita\"}");
                return;
            }

            // Crear objeto JSON manualmente para tener control total
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"idCita\":").append(cita.getIdCita()).append(",");
            json.append("\"idPaciente\":").append(cita.getIdPaciente()).append(",");
            json.append("\"estado\":\"").append(cita.getEstado()).append("\",");
            json.append("\"fechaCita\":\"").append(cita.getFechaCita()).append("\",");
            json.append("\"horaCita\":\"").append(cita.getHoraCita()).append("\",");
            json.append("\"motivoConsulta\":\"").append(escapeJson(cita.getMotivoConsulta())).append("\",");

            if (cita.getObservaciones() != null && !cita.getObservaciones().isEmpty()) {
                json.append("\"observaciones\":\"").append(escapeJson(cita.getObservaciones())).append("\",");
            }

            // Datos del paciente
            json.append("\"nombrePaciente\":\"").append(escapeJson(cita.getNombrePaciente())).append("\",");
            json.append("\"dniPaciente\":\"").append(escapeJson(cita.getDniPaciente())).append("\",");
            json.append("\"telefonoPaciente\":\"").append(escapeJson(cita.getTelefonoPaciente())).append("\",");
            json.append("\"emailPaciente\":\"").append(escapeJson(cita.getEmailPaciente())).append("\"");

            json.append("}");

            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"error\": \"ID de cita inválido\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"Error al cargar el detalle: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    /**
     * Calcula estadísticas de las citas del mes
     */
    private Map<String, Integer> calcularEstadisticasMes(List<Cita> citas) {
        Map<String, Integer> stats = new HashMap<>();

        int total = citas != null ? citas.size() : 0;
        int pendientes = 0;
        int confirmadas = 0;
        int completadas = 0;
        int canceladas = 0;

        if (citas != null) {
            for (Cita cita : citas) {
                switch (cita.getEstado()) {
                    case "PENDIENTE":
                        pendientes++;
                        break;
                    case "CONFIRMADA":
                        confirmadas++;
                        break;
                    case "COMPLETADA":
                        completadas++;
                        break;
                    case "CANCELADA":
                        canceladas++;
                        break;
                }
            }
        }

        stats.put("total", total);
        stats.put("pendientes", pendientes);
        stats.put("confirmadas", confirmadas);
        stats.put("completadas", completadas);
        stats.put("canceladas", canceladas);

        return stats;
    }
}
