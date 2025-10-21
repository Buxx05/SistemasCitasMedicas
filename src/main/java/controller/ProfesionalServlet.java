package controller;

import dao.ProfesionalDAO;
import dao.UsuarioDAO;
import dao.EspecialidadDAO;
import model.Profesional;
import model.Usuario;
import model.Especialidad;
import util.GeneradorCodigos;
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

            // Generar códigos para los profesionales
            if (profesionales != null && !profesionales.isEmpty()) {
                for (Profesional profesional : profesionales) {
                    if (profesional.getCodigoProfesional() == null || profesional.getCodigoProfesional().isEmpty()) {
                        // ✅ CAMBIAR ESTA LÍNEA:
                        profesional.setCodigoProfesional(
                                GeneradorCodigos.generarCodigoProfesionalPorUsuario(
                                        profesional.getIdUsuario(), // ✅ Usa idUsuario en lugar de idProfesional
                                        profesional.getIdRol()
                                )
                        );
                    }
                }
            }

            request.setAttribute("profesionales", profesionales);
            request.getRequestDispatcher("/admin/profesionales.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la lista de profesionales: " + e.getMessage());
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
            String idRolParam = request.getParameter("idRol");
            String dni = request.getParameter("dni"); // ✅ DNI es parte del usuario

            // ========== DATOS DEL PROFESIONAL ==========
            String idEspecialidadParam = request.getParameter("idEspecialidad");
            String numeroLicencia = request.getParameter("numeroLicencia");
            String telefono = request.getParameter("telefono");

            // Validar campos obligatorios
            if (nombreCompleto == null || nombreCompleto.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || idRolParam == null || idRolParam.trim().isEmpty()
                    || dni == null || dni.trim().isEmpty() // ✅ Validar DNI como campo de usuario
                    || idEspecialidadParam == null || idEspecialidadParam.trim().isEmpty()
                    || numeroLicencia == null || numeroLicencia.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");

                // Recargar formulario con datos ingresados
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRolParam);
                request.setAttribute("dni", dni);
                request.setAttribute("idEspecialidad", idEspecialidadParam);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            int idRol = Integer.parseInt(idRolParam);
            int idEspecialidad = Integer.parseInt(idEspecialidadParam);

            // ========== VALIDAR FORMATO DEL DNI ==========
            if (!dni.trim().matches("\\d{8}")) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI debe contener exactamente 8 dígitos numéricos");

                // Recargar formulario
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("dni", dni);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // ========== VALIDAR QUE EL DNI NO EXISTA (EN USUARIOS) ==========
            if (profesionalDAO.existeDNI(dni.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI ya está registrado en el sistema");

                // Recargar formulario
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("dni", dni);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // Validar que el email no exista
            if (usuarioDAO.existeEmail(email.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El email ya está registrado en el sistema");

                // Recargar formulario
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("dni", dni);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // Validar que la licencia no exista
            if (profesionalDAO.existeLicencia(numeroLicencia.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El número de licencia ya está registrado");

                // Recargar formulario
                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("nombreCompleto", nombreCompleto);
                request.setAttribute("email", email);
                request.setAttribute("idRol", idRol);
                request.setAttribute("dni", dni);
                request.setAttribute("idEspecialidad", idEspecialidad);
                request.setAttribute("numeroLicencia", numeroLicencia);
                request.setAttribute("telefono", telefono);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nuevo Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // ========== PASO 1: CREAR USUARIO CON DNI ==========
            Usuario usuario = new Usuario();
            usuario.setNombreCompleto(nombreCompleto.trim());
            usuario.setEmail(email.trim());
            usuario.setPassword(password); // TODO: Encriptar en producción
            usuario.setIdRol(idRol);
            usuario.setActivo(true);
            usuario.setDni(dni.trim()); // ✅ GUARDAR DNI EN USUARIO

            HttpSession session = request.getSession();

            if (usuarioDAO.insertarUsuario(usuario)) {
                // Usuario creado exitosamente, ahora crear el profesional

                // ========== PASO 2: CREAR PROFESIONAL (SIN DNI) ==========
                Profesional profesional = new Profesional();
                profesional.setIdUsuario(usuario.getIdUsuario());
                profesional.setIdEspecialidad(idEspecialidad);
                profesional.setNumeroLicencia(numeroLicencia.trim());
                profesional.setTelefono(telefono != null ? telefono.trim() : null);
                // ❌ NO ASIGNAR DNI AQUÍ - Ya está en Usuario

                if (profesionalDAO.insertarProfesional(profesional)) {
                    session.setAttribute("success", "Profesional creado exitosamente");
                } else {
                    // Si falla crear profesional, eliminar el usuario creado
                    usuarioDAO.eliminarUsuario(usuario.getIdUsuario());
                    session.setAttribute("error", "Error al registrar los datos profesionales");
                }
            } else {
                session.setAttribute("error", "Error al crear el usuario");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos numéricos inválidos en el formulario");
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet?accion=nuevo");
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
     * editar datos profesionales (especialidad, licencia, teléfono, dni)
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de profesional no especificado");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
                return;
            }

            int idProfesional = Integer.parseInt(idParam);

            // Buscar profesional con detalles completos
            Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);

            if (profesional != null) {
                // Generar código si no existe
                if (profesional.getCodigoProfesional() == null || profesional.getCodigoProfesional().isEmpty()) {
                    profesional.setCodigoProfesional(
                            GeneradorCodigos.generarCodigoProfesional(profesional.getIdProfesional())
                    );
                }

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

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de profesional inválido");
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
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
    // ========== ACTUALIZAR PROFESIONAL ==========
    /**
     * Actualiza solo los datos profesionales El DNI se actualiza en la tabla
     * Usuarios, no en Profesionales
     */
    private void actualizarProfesional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idProfesionalParam = request.getParameter("idProfesional");
            String idEspecialidadParam = request.getParameter("idEspecialidad");
            String numeroLicencia = request.getParameter("numeroLicencia");
            String telefono = request.getParameter("telefono");
            String dni = request.getParameter("dni"); // ✅ DNI del usuario vinculado

            if (idProfesionalParam == null || idProfesionalParam.trim().isEmpty()
                    || idEspecialidadParam == null || idEspecialidadParam.trim().isEmpty()
                    || numeroLicencia == null || numeroLicencia.trim().isEmpty()
                    || dni == null || dni.trim().isEmpty()) {

                HttpSession session = request.getSession();
                session.setAttribute("error", "Debe completar todos los campos obligatorios");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
                return;
            }

            int idProfesional = Integer.parseInt(idProfesionalParam);
            int idEspecialidad = Integer.parseInt(idEspecialidadParam);

            // ========== VALIDAR FORMATO DEL DNI ==========
            if (!dni.trim().matches("\\d{8}")) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI debe contener exactamente 8 dígitos numéricos");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet?accion=editar&id=" + idProfesional);
                return;
            }

            // ========== VALIDAR QUE EL DNI NO ESTÉ USADO POR OTRO USUARIO ==========
            if (profesionalDAO.existeDNIExceptoProfesional(dni.trim(), idProfesional)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El DNI ya está registrado por otro usuario");

                // Recargar formulario
                Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);
                profesional.setIdEspecialidad(idEspecialidad);
                profesional.setNumeroLicencia(numeroLicencia);
                profesional.setTelefono(telefono);
                profesional.setDni(dni);

                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("profesional", profesional);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // Validar que la licencia no esté usada por otro profesional
            if (profesionalDAO.existeLicenciaExceptoProfesional(numeroLicencia.trim(), idProfesional)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "El número de licencia ya está registrado por otro profesional");

                // Recargar formulario
                Profesional profesional = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);
                profesional.setIdEspecialidad(idEspecialidad);
                profesional.setNumeroLicencia(numeroLicencia);
                profesional.setTelefono(telefono);
                profesional.setDni(dni);

                List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("profesional", profesional);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Profesional");
                request.getRequestDispatcher("/admin/profesionales-form.jsp").forward(request, response);
                return;
            }

            // ========== OBTENER EL PROFESIONAL ACTUAL PARA SABER SU ID_USUARIO ==========
            Profesional profesionalActual = profesionalDAO.buscarProfesionalPorIdConDetalles(idProfesional);

            if (profesionalActual == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Profesional no encontrado");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
                return;
            }

            HttpSession session = request.getSession();
            boolean exitoTotal = true;

            // ========== PASO 1: ACTUALIZAR DNI EN LA TABLA USUARIOS ==========
            Usuario usuario = usuarioDAO.buscarUsuarioPorId(profesionalActual.getIdUsuario());

            if (usuario != null) {
                // Solo actualizar si el DNI cambió
                if (!dni.trim().equals(usuario.getDni())) {
                    usuario.setDni(dni.trim());
                    if (!usuarioDAO.actualizarUsuario(usuario)) {
                        session.setAttribute("warning", "El profesional se actualizó pero hubo un problema al actualizar el DNI");
                        exitoTotal = false;
                    }
                }
            } else {
                session.setAttribute("warning", "No se pudo actualizar el DNI del usuario");
                exitoTotal = false;
            }

            // ========== PASO 2: ACTUALIZAR DATOS PROFESIONALES ==========
            Profesional profesional = new Profesional();
            profesional.setIdProfesional(idProfesional);
            profesional.setIdEspecialidad(idEspecialidad);
            profesional.setNumeroLicencia(numeroLicencia.trim());
            profesional.setTelefono(telefono != null ? telefono.trim() : null);
            // ❌ NO asignar DNI aquí - se actualiza en Usuario

            if (profesionalDAO.actualizarDatosProfesional(profesional)) {
                if (exitoTotal) {
                    session.setAttribute("success", "Profesional actualizado exitosamente");
                }
            } else {
                session.setAttribute("error", "No se pudo actualizar los datos profesionales");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Datos numéricos inválidos en el formulario");
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
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de profesional no especificado");
                response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
                return;
            }

            int idProfesional = Integer.parseInt(idParam);
            HttpSession session = request.getSession();

            if (profesionalDAO.eliminarProfesional(idProfesional)) {
                session.setAttribute("success", "Profesional eliminado exitosamente");
            } else {
                session.setAttribute("warning", "No se pudo eliminar el profesional. Puede tener citas o horarios registrados.");
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de profesional inválido");
            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();

            // Mensaje específico para errores de integridad
            String mensaje = e.getMessage();
            if (mensaje != null && (mensaje.contains("foreign key constraint") || mensaje.contains("constraint"))) {
                session.setAttribute("warning", "No se puede eliminar el profesional porque tiene citas u horarios registrados");
            } else {
                session.setAttribute("error", "Error al eliminar el profesional: " + mensaje);
            }

            response.sendRedirect(request.getContextPath() + "/ProfesionalServlet");
        }
    }
}
