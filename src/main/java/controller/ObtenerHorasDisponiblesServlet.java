package controller;

import dao.HorarioProfesionalDAO;
import dao.CitaDAO;
import model.HorarioProfesional;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/ObtenerHorasDisponiblesServlet")
public class ObtenerHorasDisponiblesServlet extends HttpServlet {

    private HorarioProfesionalDAO horarioDAO;
    private CitaDAO citaDAO;

    @Override
    public void init() {
        horarioDAO = new HorarioProfesionalDAO();
        citaDAO = new CitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Validar parámetros
            String idProfesionalParam = request.getParameter("idProfesional");
            String fecha = request.getParameter("fecha");

            if (idProfesionalParam == null || idProfesionalParam.trim().isEmpty()) {
                enviarRespuestaError(response, "ID de profesional no especificado");
                return;
            }

            if (fecha == null || fecha.trim().isEmpty()) {
                enviarRespuestaError(response, "Fecha no especificada");
                return;
            }

            int idProfesional;
            try {
                idProfesional = Integer.parseInt(idProfesionalParam);
            } catch (NumberFormatException e) {
                enviarRespuestaError(response, "ID de profesional inválido");
                return;
            }

            // Parsear fecha
            LocalDate localDate;
            try {
                localDate = LocalDate.parse(fecha);
            } catch (DateTimeParseException e) {
                enviarRespuestaError(response, "Formato de fecha inválido. Use yyyy-MM-dd");
                return;
            }

            // Validar que no sea fecha pasada
            LocalDate hoy = LocalDate.now();
            if (localDate.isBefore(hoy)) {
                enviarRespuestaError(response, "No se pueden agendar citas en fechas pasadas");
                return;
            }

            // Obtener día de la semana (LUNES, MARTES, etc.)
            String diaSemana = localDate.getDayOfWeek()
                    .getDisplayName(TextStyle.FULL, new Locale("es", "ES"))
                    .toUpperCase();

            // Normalizar día (sin acentos)
            diaSemana = normalizarDiaSemana(diaSemana);

            // Obtener horarios del profesional para ese día
            List<HorarioProfesional> horarios = horarioDAO.obtenerHorariosPorDia(idProfesional, diaSemana);

            if (horarios == null || horarios.isEmpty()) {
                enviarRespuestaError(response, "No hay horarios configurados para " + diaSemana.toLowerCase());
                return;
            }

            // Generar todas las horas disponibles
            List<Map<String, Object>> horasDisponibles = new ArrayList<>();

            for (HorarioProfesional horario : horarios) {
                // Saltar horarios inactivos
                if (!horario.isActivo()) {
                    continue;
                }

                LocalTime inicio = LocalTime.parse(horario.getHoraInicio());
                LocalTime fin = LocalTime.parse(horario.getHoraFin());
                int duracion = horario.getDuracionConsulta();

                LocalTime actual = inicio;
                while (actual.plusMinutes(duracion).isBefore(fin)
                        || actual.plusMinutes(duracion).equals(fin)) {

                    String horaStr = actual.toString();

                    // Si es hoy, verificar que la hora no haya pasado
                    boolean horaPasada = false;
                    if (localDate.equals(hoy)) {
                        LocalTime ahora = LocalTime.now();
                        if (actual.isBefore(ahora)) {
                            horaPasada = true;
                        }
                    }

                    // Verificar si está ocupada
                    boolean ocupada = citaDAO.existeCitaEnHorario(idProfesional, fecha, horaStr + ":00");

                    // Solo agregar si no es hora pasada
                    if (!horaPasada) {
                        Map<String, Object> slot = new HashMap<>();
                        slot.put("hora", horaStr);
                        slot.put("disponible", !ocupada);
                        horasDisponibles.add(slot);
                    }

                    actual = actual.plusMinutes(duracion);
                }
            }

            // Validar que haya horas disponibles
            if (horasDisponibles.isEmpty()) {
                enviarRespuestaError(response, "No hay horas disponibles para esta fecha");
                return;
            }

            // Responder en JSON con éxito
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("success", true);
            resultado.put("horas", horasDisponibles);
            resultado.put("total", horasDisponibles.size());
            resultado.put("fecha", fecha);
            resultado.put("diaSemana", diaSemana);

            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(resultado));

        } catch (DateTimeParseException e) {
            e.printStackTrace();
            enviarRespuestaError(response, "Error al procesar fecha u hora: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            enviarRespuestaError(response, "Error al obtener horas disponibles: " + e.getMessage());
        }
    }

    /**
     * Normaliza el nombre del día de la semana (quita acentos)
     */
    private String normalizarDiaSemana(String dia) {
        if (dia == null) {
            return "";
        }

        switch (dia.toUpperCase()) {
            case "LUNES":
                return "LUNES";
            case "MARTES":
                return "MARTES";
            case "MIÉRCOLES":
            case "MIERCOLES":
                return "MIERCOLES";
            case "JUEVES":
                return "JUEVES";
            case "VIERNES":
                return "VIERNES";
            case "SÁBADO":
            case "SABADO":
                return "SABADO";
            case "DOMINGO":
                return "DOMINGO";
            default:
                return dia;
        }
    }

    /**
     * Envía una respuesta de error en formato JSON
     */
    private void enviarRespuestaError(HttpServletResponse response, String mensaje) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", mensaje);

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(error));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
