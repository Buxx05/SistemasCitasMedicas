package controller;

import dao.RecetaMedicaDAO;
import dao.ProfesionalDAO;
import dao.PacienteDAO;
import dao.CitaDAO;
import model.Usuario;
import model.RecetaMedica;
import model.Paciente;
import model.Cita;
import util.GeneradorCodigos;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/RecetaMedicaServlet")
public class RecetaMedicaServlet extends HttpServlet {

    private RecetaMedicaDAO recetaDAO;
    private ProfesionalDAO profesionalDAO;
    private PacienteDAO pacienteDAO;
    private CitaDAO citaDAO;

    @Override
    public void init() {
        recetaDAO = new RecetaMedicaDAO();
        profesionalDAO = new ProfesionalDAO();
        pacienteDAO = new PacienteDAO();
        citaDAO = new CitaDAO();
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
                verReceta(request, response, usuario);
                break;
            case "nueva":
                mostrarFormularioNueva(request, response, usuario);
                break;
            case "editar":
                mostrarFormularioEditar(request, response, usuario);
                break;
            default:
                listarRecetas(request, response, usuario);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

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
            case "crear":
                crearReceta(request, response, usuario);
                break;
            case "actualizar":
                actualizarReceta(request, response, usuario);
                break;
            case "eliminar":
                eliminarReceta(request, response, usuario);
                break;
            default:
                listarRecetas(request, response, usuario);
        }
    }

    // ========== LISTAR RECETAS ==========
    private void listarRecetas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                request.setAttribute("error", "No se encontró información del profesional");
                request.setAttribute("recetas", new ArrayList<>());
                request.setAttribute("totalRecetas", 0);
                request.setAttribute("recetasVigentes", 0);
                request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);
                return;
            }

            List<RecetaMedica> recetas = recetaDAO.listarRecetasPorProfesional(idProfesional);

            if (recetas == null) {
                recetas = new ArrayList<>();
            }

            // Generar códigos para recetas, pacientes y citas
            if (!recetas.isEmpty()) {
                for (RecetaMedica receta : recetas) {
                    // Código de receta
                    if (receta.getCodigoReceta() == null || receta.getCodigoReceta().isEmpty()) {
                        receta.setCodigoReceta(GeneradorCodigos.generarCodigoReceta(receta.getIdReceta()));
                    }
                    // Código de paciente
                    if (receta.getCodigoPaciente() == null || receta.getCodigoPaciente().isEmpty()) {
                        receta.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(receta.getIdPaciente()));
                    }
                    // Código de cita
                    if (receta.getCodigoCita() == null || receta.getCodigoCita().isEmpty()) {
                        receta.setCodigoCita(GeneradorCodigos.generarCodigoCita(receta.getIdCita()));
                    }
                }
            }

            int totalRecetas = recetas.size();
            int recetasVigentes = contarRecetasVigentes(recetas);

            request.setAttribute("recetas", recetas);
            request.setAttribute("totalRecetas", totalRecetas);
            request.setAttribute("recetasVigentes", recetasVigentes);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar las recetas: " + e.getMessage());
            request.setAttribute("recetas", new ArrayList<>());
            request.setAttribute("totalRecetas", 0);
            request.setAttribute("recetasVigentes", 0);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);
        }
    }

    // ========== VER RECETA ==========
    private void verReceta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de receta no especificado");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            int idReceta = Integer.parseInt(idParam);

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para ver esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            // Generar códigos
            if (receta.getCodigoReceta() == null || receta.getCodigoReceta().isEmpty()) {
                receta.setCodigoReceta(GeneradorCodigos.generarCodigoReceta(receta.getIdReceta()));
            }
            if (receta.getCodigoPaciente() == null || receta.getCodigoPaciente().isEmpty()) {
                receta.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(receta.getIdPaciente()));
            }
            if (receta.getCodigoCita() == null || receta.getCodigoCita().isEmpty()) {
                receta.setCodigoCita(GeneradorCodigos.generarCodigoCita(receta.getIdCita()));
            }

            // Obtener datos del paciente con edad
            Paciente paciente = pacienteDAO.buscarPacientePorId(receta.getIdPaciente());
            if (paciente != null) {
                if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                    paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                }
                paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));
                request.setAttribute("paciente", paciente);
            }

            // Calcular si está vigente
            boolean vigente = false;
            try {
                String fechaVig = receta.getFechaVigencia();
                if (fechaVig != null && !fechaVig.trim().isEmpty()) {
                    LocalDate fechaVigencia = LocalDate.parse(fechaVig);
                    vigente = !fechaVigencia.isBefore(LocalDate.now());
                }
            } catch (Exception e) {
                System.err.println("Error al parsear fecha de vigencia: " + e.getMessage());
            }

            request.setAttribute("receta", receta);
            request.setAttribute("vigente", vigente);
            request.getRequestDispatcher("/profesional/receta-detalle.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de receta inválido");
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la receta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== FORMULARIO NUEVA RECETA ==========
    private void mostrarFormularioNueva(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idPacienteStr = request.getParameter("idPaciente");
            String idCitaStr = request.getParameter("idCita");

            // Listar pacientes del profesional
            List<Paciente> pacientes = pacienteDAO.listarPacientesPorProfesional(idProfesional);

            // Generar códigos y edad para pacientes
            if (pacientes != null && !pacientes.isEmpty()) {
                for (Paciente p : pacientes) {
                    if (p.getCodigoPaciente() == null || p.getCodigoPaciente().isEmpty()) {
                        p.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(p.getIdPaciente()));
                    }
                    p.setEdad(calcularEdad(p.getFechaNacimiento()));
                }
            }

            // Si viene de una cita específica
            if (idCitaStr != null && !idCitaStr.trim().isEmpty()) {
                try {
                    int idCita = Integer.parseInt(idCitaStr);
                    Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);

                    if (cita != null && cita.getIdProfesional() == idProfesional) {
                        if (cita.getCodigoCita() == null || cita.getCodigoCita().isEmpty()) {
                            cita.setCodigoCita(GeneradorCodigos.generarCodigoCita(cita.getIdCita()));
                        }
                        request.setAttribute("citaSeleccionada", cita);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("ID de cita inválido: " + idCitaStr);
                }
            }

            // Si viene de un paciente específico
            if (idPacienteStr != null && !idPacienteStr.trim().isEmpty()) {
                try {
                    int idPaciente = Integer.parseInt(idPacienteStr);
                    Paciente pacienteSeleccionado = pacienteDAO.buscarPacientePorId(idPaciente);

                    if (pacienteSeleccionado != null) {
                        if (pacienteSeleccionado.getCodigoPaciente() == null || pacienteSeleccionado.getCodigoPaciente().isEmpty()) {
                            pacienteSeleccionado.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(pacienteSeleccionado.getIdPaciente()));
                        }
                        pacienteSeleccionado.setEdad(calcularEdad(pacienteSeleccionado.getFechaNacimiento()));

                        // Listar citas completadas del paciente con este profesional
                        List<Cita> citasPaciente = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                                .stream()
                                .filter(c -> c.getIdProfesional() == idProfesional && "COMPLETADA".equals(c.getEstado()))
                                .collect(Collectors.toList());

                        // Generar códigos para citas
                        if (citasPaciente != null && !citasPaciente.isEmpty()) {
                            for (Cita c : citasPaciente) {
                                if (c.getCodigoCita() == null || c.getCodigoCita().isEmpty()) {
                                    c.setCodigoCita(GeneradorCodigos.generarCodigoCita(c.getIdCita()));
                                }
                            }
                        }

                        request.setAttribute("pacienteSeleccionado", pacienteSeleccionado);
                        request.setAttribute("citasPaciente", citasPaciente);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("ID de paciente inválido: " + idPacienteStr);
                }
            }

            request.setAttribute("pacientes", pacientes);
            request.getRequestDispatcher("/profesional/receta-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== CREAR RECETA ==========
    private void crearReceta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            if (idProfesional == 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No se encontró información del profesional");
                response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                return;
            }

            String idCitaParam = request.getParameter("idCita");
            String idPacienteParam = request.getParameter("idPaciente");
            String medicamentos = request.getParameter("medicamentos");
            String dosis = request.getParameter("dosis");
            String frecuencia = request.getParameter("frecuencia");

            if (idCitaParam == null || idCitaParam.trim().isEmpty()
                    || idPacienteParam == null || idPacienteParam.trim().isEmpty()
                    || medicamentos == null || medicamentos.trim().isEmpty()
                    || dosis == null || dosis.trim().isEmpty()
                    || frecuencia == null || frecuencia.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
                return;
            }

            int idCita = Integer.parseInt(idCitaParam);
            int idPaciente = Integer.parseInt(idPacienteParam);

            Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);

            if (cita == null || cita.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para crear receta en esta cita");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
                return;
            }

            if (cita.getIdPaciente() != idPaciente) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "La cita no pertenece al paciente seleccionado");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
                return;
            }

            String duracion = request.getParameter("duracion");
            String indicaciones = request.getParameter("indicaciones");
            String observaciones = request.getParameter("observaciones");
            String fechaVigencia = request.getParameter("fechaVigencia");

            RecetaMedica receta = new RecetaMedica();
            receta.setIdCita(idCita);
            receta.setIdProfesional(idProfesional);
            receta.setIdPaciente(idPaciente);
            receta.setFechaEmision(LocalDate.now().toString());
            receta.setMedicamentos(medicamentos.trim());
            receta.setDosis(dosis.trim());
            receta.setFrecuencia(frecuencia.trim());
            receta.setDuracion(duracion != null ? duracion.trim() : null);
            receta.setIndicaciones(indicaciones != null ? indicaciones.trim() : null);
            receta.setObservaciones(observaciones != null ? observaciones.trim() : null);
            receta.setFechaVigencia(fechaVigencia);

            HttpSession session = request.getSession();

            if (recetaDAO.insertarReceta(receta)) {
                session.setAttribute("success", "Receta médica emitida exitosamente");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=ver&id=" + receta.getIdReceta());
            } else {
                session.setAttribute("error", "Error al emitir la receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos numéricos inválidos en el formulario");
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la receta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
        }
    }

    // ========== FORMULARIO EDITAR RECETA ==========
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de receta no especificado");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            int idReceta = Integer.parseInt(idParam);

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para editar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            // Generar códigos
            if (receta.getCodigoReceta() == null || receta.getCodigoReceta().isEmpty()) {
                receta.setCodigoReceta(GeneradorCodigos.generarCodigoReceta(receta.getIdReceta()));
            }

            // Obtener paciente con edad
            Paciente paciente = pacienteDAO.buscarPacientePorId(receta.getIdPaciente());
            if (paciente != null) {
                if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                    paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                }
                paciente.setEdad(calcularEdad(paciente.getFechaNacimiento()));
                request.setAttribute("paciente", paciente);
            }

            request.setAttribute("receta", receta);
            request.getRequestDispatcher("/profesional/receta-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de receta inválido");
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== ACTUALIZAR RECETA ==========
    private void actualizarReceta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            String idRecetaParam = request.getParameter("idReceta");
            if (idRecetaParam == null || idRecetaParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de receta no especificado");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            int idReceta = Integer.parseInt(idRecetaParam);

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            String medicamentos = request.getParameter("medicamentos");
            String dosis = request.getParameter("dosis");
            String frecuencia = request.getParameter("frecuencia");

            if (medicamentos == null || medicamentos.trim().isEmpty()
                    || dosis == null || dosis.trim().isEmpty()
                    || frecuencia == null || frecuencia.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=editar&id=" + idReceta);
                return;
            }

            receta.setMedicamentos(medicamentos.trim());
            receta.setDosis(dosis.trim());
            receta.setFrecuencia(frecuencia.trim());

            String duracion = request.getParameter("duracion");
            String indicaciones = request.getParameter("indicaciones");
            String observaciones = request.getParameter("observaciones");
            String fechaVigencia = request.getParameter("fechaVigencia");

            receta.setDuracion(duracion != null ? duracion.trim() : null);
            receta.setIndicaciones(indicaciones != null ? indicaciones.trim() : null);
            receta.setObservaciones(observaciones != null ? observaciones.trim() : null);
            receta.setFechaVigencia(fechaVigencia);

            HttpSession session = request.getSession();

            if (recetaDAO.actualizarReceta(receta)) {
                session.setAttribute("success", "Receta actualizada exitosamente");
            } else {
                session.setAttribute("error", "Error al actualizar la receta");
            }

            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=ver&id=" + idReceta);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos numéricos inválidos en el formulario");
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar la receta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== ELIMINAR RECETA ==========
    private void eliminarReceta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de receta no especificado");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            int idReceta = Integer.parseInt(idParam);

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para eliminar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            HttpSession session = request.getSession();

            if (recetaDAO.eliminarReceta(idReceta)) {
                session.setAttribute("success", "Receta eliminada exitosamente");
            } else {
                session.setAttribute("error", "Error al eliminar la receta");
            }

            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de receta inválido");
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar la receta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== MÉTODOS AUXILIARES ==========
    /**
     * Cuenta recetas vigentes de una lista
     */
    private int contarRecetasVigentes(List<RecetaMedica> recetas) {
        int vigentes = 0;

        for (RecetaMedica r : recetas) {
            try {
                String fechaVig = r.getFechaVigencia();
                if (fechaVig != null && !fechaVig.trim().isEmpty()) {
                    LocalDate vigencia = LocalDate.parse(fechaVig);
                    if (!vigencia.isBefore(LocalDate.now())) {
                        vigentes++;
                    }
                }
            } catch (Exception e) {
                System.err.println("Fecha de vigencia inválida para receta " + r.getIdReceta());
            }
        }

        return vigentes;
    }

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
}
