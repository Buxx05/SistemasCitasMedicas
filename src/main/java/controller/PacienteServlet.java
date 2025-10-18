package controller;

import dao.PacienteDAO;
import model.Paciente;
import model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/PacienteServlet")
public class PacienteServlet extends HttpServlet {

    private PacienteDAO pacienteDAO;

    @Override
    public void init() {
        pacienteDAO = new PacienteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión y rol de administrador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion.getIdRol() != 1) {
            response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
            return;
        }

        // Obtener acción (compatible con "accion" y "action")
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
                eliminarPaciente(request, response);
                break;
            default:
                listarPacientes(request, response);
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

        // Obtener acción
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = request.getParameter("action");
        }

        switch (accion) {
            case "crear":
                crearPaciente(request, response);
                break;
            case "actualizar":
                actualizarPaciente(request, response);
                break;
            default:
                listarPacientes(request, response);
        }
    }

    // ========== LISTAR PACIENTES ==========
    /**
     * Lista todos los pacientes registrados
     */
    private void listarPacientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Paciente> pacientes = pacienteDAO.listarPacientes();
            request.setAttribute("pacientes", pacientes);
            request.getRequestDispatcher("/admin/pacientes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de pacientes: " + e.getMessage());
            request.getRequestDispatcher("/admin/pacientes.jsp").forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    /**
     * Muestra el formulario para crear un nuevo paciente
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("accion", "crear");
        request.setAttribute("tituloFormulario", "Nuevo Paciente");
        request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
    }

    // ========== CREAR PACIENTE ==========
    /**
     * Crea un nuevo paciente con validación de DNI
     */
    private void crearPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener datos del formulario
            String nombreCompleto = request.getParameter("nombreCompleto");
            String dni = request.getParameter("dni");
            String fechaNacimiento = request.getParameter("fechaNacimiento");
            String genero = request.getParameter("genero");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");

            // Validar que el DNI no exista
            if (pacienteDAO.existeDNI(dni)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El DNI ya está registrado en el sistema");
                session.setAttribute("tipoMensaje", "danger");

                // Mantener los datos del formulario
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("dni", dni);
                request.setAttribute("fechaNacimiento", fechaNacimiento);
                request.setAttribute("genero", genero);
                request.setAttribute("direccion", direccion);
                request.setAttribute("telefono", telefono);
                request.setAttribute("email", email);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Paciente");
                request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
                return;
            }

            // Validar email si no está vacío
            if (email != null && !email.trim().isEmpty() && pacienteDAO.existeEmail(email)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El email ya está registrado por otro paciente");
                session.setAttribute("tipoMensaje", "danger");

                // Mantener los datos del formulario
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("dni", dni);
                request.setAttribute("fechaNacimiento", fechaNacimiento);
                request.setAttribute("genero", genero);
                request.setAttribute("direccion", direccion);
                request.setAttribute("telefono", telefono);
                request.setAttribute("email", email);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Paciente");
                request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Paciente
            Paciente paciente = new Paciente();
            paciente.setNombreCompleto(nombreCompleto);
            paciente.setDni(dni);
            paciente.setFechaNacimiento(fechaNacimiento);
            paciente.setGenero(genero);
            paciente.setDireccion(direccion);
            paciente.setTelefono(telefono);
            paciente.setEmail(email);

            HttpSession session = request.getSession();

            if (pacienteDAO.insertarPaciente(paciente)) {
                session.setAttribute("mensaje", "Paciente creado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear el paciente");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    /**
     * Muestra el formulario para editar un paciente existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("id"));
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente != null) {
                request.setAttribute("paciente", paciente);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Paciente");
                request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }

    // ========== ACTUALIZAR PACIENTE ==========
    /**
     * Actualiza un paciente existente con validación de DNI
     */
    private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            String nombreCompleto = request.getParameter("nombreCompleto");
            String dni = request.getParameter("dni");
            String fechaNacimiento = request.getParameter("fechaNacimiento");
            String genero = request.getParameter("genero");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");

            // Validar que el DNI no esté usado por otro paciente
            if (pacienteDAO.existeDNIExceptoPaciente(dni, idPaciente)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El DNI ya está registrado por otro paciente");
                session.setAttribute("tipoMensaje", "danger");

                Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);
                paciente.setNombreCompleto(nombreCompleto);
                paciente.setDni(dni);
                paciente.setFechaNacimiento(fechaNacimiento);
                paciente.setGenero(genero);
                paciente.setDireccion(direccion);
                paciente.setTelefono(telefono);
                paciente.setEmail(email);
                request.setAttribute("paciente", paciente);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Paciente");
                request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Paciente
            Paciente paciente = new Paciente();
            paciente.setIdPaciente(idPaciente);
            paciente.setNombreCompleto(nombreCompleto);
            paciente.setDni(dni);
            paciente.setFechaNacimiento(fechaNacimiento);
            paciente.setGenero(genero);
            paciente.setDireccion(direccion);
            paciente.setTelefono(telefono);
            paciente.setEmail(email);

            HttpSession session = request.getSession();

            if (pacienteDAO.actualizarPaciente(paciente)) {
                session.setAttribute("mensaje", "Paciente actualizado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar el paciente");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }

    // ========== ELIMINAR PACIENTE ==========
    /**
     * Elimina un paciente del sistema
     */
    private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();

            if (pacienteDAO.eliminarPaciente(idPaciente)) {
                session.setAttribute("mensaje", "Paciente eliminado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo eliminar el paciente");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }
}
