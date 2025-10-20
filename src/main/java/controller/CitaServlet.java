package controller;

import dao.HorarioProfesionalDAO;
import com.google.gson.Gson;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
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
            session.setAttribute("error", "Esta sección es solo para administradores");
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
    private void listarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
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
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
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
    private void crearCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ✅ Validación de parámetros obligatorios
            String idPacienteParam = request.getParameter("idPaciente");
            String idProfesionalParam = request.getParameter("idProfesional");
            String fechaCita = request.getParameter("fechaCita");
            String horaCita = request.getParameter("horaCita");
            String motivoConsulta = request.getParameter("motivoConsulta");

            if (idPacienteParam == null || idProfesionalParam == null || 
                fechaCita == null || horaCita == null || motivoConsulta == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                response.sendRedirect(request.getContextPath() + "/CitaServlet?accion=nuevo");
                return;
            }

            int idPaciente = Integer.parseInt(idPacienteParam);
            int idProfesional = Integer.parseInt(idProfesionalParam);
            String observaciones = request.getParameter("observaciones");

            // Validar que no exista una cita en el mismo horario
            if (citaDAO.existeCitaEnHorario(idProfesional, fechaCita, horaCita)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El profesional ya tiene una cita agendada en ese horario. Por favor, selecciona otra hora.");

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
            cita.setEstado("PENDIENTE"); // ✅ Estado por defecto
            cita.setObservaciones(observaciones);

            // Manejar id_recita (opcional)
            String idRecitaStr = request.getParameter("idRecita");
            if (idRecitaStr != null && !idRecitaStr.trim().isEmpty()) {
                cita.setIdRecita(Integer.parseInt(idRecitaStr));
            }

            HttpSession session = request.getSession();

            if (citaDAO.insertarCita(cita)) {
                session.setAttribute("success", "Cita creada exitosamente");
            } else {
                session.setAttribute("error", "Error al crear la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Los datos numéricos ingresados no son válidos");
            response.sendRedirect(request.getContextPath() + "/CitaServlet?accion=nuevo");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de cita no especificado");
                response.sendRedirect(request.getContextPath() + "/CitaServlet");
                return;
            }

            int idCita = Integer.parseInt(idParam);
            Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);

            if (cita != null) {
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

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de cita inválido");
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== ACTUALIZAR CITA ==========
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
                session.setAttribute("warning", "El profesional ya tiene otra cita agendada en ese horario. Por favor, selecciona otra hora.");

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
                session.setAttribute("success", "Cita actualizada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar la cita");
            }

            response.sendRedirect(request.getContextPath() + "/CitaServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Los datos numéricos ingresados no son válidos");
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
        }
    }

    // ========== ELIMINAR CITA ==========
    private void eliminarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de cita no especificado");
                response.sendRedirect(request.getContextPath() + "/CitaServlet");
                return;
            }

            int idCita = Integer.parseInt(idParam);
            HttpSession session = request.getSession();

            if (citaDAO.eliminarCita(idCita)) {
                session.setAttribute("success", "Cita eliminada exitosamente");
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

    // ========== FILTRAR CITAS ==========
    private void filtrarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String tipoFiltro = request.getParameter("tipoFiltro");
            List<Cita> citas = null;

            if (tipoFiltro == null || tipoFiltro.trim().isEmpty()) {
                citas = citaDAO.listarCitasConDetalles();
            } else {
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
            }

            request.setAttribute("citas", citas);
            request.setAttribute("filtroAplicado", tipoFiltro);
            request.getRequestDispatcher("/admin/citas.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Parámetros de filtro inválidos");
            listarCitas(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al filtrar citas: " + e.getMessage());
            listarCitas(request, response);
        }
    }

    // ========== AJAX: OBTENER HORARIOS DISPONIBLES ==========
    private void obtenerHorariosDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idProfesionalParam = request.getParameter("idProfesional");
            String fecha = request.getParameter("fecha");

            if (idProfesionalParam == null || fecha == null) {
                response.getWriter().write("[]");
                return;
            }

            int idProfesional = Integer.parseInt(idProfesionalParam);

            // Obtener el día de la semana en español
            String diaSemana = obtenerDiaSemana(fecha);

            // Generar bloques disponibles usando HorarioDAO
            List<String> bloquesDisponibles = horarioDAO.generarBloquesDisponibles(idProfesional, fecha, diaSemana);

            // Convertir a JSON
            Gson gson = new Gson();
            String json = gson.toJson(bloquesDisponibles);

            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.getWriter().write("[]");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    /**
     * Obtiene el nombre del día de la semana en español
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
