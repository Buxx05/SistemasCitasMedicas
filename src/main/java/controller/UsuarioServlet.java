package controller;

import dao.RolDAO;
import dao.UsuarioDAO;
import model.Usuario;
import model.Rol;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private RolDAO rolDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        rolDAO = new RolDAO();
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
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la lista de usuarios: " + e.getMessage());
            request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    /**
     * Muestra el formulario para crear un nuevo usuario
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Rol> roles = rolDAO.listarRoles();
            request.setAttribute("roles", roles);
            request.setAttribute("accion", "crear");
            request.setAttribute("tituloFormulario", "Nuevo Usuario");
            request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
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
            String idRolParam = request.getParameter("idRol");

            // Validar campos obligatorios
            if (nombreCompleto == null || nombreCompleto.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || idRolParam == null || idRolParam.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");

                // Mantener los datos del formulario
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRolParam);
                List<Rol> roles = rolDAO.listarRoles();
                request.setAttribute("roles", roles);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            int idRol = Integer.parseInt(idRolParam);

            // Validar longitud mínima de contraseña
            if (password.length() < 6) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "La contraseña debe tener al menos 6 caracteres");

                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                List<Rol> roles = rolDAO.listarRoles();
                request.setAttribute("roles", roles);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            // Validar que el email no exista
            if (usuarioDAO.existeEmail(email.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El email ya está registrado en el sistema");

                // Mantener los datos del formulario
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                List<Rol> roles = rolDAO.listarRoles();
                request.setAttribute("roles", roles);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setNombreCompleto(nombreCompleto.trim());
            usuario.setEmail(email.trim());
            usuario.setPassword(password); // TODO: Encriptar en producción
            usuario.setIdRol(idRol);
            usuario.setActivo(true);

            // Insertar en la base de datos
            HttpSession session = request.getSession();
            if (usuarioDAO.insertarUsuario(usuario)) {
                session.setAttribute("success", "Usuario creado exitosamente");
            } else {
                session.setAttribute("error", "Error al crear el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Rol de usuario inválido");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet?accion=nuevo");
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
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de usuario no especificado");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            int idUsuario = Integer.parseInt(idParam);
            Usuario usuario = usuarioDAO.buscarUsuarioPorId(idUsuario);

            if (usuario != null) {
                List<Rol> roles = rolDAO.listarRoles();
                request.setAttribute("roles", roles);
                request.setAttribute("usuario", usuario);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Usuario no encontrado");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de usuario inválido");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el usuario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }

    // ========== ACTUALIZAR USUARIO ==========
    /**
     * Actualiza un usuario con validación de email
     * Permite cambio opcional de contraseña
     */
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener datos del formulario
            String idUsuarioParam = request.getParameter("idUsuario");
            String nombreCompleto = request.getParameter("nombreCompleto");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String idRolParam = request.getParameter("idRol");
            String activoParam = request.getParameter("activo");

            if (idUsuarioParam == null || idUsuarioParam.trim().isEmpty()
                    || nombreCompleto == null || nombreCompleto.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || idRolParam == null || idRolParam.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            int idUsuario = Integer.parseInt(idUsuarioParam);
            int idRol = Integer.parseInt(idRolParam);
            boolean activo = activoParam != null && (activoParam.equals("true") || activoParam.equals("on"));

            // Validar longitud de contraseña si se proporciona
            if (password != null && !password.trim().isEmpty() && password.length() < 6) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "La contraseña debe tener al menos 6 caracteres");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet?accion=editar&id=" + idUsuario);
                return;
            }

            // Validar que el email no esté usado por otro usuario
            if (usuarioDAO.existeEmailExceptoUsuario(email.trim(), idUsuario)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El email ya está registrado por otro usuario");

                Usuario usuario = usuarioDAO.buscarUsuarioPorId(idUsuario);
                usuario.setNombreCompleto(nombreCompleto);
                usuario.setEmail(email);
                usuario.setIdRol(idRol);
                usuario.setActivo(activo);
                List<Rol> roles = rolDAO.listarRoles();
                request.setAttribute("roles", roles);
                request.setAttribute("usuario", usuario);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Usuario");
                request.getRequestDispatcher("/admin/usuarios-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setNombreCompleto(nombreCompleto.trim());
            usuario.setEmail(email.trim());
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
                session.setAttribute("success", "Usuario actualizado exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos numéricos inválidos en el formulario");
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
     * Elimina un usuario con validación
     * No permite eliminar el usuario actual de la sesión
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de usuario no especificado");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            int idUsuario = Integer.parseInt(idParam);

            // Obtener usuario de la sesión para evitar que se elimine a sí mismo
            HttpSession session = request.getSession();
            Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

            if (usuarioSesion.getIdUsuario() == idUsuario) {
                session.setAttribute("warning", "No puedes eliminar tu propia cuenta");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            // Eliminar usuario
            if (usuarioDAO.eliminarUsuario(idUsuario)) {
                session.setAttribute("success", "Usuario eliminado exitosamente");
            } else {
                session.setAttribute("warning", "No se pudo eliminar el usuario. Puede tener registros asociados.");
            }

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de usuario inválido");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            
            // Mensaje específico para errores de integridad
            String mensaje = e.getMessage();
            if (mensaje != null && (mensaje.contains("foreign key constraint") || mensaje.contains("constraint"))) {
                session.setAttribute("warning", "No se puede eliminar el usuario porque tiene registros asociados (profesional, citas, etc.)");
            } else {
                session.setAttribute("error", "Error al eliminar el usuario: " + mensaje);
            }
            
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }
}
