package controller;

import dao.RecetaMedicaDAO;
import dao.ProfesionalDAO;
import dao.PacienteDAO;
import dao.CitaDAO;
import model.Usuario;
import model.RecetaMedica;
import model.Paciente;
import model.Cita;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
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

        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Solo profesionales (rol 2 y 3)
        if (usuario.getIdRol() != 2 && usuario.getIdRol() != 3) {
            request.setAttribute("error", "Solo los profesionales pueden emitir recetas");
            request.setAttribute("recetas", new ArrayList<>());
            request.setAttribute("totalRecetas", 0);
            request.setAttribute("recetasVigentes", 0);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);
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
            case "buscar":
                buscarRecetas(request, response, usuario);
                break;
            default:
                listarRecetas(request, response, usuario);
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

        // Solo profesionales (rol 2 y 3)
        if (usuario.getIdRol() != 2 && usuario.getIdRol() != 3) {
            session.setAttribute("error", "Solo los profesionales pueden emitir recetas");
            response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
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

            int totalRecetas = recetas.size();
            int recetasVigentes = 0;

            for (RecetaMedica r : recetas) {
                try {
                    if (r.getFechaVigencia() != null && !r.getFechaVigencia().isEmpty()) {
                        LocalDate vigencia = LocalDate.parse(r.getFechaVigencia());
                        if (!vigencia.isBefore(LocalDate.now())) {
                            recetasVigentes++;
                        }
                    }
                } catch (Exception e) {
                    // Ignorar fechas inválidas
                }
            }

            request.setAttribute("recetas", recetas);
            request.setAttribute("totalRecetas", totalRecetas);
            request.setAttribute("recetasVigentes", recetasVigentes);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar las recetas: " + e.getMessage());
            request.setAttribute("recetas", new ArrayList<>());
            request.setAttribute("totalRecetas", 0);
            request.setAttribute("recetasVigentes", 0);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);
        }
    }

    // ========== BUSCAR RECETAS ==========
    private void buscarRecetas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            String busqueda = request.getParameter("busqueda");

            List<RecetaMedica> recetas = recetaDAO.listarRecetasPorProfesional(idProfesional);

            if (busqueda != null && !busqueda.trim().isEmpty()) {
                final String busquedaLower = busqueda.toLowerCase();
                recetas = recetas.stream()
                        .filter(r -> r.getNombrePaciente().toLowerCase().contains(busquedaLower)
                        || r.getDniPaciente().contains(busqueda))
                        .collect(Collectors.toList());
            }

            int totalRecetas = recetas.size();
            int recetasVigentes = 0;

            for (RecetaMedica r : recetas) {
                try {
                    if (r.getFechaVigencia() != null && !r.getFechaVigencia().isEmpty()) {
                        LocalDate vigencia = LocalDate.parse(r.getFechaVigencia());
                        if (!vigencia.isBefore(LocalDate.now())) {
                            recetasVigentes++;
                        }
                    }
                } catch (Exception e) {
                    // Ignorar
                }
            }

            request.setAttribute("recetas", recetas);
            request.setAttribute("totalRecetas", totalRecetas);
            request.setAttribute("recetasVigentes", recetasVigentes);
            request.setAttribute("busqueda", busqueda);
            request.getRequestDispatcher("/profesional/recetas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al buscar recetas: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }

    // ========== VER RECETA ==========
    private void verReceta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
            int idReceta = Integer.parseInt(request.getParameter("id"));

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para ver esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            boolean vigente = false;
            try {
                LocalDate fechaVigencia = LocalDate.parse(receta.getFechaVigencia());
                vigente = fechaVigencia.isAfter(LocalDate.now()) || fechaVigencia.isEqual(LocalDate.now());
            } catch (Exception e) {
                e.printStackTrace();
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

            String idPacienteStr = request.getParameter("idPaciente");
            String idCitaStr = request.getParameter("idCita");

            List<Paciente> pacientes = pacienteDAO.listarPacientesPorProfesional(idProfesional);

            if (idCitaStr != null && !idCitaStr.trim().isEmpty()) {
                int idCita = Integer.parseInt(idCitaStr);
                Cita cita = citaDAO.buscarCitaPorIdConDetalles(idCita);
                if (cita != null && cita.getIdProfesional() == idProfesional) {
                    request.setAttribute("citaSeleccionada", cita);
                }
            }

            if (idPacienteStr != null && !idPacienteStr.trim().isEmpty()) {
                int idPaciente = Integer.parseInt(idPacienteStr);
                Paciente pacienteSeleccionado = pacienteDAO.buscarPacientePorId(idPaciente);

                List<Cita> citasPaciente = citaDAO.listarCitasPorPacienteConDetalles(idPaciente)
                        .stream()
                        .filter(c -> c.getIdProfesional() == idProfesional && "COMPLETADA".equals(c.getEstado()))
                        .collect(Collectors.toList());

                request.setAttribute("pacienteSeleccionado", pacienteSeleccionado);
                request.setAttribute("citasPaciente", citasPaciente);
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

            int idCita = Integer.parseInt(request.getParameter("idCita"));
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            String medicamentos = request.getParameter("medicamentos");
            String dosis = request.getParameter("dosis");
            String frecuencia = request.getParameter("frecuencia");
            String duracion = request.getParameter("duracion");
            String indicaciones = request.getParameter("indicaciones");
            String observaciones = request.getParameter("observaciones");
            String fechaVigencia = request.getParameter("fechaVigencia");

            RecetaMedica receta = new RecetaMedica();
            receta.setIdCita(idCita);
            receta.setIdProfesional(idProfesional);
            receta.setIdPaciente(idPaciente);
            receta.setFechaEmision(LocalDate.now().toString());
            receta.setMedicamentos(medicamentos);
            receta.setDosis(dosis);
            receta.setFrecuencia(frecuencia);
            receta.setDuracion(duracion);
            receta.setIndicaciones(indicaciones);
            receta.setObservaciones(observaciones);
            receta.setFechaVigencia(fechaVigencia);

            HttpSession session = request.getSession();

            if (recetaDAO.insertarReceta(receta)) {
                session.setAttribute("mensaje", "Receta médica emitida exitosamente");
                session.setAttribute("tipoMensaje", "success");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=ver&id=" + receta.getIdReceta());
            } else {
                session.setAttribute("error", "Error al emitir la receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=nueva");
            }

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
            int idReceta = Integer.parseInt(request.getParameter("id"));

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para editar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            request.setAttribute("receta", receta);
            request.getRequestDispatcher("/profesional/receta-form.jsp").forward(request, response);

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
            int idReceta = Integer.parseInt(request.getParameter("idReceta"));

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para modificar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            receta.setMedicamentos(request.getParameter("medicamentos"));
            receta.setDosis(request.getParameter("dosis"));
            receta.setFrecuencia(request.getParameter("frecuencia"));
            receta.setDuracion(request.getParameter("duracion"));
            receta.setIndicaciones(request.getParameter("indicaciones"));
            receta.setObservaciones(request.getParameter("observaciones"));
            receta.setFechaVigencia(request.getParameter("fechaVigencia"));

            HttpSession session = request.getSession();

            if (recetaDAO.actualizarReceta(receta)) {
                session.setAttribute("mensaje", "Receta actualizada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al actualizar la receta");
            }

            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet?accion=ver&id=" + idReceta);

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
            int idReceta = Integer.parseInt(request.getParameter("id"));

            RecetaMedica receta = recetaDAO.buscarRecetaPorId(idReceta);

            if (receta == null || receta.getIdProfesional() != idProfesional) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "No tienes permiso para eliminar esta receta");
                response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
                return;
            }

            HttpSession session = request.getSession();

            if (recetaDAO.eliminarReceta(idReceta)) {
                session.setAttribute("mensaje", "Receta eliminada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al eliminar la receta");
            }

            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar la receta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaMedicaServlet");
        }
    }
}
