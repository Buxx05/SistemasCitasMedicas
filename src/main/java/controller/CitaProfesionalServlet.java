package controller;

import dao.CitaDAO;
import dao.ProfesionalDAO;
import dao.PacienteDAO;
import model.Usuario;
import model.Cita;
import model.Paciente;
import util.GeneradorCodigos;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CitaProfesionalServlet")
public class CitaProfesionalServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private ProfesionalDAO profesionalDAO;
    private PacienteDAO pacienteDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        profesionalDAO = new ProfesionalDAO();
        pacienteDAO = new PacienteDAO();
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

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "agendaHoy":
                mostrarAgendaHoy(request, response, usuario);
                break;
            case "completar":
                completarCita(request, response, usuario);
                break;
            case "cancelar":
                cancelarCita(request, response, usuario);
                break;
            case "nuevaRecita":
                mostrarFormularioRecita(request, response, usuario);
                break;
            default:
                listarCitas(request, response, usuario);
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

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "crearRecita":
                crearRecita(request, response, usuario);
                break;
            default:
                listarCitas(request, response, usuario);
        }
    }

    // ========== LISTAR CITAS ==========
    private void listarCitas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String estado = request.getParameter("estado");
            List<Cita> citas;

            if (estado != null && !estado.trim().isEmpty()) {
                citas = citaDAO.listarCitasPorProfesionalYEstado(idProfesional, estado);
            } else {
                citas = citaDAO.listarCitasPorProfesionalConDetalles(idProfesional);
            }

            // Generar códigos para cada cita
            for (Cita cita : citas) {
                if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                    cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                }
            }

            request.setAttribute("citas", citas);
            request.setAttribute("estadoFiltro", estado);
            request.getRequestDispatcher("/profesional/citas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar las citas: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== AGENDA DEL DÍA ==========
    private void mostrarAgendaHoy(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            String hoy = java.time.LocalDate.now().toString();

            List<Cita> citasHoy = citaDAO.listarCitasDelDia(idProfesional, hoy);

            // Generar códigos
            for (Cita cita : citasHoy) {
                if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                    cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                }
            }

            request.setAttribute("citasHoy", citasHoy);
            request.setAttribute("fecha", hoy);
            request.getRequestDispatcher("/profesional/agenda-dia.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la agenda: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== COMPLETAR CITA ==========
    private void completarCita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            String origen = request.getParameter("origen");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de cita no especificado");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            int idCita = Integer.parseInt(idParam);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Verificar que la cita pertenece al profesional
            Cita cita = citaDAO.buscarCitaPorId(idCita);

            if (cita == null || cita.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta cita");
                redirigirSegunOrigen(request, response, origen);
                return;
            }

            // Validar estado: Solo PENDIENTE puede completarse
            if (!"PENDIENTE".equals(cita.getEstado())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Solo se pueden completar citas con estado PENDIENTE. Estado actual: " + cita.getEstado());
                redirigirSegunOrigen(request, response, origen);
                return;
            }

            HttpSession session = request.getSession();

            if (citaDAO.completarCita(idCita)) {
                session.setAttribute("success", "Cita marcada como completada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo completar la cita");
            }

            redirigirSegunOrigen(request, response, origen);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de cita inválido");
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al completar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== CANCELAR CITA ==========
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            String origen = request.getParameter("origen");
            String motivo = request.getParameter("motivo");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de cita no especificado");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            int idCita = Integer.parseInt(idParam);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            // Verificar que la cita pertenece al profesional
            Cita cita = citaDAO.buscarCitaPorId(idCita);

            if (cita == null || cita.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta cita");
                redirigirSegunOrigen(request, response, origen);
                return;
            }

            // Validar estado: Solo PENDIENTE puede cancelarse
            if (!"PENDIENTE".equals(cita.getEstado())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Solo se pueden cancelar citas con estado PENDIENTE. Estado actual: " + cita.getEstado());
                redirigirSegunOrigen(request, response, origen);
                return;
            }

            HttpSession session = request.getSession();

            // Agregar motivo a observaciones si existe
            if (motivo != null && !motivo.trim().isEmpty()) {
                String observacionesCancelacion = (cita.getObservaciones() != null ? cita.getObservaciones() + " | " : "")
                        + "Motivo de cancelación: " + motivo;
                citaDAO.actualizarObservaciones(idCita, observacionesCancelacion);
            }

            if (citaDAO.cancelarCita(idCita)) {
                session.setAttribute("warning", "Cita cancelada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo cancelar la cita");
            }

            redirigirSegunOrigen(request, response, origen);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de cita inválido");
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cancelar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== RE-CITAS (SEGUIMIENTO) ==========
    private void mostrarFormularioRecita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            String idCitaParam = request.getParameter("idCita");
            String idPacienteParam = request.getParameter("idPaciente");

            if (idCitaParam == null || idCitaParam.trim().isEmpty()
                    || idPacienteParam == null || idPacienteParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Parámetros faltantes para crear la re-cita");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            int idCitaOriginal = Integer.parseInt(idCitaParam);
            int idPaciente = Integer.parseInt(idPacienteParam);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Verificar que la cita pertenece al profesional
            Cita citaOriginal = citaDAO.buscarCitaPorId(idCitaOriginal);

            if (citaOriginal == null || citaOriginal.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para crear re-citas de esta cita");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Validar estado: Solo COMPLETADA puede re-citarse
            if (!"COMPLETADA".equals(citaOriginal.getEstado())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Solo se pueden crear re-citas de citas completadas. Estado actual: " + citaOriginal.getEstado());
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Generar código para la cita original
            if (citaOriginal.getCodigoCita() == null || citaOriginal.getCodigoCita().isEmpty()) {
                citaOriginal.setCodigoCita(GeneradorCodigos.generarCodigoCita(citaOriginal.getIdCita()));
            }

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del paciente");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            request.setAttribute("citaOriginal", citaOriginal);
            request.setAttribute("paciente", paciente);
            request.setAttribute("idProfesional", idProfesional);
            request.getRequestDispatcher("/profesional/recita-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID inválido en los parámetros");
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario de re-cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== CREAR RE-CITA ==========
    private void crearRecita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idPacienteParam = request.getParameter("idPaciente");
            String idCitaOriginalParam = request.getParameter("idCitaOriginal");
            String fechaCita = request.getParameter("fechaCita");
            String horaCita = request.getParameter("horaCita");
            String motivoConsulta = request.getParameter("motivoConsulta");
            String observaciones = request.getParameter("observaciones");
            String origen = request.getParameter("origen");

            // ✅ Validación mejorada
            if (idPacienteParam == null || idPacienteParam.trim().isEmpty()
                    || idCitaOriginalParam == null || idCitaOriginalParam.trim().isEmpty()
                    || fechaCita == null || fechaCita.trim().isEmpty()
                    || horaCita == null || horaCita.trim().isEmpty()
                    || motivoConsulta == null || motivoConsulta.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                response.sendRedirect(request.getContextPath() + "/CitaProfesionalServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idPacienteParam);
            int idCitaOriginal = Integer.parseInt(idCitaOriginalParam);

            // Validar que no exista una cita en ese horario
            if (citaDAO.existeCitaEnHorario(idProfesional, fechaCita, horaCita)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Ya tienes una cita agendada en ese horario. Por favor, selecciona otra hora.");
                response.sendRedirect(request.getContextPath() + "/CitaProfesionalServlet?accion=nuevaRecita&idCita=" + idCitaOriginal + "&idPaciente=" + idPaciente);
                return;
            }

            // Crear nueva cita (re-cita) con estado PENDIENTE
            Cita recita = new Cita();
            recita.setIdPaciente(idPaciente);
            recita.setIdProfesional(idProfesional);
            recita.setFechaCita(fechaCita);
            recita.setHoraCita(horaCita);
            recita.setMotivoConsulta(motivoConsulta);
            recita.setEstado("PENDIENTE");
            recita.setObservaciones(observaciones);
            recita.setIdRecita(idCitaOriginal);

            HttpSession session = request.getSession();

            if (citaDAO.insertarCita(recita)) {
                session.setAttribute("success", "Re-cita de seguimiento creada exitosamente");
            } else {
                session.setAttribute("error", "Error al crear la re-cita");
            }

            redirigirSegunOrigen(request, response, origen);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos inválidos en el formulario");
            response.sendRedirect(request.getContextPath() + "/CitaProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la re-cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== MÉTODO AUXILIAR ==========
    /**
     * Redirige al usuario según el origen de la acción
     *
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param origen "citas", "cita" o "dashboard"
     * @throws IOException
     */
    private void redirigirSegunOrigen(HttpServletRequest request, HttpServletResponse response, String origen) throws IOException {
        // ✅ Acepta variaciones: "citas", "cita", "calendario"
        if ("citas".equals(origen) || "cita".equals(origen)) {
            response.sendRedirect(request.getContextPath() + "/CitaProfesionalServlet");
        } else if ("calendario".equals(origen)) {
            response.sendRedirect(request.getContextPath() + "/CalendarioServlet");
        } else {
            // Por defecto: dashboard
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }
}
