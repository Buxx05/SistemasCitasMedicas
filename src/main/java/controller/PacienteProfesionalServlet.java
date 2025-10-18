package controller;

import dao.PacienteDAO;
import dao.ProfesionalDAO;
import dao.CitaDAO;
import dao.HistorialClinicoDAO;
import model.Usuario;
import model.Paciente;
import model.Cita;
import model.HistorialClinico;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/PacienteProfesionalServlet")
public class PacienteProfesionalServlet extends HttpServlet {

    private PacienteDAO pacienteDAO;
    private ProfesionalDAO profesionalDAO;
    private CitaDAO citaDAO;
    private HistorialClinicoDAO historialDAO;

    @Override
    public void init() {
        pacienteDAO = new PacienteDAO();
        profesionalDAO = new ProfesionalDAO();
        citaDAO = new CitaDAO();
        historialDAO = new HistorialClinicoDAO();
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
            case "ver":
                verDetallePaciente(request, response, usuario);
                break;
            case "buscar":
                buscarPacientes(request, response, usuario);
                break;
            case "verHistorial":
                verHistorialClinico(request, response, usuario);
                break;
            case "nuevoHistorial":
                mostrarFormularioNuevoHistorial(request, response, usuario);
                break;
            case "editarHistorial":
                mostrarFormularioEditarHistorial(request, response, usuario);
                break;
            default:
                listarPacientes(request, response, usuario);
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
            case "crearHistorial":
                crearHistorialClinico(request, response, usuario);
                break;
            case "actualizarHistorial":
                actualizarHistorialClinico(request, response, usuario);
                break;
            case "eliminarHistorial":
                eliminarHistorialClinico(request, response, usuario);
                break;
            default:
                doGet(request, response);
        }
    }

    // ========== LISTAR MIS PACIENTES ==========
    /**
     * Lista todos los pacientes que el profesional ha atendido
     */
    private void listarPacientes(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            // Obtener lista de pacientes
            List<Paciente> pacientes = pacienteDAO.listarPacientesPorProfesional(idProfesional);

            // Crear mapa con estadísticas de cada paciente
            Map<Integer, Map<String, Object>> estadisticasPacientes = new HashMap<>();

            for (Paciente paciente : pacientes) {
                Map<String, Object> stats = new HashMap<>();

                // Obtener estadísticas
                int[] estadisticas = pacienteDAO.obtenerEstadisticasPaciente(
                        paciente.getIdPaciente(),
                        idProfesional
                );

                stats.put("totalCitas", estadisticas[0]);
                stats.put("citasCompletadas", estadisticas[1]);
                stats.put("citasCanceladas", estadisticas[2]);

                // Obtener última cita
                String ultimaCita = pacienteDAO.obtenerUltimaCita(
                        paciente.getIdPaciente(),
                        idProfesional
                );
                stats.put("ultimaCita", ultimaCita);

                estadisticasPacientes.put(paciente.getIdPaciente(), stats);
            }

            request.setAttribute("pacientes", pacientes);
            request.setAttribute("estadisticasPacientes", estadisticasPacientes);
            request.getRequestDispatcher("/profesional/pacientes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar los pacientes: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
        }
    }

    // ========== BUSCAR PACIENTES ==========
    /**
     * Busca pacientes por DNI o nombre dentro de los pacientes del profesional
     */
    private void buscarPacientes(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            String busqueda = request.getParameter("busqueda");

            List<Paciente> pacientes;

            if (busqueda != null && !busqueda.trim().isEmpty()) {
                // Buscar por DNI o nombre
                pacientes = pacienteDAO.buscarPacientesPorDniONombre(busqueda, idProfesional);
            } else {
                // Si no hay búsqueda, listar todos
                pacientes = pacienteDAO.listarPacientesPorProfesional(idProfesional);
            }

            // Crear mapa con estadísticas
            Map<Integer, Map<String, Object>> estadisticasPacientes = new HashMap<>();

            for (Paciente paciente : pacientes) {
                Map<String, Object> stats = new HashMap<>();

                int[] estadisticas = pacienteDAO.obtenerEstadisticasPaciente(
                        paciente.getIdPaciente(),
                        idProfesional
                );

                stats.put("totalCitas", estadisticas[0]);
                stats.put("citasCompletadas", estadisticas[1]);
                stats.put("citasCanceladas", estadisticas[2]);

                String ultimaCita = pacienteDAO.obtenerUltimaCita(
                        paciente.getIdPaciente(),
                        idProfesional
                );
                stats.put("ultimaCita", ultimaCita);

                estadisticasPacientes.put(paciente.getIdPaciente(), stats);
            }

            request.setAttribute("pacientes", pacientes);
            request.setAttribute("estadisticasPacientes", estadisticasPacientes);
            request.setAttribute("busqueda", busqueda);
            request.getRequestDispatcher("/profesional/pacientes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al buscar pacientes: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== VER DETALLE DE PACIENTE ==========
    /**
     * Muestra el detalle completo de un paciente con su historial de citas
     */
    private void verDetallePaciente(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("id"));

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Obtener estadísticas del paciente con este profesional
            int[] estadisticas = pacienteDAO.obtenerEstadisticasPaciente(idPaciente, idProfesional);

            // Obtener historial de citas del paciente con este profesional
            List<Cita> historialCitas = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                    .stream()
                    .filter(c -> c.getIdProfesional() == idProfesional)
                    .collect(java.util.stream.Collectors.toList());

            // Verificar que el profesional haya atendido a este paciente
            if (historialCitas.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes historial con este paciente");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            request.setAttribute("paciente", paciente);
            request.setAttribute("totalCitas", estadisticas[0]);
            request.setAttribute("citasCompletadas", estadisticas[1]);
            request.setAttribute("citasCanceladas", estadisticas[2]);
            request.setAttribute("historialCitas", historialCitas);

            request.getRequestDispatcher("/profesional/paciente-detalle.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el detalle del paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== VER HISTORIAL CLÍNICO ==========
    /**
     * Muestra el historial clínico completo del paciente con el profesional
     */
    private void verHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Obtener historial clínico
            List<HistorialClinico> historiales = historialDAO.listarHistorialPorPacienteYProfesional(idPaciente, idProfesional);

            // Contar entradas del historial
            int totalEntradas = historialDAO.contarEntradasPorPacienteYProfesional(idPaciente, idProfesional);

            request.setAttribute("paciente", paciente);
            request.setAttribute("historiales", historiales);
            request.setAttribute("totalEntradas", totalEntradas);
            request.setAttribute("idProfesional", idProfesional);

            request.getRequestDispatcher("/profesional/historial.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== FORMULARIO NUEVO HISTORIAL ==========
    /**
     * Muestra el formulario para crear una nueva entrada de historial
     */
    private void mostrarFormularioNuevoHistorial(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Obtener citas completadas del paciente con este profesional (para vincular opcionalmente)
            List<Cita> citasCompletadas = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                    .stream()
                    .filter(c -> c.getIdProfesional() == idProfesional && "COMPLETADA".equals(c.getEstado()))
                    .collect(java.util.stream.Collectors.toList());

            request.setAttribute("paciente", paciente);
            request.setAttribute("citasCompletadas", citasCompletadas);
            request.setAttribute("idProfesional", idProfesional);

            request.getRequestDispatcher("/profesional/historial-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== CREAR HISTORIAL ==========
    /**
     * Crea una nueva entrada en el historial clínico
     */
    private void crearHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            String sintomas = request.getParameter("sintomas");
            String diagnostico = request.getParameter("diagnostico");
            String tratamiento = request.getParameter("tratamiento");
            String observaciones = request.getParameter("observaciones");
            String idCitaStr = request.getParameter("idCita");

            // Crear objeto historial
            HistorialClinico historial = new HistorialClinico();
            historial.setIdPaciente(idPaciente);
            historial.setIdProfesional(idProfesional);
            historial.setFechaRegistro(LocalDate.now().toString());
            historial.setSintomas(sintomas);
            historial.setDiagnostico(diagnostico);
            historial.setTratamiento(tratamiento);
            historial.setObservaciones(observaciones);

            // Vincular con cita si se proporcionó
            if (idCitaStr != null && !idCitaStr.trim().isEmpty() && !idCitaStr.equals("0")) {
                historial.setIdCita(Integer.parseInt(idCitaStr));
            }

            HttpSession session = request.getSession();

            if (historialDAO.insertarHistorial(historial)) {
                session.setAttribute("mensaje", "Entrada de historial creada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear la entrada de historial");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + idPaciente);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== FORMULARIO EDITAR HISTORIAL ==========
    /**
     * Muestra el formulario para editar una entrada de historial
     */
    private void mostrarFormularioEditarHistorial(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idHistorial = Integer.parseInt(request.getParameter("id"));

            // Obtener entrada del historial
            HistorialClinico historial = historialDAO.buscarHistorialPorId(idHistorial);

            if (historial == null || historial.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para editar esta entrada");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(historial.getIdPaciente());

            request.setAttribute("historial", historial);
            request.setAttribute("paciente", paciente);

            request.getRequestDispatcher("/profesional/historial-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== ACTUALIZAR HISTORIAL ==========
    /**
     * Actualiza una entrada del historial clínico
     */
    private void actualizarHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idHistorial = Integer.parseInt(request.getParameter("idHistorial"));
            String sintomas = request.getParameter("sintomas");
            String diagnostico = request.getParameter("diagnostico");
            String tratamiento = request.getParameter("tratamiento");
            String observaciones = request.getParameter("observaciones");

            // Verificar que la entrada pertenece al profesional
            HistorialClinico historial = historialDAO.buscarHistorialPorId(idHistorial);

            if (historial == null || historial.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta entrada");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Actualizar datos
            historial.setSintomas(sintomas);
            historial.setDiagnostico(diagnostico);
            historial.setTratamiento(tratamiento);
            historial.setObservaciones(observaciones);

            HttpSession session = request.getSession();

            if (historialDAO.actualizarHistorial(historial)) {
                session.setAttribute("mensaje", "Entrada de historial actualizada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al actualizar la entrada");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + historial.getIdPaciente());

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== ELIMINAR HISTORIAL ==========
    /**
     * Elimina una entrada del historial clínico
     */
    private void eliminarHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idHistorial = Integer.parseInt(request.getParameter("id"));

            // Verificar que la entrada pertenece al profesional
            HistorialClinico historial = historialDAO.buscarHistorialPorId(idHistorial);

            if (historial == null || historial.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para eliminar esta entrada");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idPaciente = historial.getIdPaciente();
            HttpSession session = request.getSession();

            if (historialDAO.eliminarHistorial(idHistorial)) {
                session.setAttribute("mensaje", "Entrada de historial eliminada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al eliminar la entrada");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + idPaciente);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }
}
