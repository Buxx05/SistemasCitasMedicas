package controller;

import dao.HorarioProfesionalDAO; // ← Agregar
import com.google.gson.Gson; // ← Agregar (para JSON)
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
import java.util.Locale;
import dao.CitaDAO;
import dao.PacienteDAO;
import dao.ProfesionalDAO;
import model.Cita;
import model.Usuario;
import model.Paciente;
import model.Profesional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CitaServlet")
public class CitaServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private ProfesionalDAO profesionalDAO;
    private HorarioProfesionalDAO horarioDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        profesionalDAO = new ProfesionalDAO();
        horarioDAO = new HorarioProfesionalDAO();
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

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

        // Solo administradores pueden gestionar citas
        if (usuarioSesion.getIdRol() != 1) {
            response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
            return;
        }

        // Obtener acción
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = request.getParameter("action");
        }
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                mostrarFormularioNuevo(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                eliminarCita(request, response);
                break;
            case "confirmar":
                confirmarCita(request, response);
                break;
            case "cancelar":
                cancelarCita(request, response);
                break;
            case "completar":
                completarCita(request, response);
                break;
            case "filtrar":
                filtrarCitas(request, response);
                break;
            case "obtenerHorarios":
                obtenerHorariosDisponibles(request, response);
                break;
            default:
                listarCitas(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = request.getParameter("action");
        }

        switch (accion) {
            case "crear":
                crearCita(request, response);
                break;
            case "actualizar":
                actualizarCita(request, response);
                break;
            default:
                listarCitas(request, response);
        }
    }

    // ========== LISTAR CITAS ==========
    /**
     * Lista todas las citas con detalles completos
     */
    private void listarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ✅ Admin ve TODAS las citas
            List<Cita> citas = citaDAO.listarCitasConDetalles();

            request.setAttribute("citas", citas);
            request.getRequestDispatcher("/admin/citas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar las citas: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    /**
     * Muestra el formulario para crear una nueva cita Carga listas de pacientes
     * y profesionales
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Cargar listas para los selects
            List<Paciente> pacientes = pacienteDAO.listarPacientes();
            List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();

            request.setAttribute("pacientes", pacientes);
            request.setAttribute("profesionales", profesionales);
            request.setAttribute("accion", "crear");
            request.setAttribute("tituloFormulario", "Nueva Cita");
            request.getRequestDispatcher("/admin/citas-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== CREAR CITA ==========
    /**
     * Crea una nueva cita con validaciones
     */
    private void crearCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            int idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            String fechaCita = request.getParameter("fechaCita");
            String horaCita = request.getParameter("horaCita");
            String motivoConsulta = request.getParameter("motivoConsulta");
            String observaciones = request.getParameter("observaciones");

            // Validar que no exista una cita en el mismo horario
            if (citaDAO.existeCitaEnHorario(idProfesional, fechaCita, horaCita)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El profesional ya tiene una cita agendada en ese horario");
                session.setAttribute("tipoMensaje", "warning");

                // Recargar formulario con datos
                List<Paciente> pacientes = pacienteDAO.listarPacientes();
                List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();
                request.setAttribute("pacientes", pacientes);
                request.setAttribute("profesionales", profesionales);
                request.setAttribute("idPaciente", idPaciente);
                request.setAttribute("idProfesional", idProfesional);
                request.setAttribute("fechaCita", fechaCita);
                request.setAttribute("horaCita", horaCita);
                request.setAttribute("motivoConsulta", motivoConsulta);
                request.setAttribute("observaciones", observaciones);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nueva Cita");
                request.getRequestDispatcher("/admin/citas-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Cita
            Cita cita = new Cita();
            cita.setIdPaciente(idPaciente);
            cita.setIdProfesional(idProfesional);
            cita.setFechaCita(fechaCita);
            cita.setHoraCita(horaCita);
            cita.setMotivoConsulta(motivoConsulta);
            cita.setEstado("CONFIRMADA");
            cita.setObservaciones(observaciones);

            // Manejar id_recita (opcional)
            String idRecitaStr = request.getParameter("idRecita");
            if (idRecitaStr != null && !idRecitaStr.trim().isEmpty()) {
                cita.setIdRecita(Integer.parseInt(idRecitaStr));
            }

            HttpSession session = request.getSession();

            if (citaDAO.insertarCita(cita)) {
                session.setAttribute("mensaje", "Cita creada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    /**
     * Muestra el formulario para editar una cita existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            // Buscar cita con detalles
            Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);

            if (cita != null) {
                // Cargar listas para los selects
                List<Paciente> pacientes = pacienteDAO.listarPacientes();
                List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();

                request.setAttribute("cita", cita);
                request.setAttribute("pacientes", pacientes);
                request.setAttribute("profesionales", profesionales);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Cita");
                request.getRequestDispatcher("/admin/citas-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Cita no encontrada");
                response.sendRedirect(request.getContextPath() + "/CitaServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== ACTUALIZAR CITA ==========
    /**
     * Actualiza una cita existente con validaciones
     */
    private void actualizarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            int idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            String fechaCita = request.getParameter("fechaCita");
            String horaCita = request.getParameter("horaCita");
            String motivoConsulta = request.getParameter("motivoConsulta");
            String estado = request.getParameter("estado");
            String observaciones = request.getParameter("observaciones");

            // Validar horario (excepto esta misma cita)
            if (citaDAO.existeCitaEnHorarioExceptoCita(idProfesional, fechaCita, horaCita, idCita)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El profesional ya tiene otra cita agendada en ese horario");
                session.setAttribute("tipoMensaje", "warning");

                // Recargar formulario
                Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);
                cita.setIdPaciente(idPaciente);
                cita.setIdProfesional(idProfesional);
                cita.setFechaCita(fechaCita);
                cita.setHoraCita(horaCita);
                cita.setMotivoConsulta(motivoConsulta);
                cita.setEstado(estado);
                cita.setObservaciones(observaciones);

                List<Paciente> pacientes = pacienteDAO.listarPacientes();
                List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();
                request.setAttribute("cita", cita);
                request.setAttribute("pacientes", pacientes);
                request.setAttribute("profesionales", profesionales);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Cita");
                request.getRequestDispatcher("/admin/citas-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Cita
            Cita cita = new Cita();
            cita.setIdCita(idCita);
            cita.setIdPaciente(idPaciente);
            cita.setIdProfesional(idProfesional);
            cita.setFechaCita(fechaCita);
            cita.setHoraCita(horaCita);
            cita.setMotivoConsulta(motivoConsulta);
            cita.setEstado(estado);
            cita.setObservaciones(observaciones);

            // Manejar id_recita
            String idRecitaStr = request.getParameter("idRecita");
            if (idRecitaStr != null && !idRecitaStr.trim().isEmpty()) {
                cita.setIdRecita(Integer.parseInt(idRecitaStr));
            }

            HttpSession session = request.getSession();

            if (citaDAO.actualizarCita(cita)) {
                session.setAttribute("mensaje", "Cita actualizada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== ELIMINAR CITA ==========
    /**
     * Elimina una cita del sistema
     */
    private void eliminarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            // ✅ Validar parámetro
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de cita no especificado");
                response.sendRedirect(request.getContextPath() + "/CitaServlet");
                return;
            }

            int idCita = Integer.parseInt(idParam);

            HttpSession session = request.getSession();

            if (citaDAO.eliminarCita(idCita)) {
                session.setAttribute("mensaje", "Cita eliminada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo eliminar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de cita inválido");
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== CAMBIO DE ESTADOS ==========
    /**
     * Confirma una cita (PENDIENTE → CONFIRMADA)
     */
    private void confirmarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();

            if (citaDAO.confirmarCita(idCita)) {
                session.setAttribute("mensaje", "Cita confirmada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo confirmar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al confirmar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    /**
     * Cancela una cita
     */
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();

            if (citaDAO.cancelarCita(idCita)) {
                session.setAttribute("mensaje", "Cita cancelada exitosamente");
                session.setAttribute("tipoMensaje", "warning");
            } else {
                session.setAttribute("error", "No se pudo cancelar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cancelar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    /**
     * Completa una cita (marca como atendida)
     */
    private void completarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();

            if (citaDAO.completarCita(idCita)) {
                session.setAttribute("mensaje", "Cita completada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo completar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al completar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== FILTRAR CITAS ==========
    /**
     * Filtra citas según criterios
     */
    private void filtrarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String tipoFiltro = request.getParameter("tipoFiltro");
            List<Cita> citas = null;

            switch (tipoFiltro) {
                case "estado":
                    String estado = request.getParameter("estado");
                    citas = citaDAO.listarCitasPorEstadoConDetalles(estado);
                    break;
                case "fecha":
                    String fecha = request.getParameter("fecha");
                    citas = citaDAO.listarCitasPorFechaConDetalles(fecha);
                    break;
                case "paciente":
                    int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
                    citas = citaDAO.listarCitasPorPacienteConDetalles(idPaciente);
                    break;
                case "profesional":
                    int idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
                    citas = citaDAO.listarCitasPorProfesionalConDetalles(idProfesional);
                    break;
                case "rango":
                    String fechaInicio = request.getParameter("fechaInicio");
                    String fechaFin = request.getParameter("fechaFin");
                    citas = citaDAO.listarCitasPorRangoFechasConDetalles(fechaInicio, fechaFin);
                    break;
                default:
                    citas = citaDAO.listarCitasConDetalles();
            }

            request.setAttribute("citas", citas);
            request.setAttribute("filtroAplicado", tipoFiltro);
            request.getRequestDispatcher("/admin/citas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al filtrar citas: " + e.getMessage());
            listarCitas(request, response);
        }
    }

    // ========== AJAX: OBTENER HORARIOS DISPONIBLES ==========
    /**
     * Obtiene los horarios disponibles de un profesional en una fecha
     * específica Retorna JSON para ser consumido por AJAX
     */
    private void obtenerHorariosDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            String fecha = request.getParameter("fecha");

            // Obtener el día de la semana en español
            String diaSemana = obtenerDiaSemana(fecha);

            // Generar bloques disponibles usando HorarioDAO
            List<String> bloquesDisponibles = horarioDAO.generarBloquesDisponibles(idProfesional, fecha, diaSemana);

            // Convertir a JSON
            Gson gson = new Gson();
            String json = gson.toJson(bloquesDisponibles);

            // Configurar respuesta como JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("[]"); // Retorna array vacío si hay error
        }
    }

    /**
     * Convierte una fecha (yyyy-MM-dd) al día de la semana en español
     * mayúsculas Ejemplo: "2025-10-20" → "LUNES"
     */
    private String obtenerDiaSemana(String fecha) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(fecha, formatter);
            DayOfWeek dayOfWeek = date.getDayOfWeek();

            switch (dayOfWeek) {
                case MONDAY:
                    return "LUNES";
                case TUESDAY:
                    return "MARTES";
                case WEDNESDAY:
                    return "MIERCOLES";
                case THURSDAY:
                    return "JUEVES";
                case FRIDAY:
                    return "VIERNES";
                case SATURDAY:
                    return "SABADO";
                case SUNDAY:
                    return "DOMINGO";
                default:
                    return "";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

}
