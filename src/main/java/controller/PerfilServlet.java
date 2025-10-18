package controller;

import dao.UsuarioDAO;
import dao.ProfesionalDAO;
import model.Usuario;
import model.Profesional;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/PerfilServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class PerfilServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private ProfesionalDAO profesionalDAO;

    private static final String UPLOAD_DIR = "uploads/perfiles";

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        profesionalDAO = new ProfesionalDAO();
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

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "ver";
        }

        switch (accion) {
            case "editar":
                mostrarFormularioEditar(request, response, usuario);
                break;
            case "cambiarPassword":
                mostrarCambiarPassword(request, response, usuario);
                break;
            default:
                verPerfil(request, response, usuario);
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
            accion = "actualizar";
        }

        switch (accion) {
            case "actualizar":
                actualizarPerfil(request, response, usuario);
                break;
            case "actualizarPassword":
                actualizarPassword(request, response, usuario);
                break;
            case "subirFoto":
                subirFotoPerfil(request, response, usuario);
                break;
            default:
                verPerfil(request, response, usuario);
        }
    }

    // ========== VER PERFIL ==========
    private void verPerfil(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            Usuario usuarioCompleto = usuarioDAO.buscarUsuarioPorIdCompleto(usuario.getIdUsuario());

            if (usuarioCompleto == null) {
                throw new Exception("No se pudo cargar la información del usuario");
            }

            if (usuario.getIdRol() == 2 || usuario.getIdRol() == 3) {
                int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

                if (idProfesional > 0) {
                    // ✅ CAMBIO: Usar método con JOIN
                    Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);

                    if (profesional != null) {
                        request.setAttribute("profesional", profesional);
                    }
                }
            }

            request.setAttribute("usuarioPerfil", usuarioCompleto);

            String vistaJSP = determinarVistaPorRol(usuario.getIdRol(), "perfil");
            request.getRequestDispatcher(vistaJSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            String dashboardURL = (usuario.getIdRol() == 1)
                    ? "/DashboardAdminServlet"
                    : "/DashboardProfesionalServlet";

            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el perfil: " + e.getMessage());

            response.sendRedirect(request.getContextPath() + dashboardURL);
            return;
        }
    }

// ========== MOSTRAR FORMULARIO EDITAR ==========
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            Usuario usuarioCompleto = usuarioDAO.buscarUsuarioPorIdCompleto(usuario.getIdUsuario());

            if (usuarioCompleto == null) {
                throw new Exception("No se pudo cargar la información del usuario");
            }

            if (usuario.getIdRol() == 2 || usuario.getIdRol() == 3) {
                int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());

                if (idProfesional > 0) {
                    // ✅ CAMBIO: Usar método con JOIN
                    Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);

                    if (profesional != null) {
                        request.setAttribute("profesional", profesional);
                    }
                }
            }

            request.setAttribute("usuarioPerfil", usuarioCompleto);

            String vistaJSP = determinarVistaPorRol(usuario.getIdRol(), "perfil-editar");
            request.getRequestDispatcher(vistaJSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());

            response.sendRedirect(request.getContextPath() + "/PerfilServlet");
            return;
        }
    }

    // ========== ACTUALIZAR PERFIL ==========
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            // Obtener datos del formulario
            String nombreCompleto = request.getParameter("nombreCompleto");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String biografia = request.getParameter("biografia");

            // Actualizar objeto usuario
            usuario.setNombreCompleto(nombreCompleto);
            usuario.setTelefono(telefono);
            usuario.setDireccion(direccion);
            usuario.setBiografia(biografia);

            HttpSession session = request.getSession();

            if (usuarioDAO.actualizarPerfil(usuario)) {
                // Si es profesional, actualizar datos adicionales
                if (usuario.getIdRol() == 2 || usuario.getIdRol() == 3) {
                    String biografiaProfesional = request.getParameter("biografiaProfesional");
                    String aniosExperienciaStr = request.getParameter("aniosExperiencia");

                    if (biografiaProfesional != null && aniosExperienciaStr != null) {
                        int idProfesional = profesionalDAO.obtenerIdProfesionalPorIdUsuario(usuario.getIdUsuario());
                        int aniosExperiencia = Integer.parseInt(aniosExperienciaStr);
                        usuarioDAO.actualizarPerfilProfesional(idProfesional, biografiaProfesional, aniosExperiencia);
                    }
                }

                // Actualizar usuario en sesión
                Usuario usuarioActualizado = usuarioDAO.buscarUsuarioPorIdCompleto(usuario.getIdUsuario());
                session.setAttribute("usuario", usuarioActualizado);

                session.setAttribute("mensaje", "Perfil actualizado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar el perfil");
            }

            response.sendRedirect(request.getContextPath() + "/PerfilServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el perfil: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PerfilServlet");
        }
    }

    // ========== MOSTRAR CAMBIAR PASSWORD ==========
    private void mostrarCambiarPassword(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        String vistaJSP = determinarVistaPorRol(usuario.getIdRol(), "perfil-password");
        request.getRequestDispatcher(vistaJSP).forward(request, response);
    }

    // ========== ACTUALIZAR PASSWORD ==========
    private void actualizarPassword(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            String passwordAntigua = request.getParameter("passwordAntigua");
            String passwordNueva = request.getParameter("passwordNueva");
            String passwordConfirmar = request.getParameter("passwordConfirmar");

            HttpSession session = request.getSession();

            // Validar que las contraseñas coincidan
            if (!passwordNueva.equals(passwordConfirmar)) {
                session.setAttribute("error", "Las contraseñas no coinciden");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/PerfilServlet?accion=cambiarPassword");
                return;
            }

            // Validar longitud mínima
            if (passwordNueva.length() < 6) {
                session.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/PerfilServlet?accion=cambiarPassword");
                return;
            }

            // Cambiar contraseña
            if (usuarioDAO.cambiarPassword(usuario.getIdUsuario(), passwordAntigua, passwordNueva)) {
                session.setAttribute("mensaje", "Contraseña actualizada exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "La contraseña actual es incorrecta");
                session.setAttribute("tipoMensaje", "warning");
            }

            response.sendRedirect(request.getContextPath() + "/PerfilServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cambiar la contraseña: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PerfilServlet");
        }
    }

    // ========== SUBIR FOTO DE PERFIL ==========
    private void subirFotoPerfil(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            Part filePart = request.getPart("fotoPerfil");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));

                // Validar extensión
                if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)")) {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Solo se permiten imágenes (JPG, PNG, GIF)");
                    response.sendRedirect(request.getContextPath() + "/PerfilServlet?accion=editar");
                    return;
                }

                // Generar nombre único
                String uniqueFileName = usuario.getIdUsuario() + "_" + System.currentTimeMillis() + fileExtension;

                // Obtener ruta del directorio de subida
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Guardar archivo
                String filePath = uploadPath + File.separator + uniqueFileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }

                // Actualizar en BD
                if (usuarioDAO.actualizarFotoPerfil(usuario.getIdUsuario(), uniqueFileName)) {
                    usuario.setFotoPerfil(uniqueFileName);

                    // Actualizar en sesión
                    HttpSession session = request.getSession();
                    session.setAttribute("usuario", usuario);

                    session.setAttribute("mensaje", "Foto de perfil actualizada exitosamente");
                    session.setAttribute("tipoMensaje", "success");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Error al guardar la foto en la base de datos");
                }
            }

            response.sendRedirect(request.getContextPath() + "/PerfilServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al subir la foto: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/PerfilServlet");
        }
    }

    // ========== MÉTODO AUXILIAR ==========
    private String determinarVistaPorRol(int idRol, String vista) {
        // Todos los roles usan los mismos JSPs en /componentes/
        return "/componentes/" + vista + ".jsp";
    }

}
