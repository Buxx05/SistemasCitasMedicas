package controller;

import dao.PacienteDAO;
import model.Paciente;
import model.Usuario;
import util.GeneradorCodigos;
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
            session.setAttribute("error", "Esta sección es solo para administradores");
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

            // Generar códigos para los pacientes
            if (pacientes != null && !pacientes.isEmpty()) {
                for (Paciente paciente : pacientes) {
                    if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                        paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                    }
                }
            }

            request.setAttribute("pacientes", pacientes);
            request.getRequestDispatcher("/admin/pacientes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la lista de pacientes: " + e.getMessage());
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
     * Crea un nuevo paciente con validación de DNI y email
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

            // Validar campos obligatorios
            if (nombreCompleto == null || nombreCompleto.trim().isEmpty()
                    || dni == null || dni.trim().isEmpty()
                    || fechaNacimiento == null || fechaNacimiento.trim().isEmpty()
                    || genero == null || genero.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");

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

            // Validar que el DNI no exista
            if (pacienteDAO.existeDNI(dni.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI ya está registrado en el sistema");

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
            if (email != null && !email.trim().isEmpty() && pacienteDAO.existeEmail(email.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El email ya está registrado por otro paciente");

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
            paciente.setNombreCompleto(nombreCompleto.trim());
            paciente.setDni(dni.trim());
            paciente.setFechaNacimiento(fechaNacimiento);
            paciente.setGenero(genero);
            paciente.setDireccion(direccion != null ? direccion.trim() : null);
            paciente.setTelefono(telefono != null ? telefono.trim() : null);
            paciente.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);

            HttpSession session = request.getSession();

            if (pacienteDAO.insertarPaciente(paciente)) {
                session.setAttribute("success", "Paciente creado exitosamente");
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
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idParam);
            Paciente paciente = pacienteDAO.buscarPacientePorId(idPaciente);

            if (paciente != null) {
                // Generar código si no existe
                if (paciente.getCodigoPaciente() == null || paciente.getCodigoPaciente().isEmpty()) {
                    paciente.setCodigoPaciente(GeneradorCodigos.generarCodigoPaciente(paciente.getIdPaciente()));
                }

                request.setAttribute("paciente", paciente);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Paciente");
                request.getRequestDispatcher("/admin/pacientes-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Paciente no encontrado");
                response.sendRedirect(request.getContextPath() + "/PacienteServlet");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el paciente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }

    // ========== ACTUALIZAR PACIENTE ==========
    /**
     * Actualiza un paciente existente con validación de DNI y email
     */
    private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idPacienteParam = request.getParameter("idPaciente");

            if (idPacienteParam == null || idPacienteParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idPacienteParam);
            String nombreCompleto = request.getParameter("nombreCompleto");
            String dni = request.getParameter("dni");
            String fechaNacimiento = request.getParameter("fechaNacimiento");
            String genero = request.getParameter("genero");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");

            // Validar que el DNI no esté usado por otro paciente
            if (pacienteDAO.existeDNIExceptoPaciente(dni.trim(), idPaciente)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI ya está registrado por otro paciente");

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
            paciente.setNombreCompleto(nombreCompleto.trim());
            paciente.setDni(dni.trim());
            paciente.setFechaNacimiento(fechaNacimiento);
            paciente.setGenero(genero);
            paciente.setDireccion(direccion != null ? direccion.trim() : null);
            paciente.setTelefono(telefono != null ? telefono.trim() : null);
            paciente.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);

            HttpSession session = request.getSession();

            if (pacienteDAO.actualizarPaciente(paciente)) {
                session.setAttribute("success", "Paciente actualizado exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar el paciente");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
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
     * Elimina un paciente del sistema con validación de restricciones
     */
    private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de paciente no especificado");
                response.sendRedirect(request.getContextPath() + "/PacienteServlet");
                return;
            }

            int idPaciente = Integer.parseInt(idParam);
            HttpSession session = request.getSession();

            if (pacienteDAO.eliminarPaciente(idPaciente)) {
                session.setAttribute("success", "Paciente eliminado exitosamente");
            } else {
                session.setAttribute("warning", "No se pudo eliminar el paciente. Puede tener citas registradas.");
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de paciente inválido");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();

            // Mensaje más específico para errores de integridad
            String mensaje = e.getMessage();
            if (mensaje != null && (mensaje.contains("foreign key constraint") || mensaje.contains("constraint"))) {
                session.setAttribute("warning", "No se puede eliminar el paciente porque tiene citas, recetas o historiales registrados");
            } else {
                session.setAttribute("error", "Error al eliminar el paciente: " + mensaje);
            }

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
    }
}
