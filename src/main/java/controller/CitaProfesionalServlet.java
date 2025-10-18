package controller;

import dao.CitaDAO;
import dao.ProfesionalDAO;
import dao.PacienteDAO;
import model.Usuario;
import model.Cita;
import model.Profesional;
import model.Paciente;
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
    /**
     * Lista todas las citas del profesional
     */
    private void listarCitas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            // Filtrar por estado si se proporciona
            String estado = request.getParameter("estado");
            List<Cita> citas;

            if (estado != null && !estado.isEmpty()) {
                citas = citaDAO.listarCitasPorProfesionalConDetalles(idProfesional).stream()
                        .filter(c -> c.getEstado().equals(estado))
                        .collect(java.util.stream.Collectors.toList());
            } else {
                citas = citaDAO.listarCitasPorProfesionalConDetalles(idProfesional);
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
    /**
     * Muestra las citas del día actual
     */
    private void mostrarAgendaHoy(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            String hoy = java.time.LocalDate.now().toString();

            List<Cita> citasHoy = citaDAO.listarCitasDelDia(idProfesional, hoy);

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
    /**
     * Marca una cita como completada
     */
    private void completarCita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            // Verificar que la cita pertenece al profesional
            Cita cita = citaDAO.buscarCitaPorId(idCita);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (cita == null || cita.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta cita");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            HttpSession session = request.getSession();

            if (citaDAO.completarCita(idCita)) {
                session.setAttribute("mensaje", "Cita marcada como completada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo completar la cita");
            }

            // Redirigir al dashboard
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al completar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== CANCELAR CITA ==========
    /**
     * Cancela una cita
     */
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            // Verificar que la cita pertenece al profesional
            Cita cita = citaDAO.buscarCitaPorId(idCita);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (cita == null || cita.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta cita");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            HttpSession session = request.getSession();

            if (citaDAO.cancelarCita(idCita)) {
                session.setAttribute("mensaje", "Cita cancelada exitosamente");
                session.setAttribute("tipoMensaje", "warning");
            } else {
                session.setAttribute("error", "No se pudo cancelar la cita");
            }

            // Redirigir al dashboard
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cancelar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== RE-CITAS (SEGUIMIENTO) ==========
    /**
     * Muestra el formulario para crear una re-cita (cita de seguimiento)
     */
    private void mostrarFormularioRecita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idCitaOriginal = Integer.parseInt(request.getParameter("idCita"));
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));

            // Verificar que la cita pertenece al profesional
            Cita citaOriginal = citaDAO.buscarCitaPorId(idCitaOriginal);
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (citaOriginal == null || citaOriginal.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para crear re-citas de esta cita");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            request.setAttribute("citaOriginal", citaOriginal);
            request.setAttribute("paciente", paciente);
            request.setAttribute("idProfesional", idProfesional);
            request.getRequestDispatcher("/profesional/recita-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    /**
     * Crea una nueva cita de seguimiento (re-cita)
     */
    private void crearRecita(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            int idCitaOriginal = Integer.parseInt(request.getParameter("idCitaOriginal"));
            String fechaCita = request.getParameter("fechaCita");
            String horaCita = request.getParameter("horaCita");
            String motivoConsulta = request.getParameter("motivoConsulta");
            String observaciones = request.getParameter("observaciones");

            // Validar que no exista una cita en ese horario
            if (citaDAO.existeCitaEnHorario(idProfesional, fechaCita, horaCita)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Ya tienes una cita agendada en ese horario");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/CitaProfesionalServlet?accion=nuevaRecita&idCita=" + idCitaOriginal + "&idPaciente=" + idPaciente);
                return;
            }

            // Crear nueva cita (re-cita)
            Cita recita = new Cita();
            recita.setIdPaciente(idPaciente);
            recita.setIdProfesional(idProfesional);
            recita.setFechaCita(fechaCita);
            recita.setHoraCita(horaCita);
            recita.setMotivoConsulta(motivoConsulta);
            recita.setEstado("CONFIRMADA");
            recita.setObservaciones(observaciones);
            recita.setIdRecita(idCitaOriginal); // Referenciar a la cita original

            HttpSession session = request.getSession();

            if (citaDAO.insertarCita(recita)) {
                session.setAttribute("mensaje", "Re-cita creada exitosamente. El paciente será notificado.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear la re-cita");
            }

            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la re-cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }
}
