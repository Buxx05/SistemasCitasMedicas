package controller;

import dao.ProfesionalDAO;
import dao.UsuarioDAO;
import dao.EspecialidadDAO;
import model.Profesional;
import model.Usuario;
import model.Especialidad;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProfesionalServlet")
public class ProfesionalServlet extends HttpServlet {

    private ProfesionalDAO profesionalDAO;
    private UsuarioDAO usuarioDAO;
    private EspecialidadDAO especialidadDAO;

    @Override
    public void init() {
        profesionalDAO = new ProfesionalDAO();
        usuarioDAO = new UsuarioDAO();
        especialidadDAO = new EspecialidadDAO();
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
                eliminarProfesional(request, response);
                break;
            default:
                listarProfesionales(request, response);
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
                crearProfesional(request, response);
                break;
            case "actualizar":
                actualizarProfesional(request, response);
                break;
            default:
                listarProfesionales(request, response);
        }
    }

    // ========== LISTAR PROFESIONALES ==========
    /**
     * Lista todos los profesionales con sus datos completos
     */
    private void listarProfesionales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Usar el método con JOIN para traer todos los datos
            List<Profesional> profesionales = profesionalDAO.listarProfesionalesConDetalles();
            request.setAttribute("profesionales", profesionales);
            request.getRequestDispatcher("/admin/profesionales.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de profesionales: " + e.getMessage());
            request.getRequestDispatcher("/admin/profesionales.jsp").forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    /**
     * Muestra el formulario para crear un nuevo profesional Carga la lista de
     * especialidades para el select
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Cargar lista de especialidades para el select
            List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
            request.setAttribute("especialidades", especialidades);

            request.setAttribute("accion", "crear");
            request.setAttribute("tituloFormulario", "Nuevo Profesional");
            request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }

    // ========== CREAR PROFESIONAL (FORMULARIO INTEGRADO) ==========
    /**
     * Crea un nuevo profesional con su usuario en un solo paso PASO 1: Crea el
     * usuario PASO 2: Vincula como profesional
     */
    private void crearProfesional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ========== DATOS DEL USUARIO ==========
            String nombreCompleto = request.getParameter("nombreCompleto");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            int idRol = Integer.parseInt(request.getParameter("idRol")); // 2 o 3

            // ========== DATOS DEL PROFESIONAL ==========
            int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));
            String numeroLicencia = request.getParameter("numeroLicencia");
            String telefono = request.getParameter("telefono");

            // ========== VALIDACIONES ==========
            // Validar que el email no exista
            if (usuarioDAO.existeEmail(email)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El email ya está registrado en el sistema");
                session.setAttribute("tipoMensaje", "danger");

                // Recargar formulario con datos ingresados
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // Validar que la licencia no exista
            if (profesionalDAO.existeLicencia(numeroLicencia)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El número de licencia ya está registrado");
                session.setAttribute("tipoMensaje", "danger");

                // Recargar formulario
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // ========== PASO 1: CREAR USUARIO ==========
            Usuario usuario = new Usuario();
            usuario.setNombreCompleto(nombreCompleto);
            usuario.setEmail(email);
            usuario.setPassword(password); // TODO: Encriptar en producción
            usuario.setIdRol(idRol);
            usuario.setActivo(true);

            HttpSession session = request.getSession();

            if (usuarioDAO.insertarUsuario(usuario)) {
                // Usuario creado exitosamente, ahora crear el profesional

                // ========== PASO 2: CREAR PROFESIONAL ==========
                Profesional profesional = new Profesional();
                profesional.setIdUsuario(usuario.getIdUsuario()); // ID generado automáticamente
                profesional.setIdEspecialidad(idEspecialidad);
                profesional.setNumeroLicencia(numeroLicencia);
                profesional.setTelefono(telefono);

                if (profesionalDAO.insertarProfesional(profesional)) {
                    session.setAttribute("mensaje", "Profesional creado exitosamente");
                    session.setAttribute("tipoMensaje", "success");
                } else {
                    // Si falla crear profesional, eliminar el usuario creado
                    usuarioDAO.eliminarUsuario(usuario.getIdUsuario());
                    session.setAttribute("error", "Error al registrar los datos profesionales");
                }
            } else {
                session.setAttribute("error", "Error al crear el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el profesional: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    /**
     * Muestra el formulario para editar un profesional existente Solo permite
     * editar datos profesionales (especialidad, licencia, teléfono)
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProfesional = Integer.parseInt(request.getParameter("id"));

            // Buscar profesional con detalles completos
            Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);

            if (profesional != null) {
                // Cargar lista de especialidades para el select
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);

                request.setAttribute("profesional", profesional);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Profesional no encontrado");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el profesional: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }

    // ========== ACTUALIZAR PROFESIONAL ==========
    /**
     * Actualiza solo los datos profesionales No modifica los datos del usuario
     * (nombre, email)
     */
    private void actualizarProfesional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));
            String numeroLicencia = request.getParameter("numeroLicencia");
            String telefono = request.getParameter("telefono");

            // Validar que la licencia no esté usada por otro profesional
            if (profesionalDAO.existeLicenciaExceptoProfesional(numeroLicencia, idProfesional)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El número de licencia ya está registrado por otro profesional");
                session.setAttribute("tipoMensaje", "danger");

                // Recargar formulario
                Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);
                profesional.setIdEspecialidad(idEspecialidad);
                profesional.setNumeroLicencia(numeroLicencia);
                profesional.setTelefono(telefono);

                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("profesional", profesional);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Profesional con los datos actualizados
            Profesional profesional = new Profesional();
            profesional.setIdProfesional(idProfesional);
            profesional.setIdEspecialidad(idEspecialidad);
            profesional.setNumeroLicencia(numeroLicencia);
            profesional.setTelefono(telefono);

            HttpSession session = request.getSession();

            // Actualizar solo datos profesionales (no usuario)
            if (profesionalDAO.actualizarDatosProfesional(profesional)) {
                session.setAttribute("mensaje", "Profesional actualizado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar el profesional");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el profesional: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }

    // ========== ELIMINAR PROFESIONAL ==========
    /**
     * Elimina un profesional Solo elimina el registro profesional, el usuario
     * se mantiene (puede eliminarse desde el módulo de usuarios si se desea)
     */
    private void eliminarProfesional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProfesional = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();

            if (profesionalDAO.eliminarProfesional(idProfesional)) {
                session.setAttribute("mensaje", "Profesional eliminado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo eliminar el profesional");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el profesional: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }
}
