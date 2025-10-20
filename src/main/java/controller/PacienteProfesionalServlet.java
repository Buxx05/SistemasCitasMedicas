package controller;

import dao.PacienteDAO;
import dao.ProfesionalDAO;
import dao.CitaDAO;
import dao.HistorialClinicoDAO;
import model.Usuario;
import model.Paciente;
import model.Cita;
import model.HistorialClinico;
import util.GeneradorCodigos;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

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
            session.setAttribute("error", "Esta sección es solo para profesionales médicos");
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
    private void listarPacientes(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            // Obtener lista de pacientes
            List<Paciente> pacientes = pacienteDAO.listarPacientesPorProfesional(idProfesional);

            // Generar códigos y calcular edad
            if (pacientes != null && !pacientes.isEmpty()) {
                for (Paciente paciente : pacientes) {
                    if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                        paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                    }
                    paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));
                }
            }

            Map<Integer, Map<String, Object>> estadisticasPacientes
                    = generarEstadisticasPacientes(pacientes, idProfesional);

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

    // ========== VER DETALLE DE PACIENTE ==========
    private void verDetallePaciente(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idParam);

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Generar código y calcular edad
            if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
            }
            paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));

            // Obtener estadísticas del paciente con este profesional
            int[] estadisticas = pacienteDAO.obtenerEstadisticasPaciente(idPaciente, idProfesional);

            // Obtener historial de citas del paciente con este profesional
            List<Cita> historialCitas = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                    .stream()
                    .filter(c -> c.getIdProfesional() == idProfesional)
                    .collect(Collectors.toList());

            // Generar códigos para cada cita
            if (historialCitas != null && !historialCitas.isEmpty()) {
                for (Cita cita : historialCitas) {
                    if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                    }
                }
            }

            // Verificar que el profesional haya atendido a este paciente
            if (historialCitas.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "No tienes historial de citas con este paciente");
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
    private void verHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idParam = request.getParameter("idPaciente");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idParam);

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Generar código y calcular edad
            if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
            }
            paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));

            // Obtener historial clínico
            List<HistorialClinico> historiales = historialDAO.listarHistorialPorPacienteYProfesional(idPaciente, idProfesional);

            // Generar códigos de citas vinculadas (con validación)
            if (historiales != null && !historiales.isEmpty()) {
                for (HistorialClinico historial : historiales) {
                    // Solo generar código si hay cita vinculada
                    if (historial.getIdCita() != null && historial.getIdCita() > 0) {
                        if (historial.getCodigoCita() == null || historial.getCodigoCita().isEmpty()) {
                            historial.setCodigoCita(GeneradorCodigos.generarCodigoCita(historial.getIdCita()));
                        }
                    }
                }
            }

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
    private void mostrarFormularioNuevoHistorial(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idParam = request.getParameter("idPaciente");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idParam);

            // Obtener datos del paciente
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            // Generar código y calcular edad
            if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
            }
            paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));

            // Obtener citas completadas del paciente con este profesional (para vincular opcionalmente)
            List<Cita> citasCompletadas = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                    .stream()
                    .filter(c -> c.getIdProfesional() == idProfesional && "COMPLETADA".equals(c.getEstado()))
                    .collect(Collectors.toList());

            // Generar códigos para citas
            if (citasCompletadas != null && !citasCompletadas.isEmpty()) {
                for (Cita cita : citasCompletadas) {
                    if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                        cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                    }
                }
            }

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
    private void crearHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
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

            if (idPacienteParam == null || idPacienteParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idPacienteParam);
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
            historial.setFechaHoraRegistro(LocalDateTime.now().toString());
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
                session.setAttribute("success", "Entrada de historial creada exitosamente");
            } else {
                session.setAttribute("error", "Error al crear la entrada de historial");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + idPaciente);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID inválido en el formulario");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== FORMULARIO EDITAR HISTORIAL ==========
    private void mostrarFormularioEditarHistorial(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de historial no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idHistorial = Integer.parseInt(idParam);

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

            // Generar código y calcular edad
            if (paciente != null) {
                if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                    paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                }
                paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));
            }

            request.setAttribute("historial", historial);
            request.setAttribute("paciente", paciente);

            request.getRequestDispatcher("/profesional/historial-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de historial inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== ACTUALIZAR HISTORIAL ==========
    private void actualizarHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idHistorialParam = request.getParameter("idHistorial");

            if (idHistorialParam == null || idHistorialParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de historial no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idHistorial = Integer.parseInt(idHistorialParam);
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
                session.setAttribute("success", "Entrada de historial actualizada exitosamente");
            } else {
                session.setAttribute("error", "Error al actualizar la entrada");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + historial.getIdPaciente());

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de historial inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== ELIMINAR HISTORIAL ==========
    private void eliminarHistorialClinico(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de historial no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
                return;
            }

            int idHistorial = Integer.parseInt(idParam);

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
                session.setAttribute("success", "Entrada de historial eliminada exitosamente");
            } else {
                session.setAttribute("error", "Error al eliminar la entrada");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet?accion=verHistorial&idPaciente=" + idPaciente);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de historial inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el historial: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteProfesionalServlet");
        }
    }

    // ========== MÉTODOS AUXILIARES ==========
    /**
     * Calcula la edad a partir de una fecha de nacimiento
     */
    private int calcularEdad(String fechaNacimiento) {
        if (fechaNacimiento == null || fechaNacimiento.isEmpty()) {
            return 0;
        }
        try {
            LocalDate fechaNac = LocalDate.parse(fechaNacimiento);
            LocalDate fechaActual = LocalDate.now();
            return Period.between(fechaNac, fechaActual).getYears();
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Genera un mapa con estadísticas para una lista de pacientes
     */
    private Map<Integer, Map<String, Object>> generarEstadisticasPacientes(
            List<Paciente> pacientes,
            int idProfesional) {

        Map<Integer, Map<String, Object>> estadisticasPacientes = new HashMap<>();

        if (pacientes == null || pacientes.isEmpty()) {
            return estadisticasPacientes;
        }

        for (Paciente paciente : pacientes) {
            Map<String, Object> stats = new HashMap<>();

            // Obtener estadísticas del paciente
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

        return estadisticasPacientes;
    }
}
