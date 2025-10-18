package controller;

import dao.UsuarioDAO;
import model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
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
                eliminarUsuario(request, response);
                break;
            default:
                listarUsuarios(request, response);
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

        // Obtener acción (compatible con "accion" y "action")
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = request.getParameter("action");
        }

        switch (accion) {
            case "crear":
                crearUsuario(request, response);
                break;
            case "actualizar":
                actualizarUsuario(request, response);
                break;
            default:
                listarUsuarios(request, response);
        }
    }

    // ========== LISTAR USUARIOS ==========
    /**
     * Lista todos los usuarios con sus roles
     */
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Usar el método mejorado con JOIN para traer nombre del rol
            List<Usuario> usuarios = usuarioDAO.listarUsuariosConRol();
            request.setAttribute("usuarios", usuarios);
            request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de usuarios: " + e.getMessage());
            request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    /**
     * Muestra el formulario para crear un nuevo usuario
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("accion", "crear");
        request.setAttribute("tituloFormulario", "Nuevo Usuario");
        request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
    }

    // ========== CREAR USUARIO ==========
    /**
     * Crea un nuevo usuario con validación de email
     */
    private void crearUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener datos del formulario
            String nombreCompleto = request.getParameter("nombreCompleto");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            int idRol = Integer.parseInt(request.getParameter("idRol"));

            // Validar que el email no exista
            if (usuarioDAO.existeEmail(email)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El email ya está registrado en el sistema");
                session.setAttribute("tipoMensaje", "danger");

                // Mantener los datos del formulario
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setNombreCompleto(nombreCompleto);
            usuario.setEmail(email);
            usuario.setPassword(password); // TODO: Encriptar en producción
            usuario.setIdRol(idRol);
            usuario.setActivo(true);

            // Insertar en la base de datos
            HttpSession session = request.getSession();
            if (usuarioDAO.insertarUsuario(usuario)) {
                session.setAttribute("mensaje", "Usuario creado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el usuario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    /**
     * Muestra el formulario para editar un usuario existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            Usuario usuario = usuarioDAO.buscarUsuarioPorId(idUsuario);

            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Usuario no encontrado");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el usuario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }

    // ========== ACTUALIZAR USUARIO ==========
    /**
     * Actualiza un usuario con validación de email Permite cambio opcional de
     * contraseña
     */
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener datos del formulario
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String nombreCompleto = request.getParameter("nombreCompleto");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            int idRol = Integer.parseInt(request.getParameter("idRol"));
            String activoParam = request.getParameter("activo");
            boolean activo = activoParam != null && (activoParam.equals("true") || activoParam.equals("on"));

            // Validar que el email no esté usado por otro usuario
            if (usuarioDAO.existeEmailExceptoUsuario(email, idUsuario)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El email ya está registrado por otro usuario");
                session.setAttribute("tipoMensaje", "danger");

                Usuario usuario = usuarioDAO.buscarUsuarioPorId(idUsuario);
                usuario.setNombreCompleto(nombreCompleto);
                usuario.setEmail(email);
                usuario.setIdRol(idRol);
                usuario.setActivo(activo);
                request.setAttribute("usuario", usuario);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setNombreCompleto(nombreCompleto);
            usuario.setEmail(email);
            usuario.setIdRol(idRol);
            usuario.setActivo(activo);

            boolean actualizado;

            // Si el password está vacío, no actualizarlo
            if (password == null || password.trim().isEmpty()) {
                actualizado = usuarioDAO.actualizarUsuarioSinPassword(usuario);
            } else {
                usuario.setPassword(password); // TODO: Encriptar en producción
                actualizado = usuarioDAO.actualizarUsuario(usuario);
            }

            HttpSession session = request.getSession();
            if (actualizado) {
                session.setAttribute("mensaje", "Usuario actualizado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el usuario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }

    // ========== ELIMINAR USUARIO ==========
    /**
     * Elimina un usuario con validación No permite eliminar el usuario actual
     * de la sesión
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));

            // Obtener usuario de la sesión para evitar que se elimine a sí mismo
            HttpSession session = request.getSession();
            Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

            if (usuarioSesion.getIdUsuario() == idUsuario) {
                session.setAttribute("error", "No puedes eliminar tu propia cuenta");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            // Eliminar usuario
            if (usuarioDAO.eliminarUsuario(idUsuario)) {
                session.setAttribute("mensaje", "Usuario eliminado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo eliminar el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el usuario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }
}
