package controller;

import dao.EspecialidadDAO;
import model.Especialidad;
import model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/EspecialidadServlet")
public class EspecialidadServlet extends HttpServlet {

    private EspecialidadDAO especialidadDAO;

    @Override
    public void init() {
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

        // Obtener acción
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
                eliminarEspecialidad(request, response);
                break;
            default:
                listarEspecialidades(request, response);
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

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = request.getParameter("action");
        }

        switch (accion) {
            case "crear":
                crearEspecialidad(request, response);
                break;
            case "actualizar":
                actualizarEspecialidad(request, response);
                break;
            default:
                listarEspecialidades(request, response);
        }
    }

    // ========== LISTAR ESPECIALIDADES ==========
    private void listarEspecialidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Especialidad> especialidades = especialidadDAO.listarEspecialidades();
            request.setAttribute("especialidades", especialidades);
            request.getRequestDispatcher("/admin/especialidades.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la lista de especialidades: " + e.getMessage());
            request.getRequestDispatcher("/admin/especialidades.jsp").forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("accion", "crear");
        request.setAttribute("tituloFormulario", "Nueva Especialidad");
        request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
    }

    // ========== CREAR ESPECIALIDAD ==========
    private void crearEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");

            // ✅ Validación de campos obligatorios
            if (nombre == null || nombre.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El nombre de la especialidad es obligatorio");
                request.setAttribute("nombre", nombre);
                request.setAttribute("descripcion", descripcion);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nueva Especialidad");
                request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
                return;
            }

            // Validar que el nombre no exista
            if (especialidadDAO.existeNombre(nombre.trim())) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Ya existe una especialidad con ese nombre");

                request.setAttribute("nombre", nombre);
                request.setAttribute("descripcion", descripcion);
                request.setAttribute("accion", "crear");
                request.setAttribute("tituloFormulario", "Nueva Especialidad");
                request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
                return;
            }

            // Crear objeto Especialidad (código se genera automáticamente en DAO)
            Especialidad especialidad = new Especialidad();
            especialidad.setNombre(nombre.trim());
            especialidad.setDescripcion(descripcion != null ? descripcion.trim() : null);

            HttpSession session = request.getSession();

            if (especialidadDAO.insertarEspecialidad(especialidad)) {
                session.setAttribute("success", "Especialidad creada exitosamente con código: " + especialidad.getCodigo());
            } else {
                session.setAttribute("error", "Error al crear la especialidad");
            }

            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear la especialidad: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de especialidad no especificado");
                response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
                return;
            }

            int idEspecialidad = Integer.parseInt(idParam);
            Especialidad especialidad = especialidadDAO.buscarEspecialidadPorId(idEspecialidad);

            if (especialidad != null) {
                request.setAttribute("especialidad", especialidad);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Especialidad");
                request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Especialidad no encontrada");
                response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de especialidad inválido");
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar la especialidad: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        }
    }

    // ========== ACTUALIZAR ESPECIALIDAD ==========
    private void actualizarEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");

            // ✅ Validación de campos obligatorios
            if (nombre == null || nombre.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El nombre de la especialidad es obligatorio");

                Especialidad especialidad = especialidadDAO.buscarEspecialidadPorId(idEspecialidad);
                especialidad.setNombre(nombre);
                especialidad.setDescripcion(descripcion);
                request.setAttribute("especialidad", especialidad);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Especialidad");
                request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
                return;
            }

            // Validar que el nombre no esté usado por otra especialidad
            if (especialidadDAO.existeNombreExceptoEspecialidad(nombre.trim(), idEspecialidad)) {
                HttpSession session = request.getSession();
                session.setAttribute("warning", "Ya existe otra especialidad con ese nombre");

                Especialidad especialidad = especialidadDAO.buscarEspecialidadPorId(idEspecialidad);
                especialidad.setNombre(nombre);
                especialidad.setDescripcion(descripcion);
                request.setAttribute("especialidad", especialidad);
                request.setAttribute("accion", "actualizar");
                request.setAttribute("tituloFormulario", "Editar Especialidad");
                request.getRequestDispatcher("/admin/especialidades-form.jsp").forward(request, response);
                return;
            }

            // Actualizar especialidad (código es inmutable)
            Especialidad especialidad = new Especialidad();
            especialidad.setIdEspecialidad(idEspecialidad);
            especialidad.setNombre(nombre.trim());
            especialidad.setDescripcion(descripcion != null ? descripcion.trim() : null);

            HttpSession session = request.getSession();

            if (especialidadDAO.actualizarEspecialidad(especialidad)) {
                session.setAttribute("success", "Especialidad actualizada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar la especialidad");
            }

            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de especialidad inválido");
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar la especialidad: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        }
    }

    // ========== ELIMINAR ESPECIALIDAD ==========
    private void eliminarEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "ID de especialidad no especificado");
                response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
                return;
            }

            int idEspecialidad = Integer.parseInt(idParam);
            HttpSession session = request.getSession();

            // Verificar si tiene profesionales asignados
            int cantidadProfesionales = especialidadDAO.contarProfesionalesPorEspecialidad(idEspecialidad);

            if (cantidadProfesionales > 0) {
                session.setAttribute("warning", "No se puede eliminar la especialidad porque tiene "
                        + cantidadProfesionales + " profesional(es) asignado(s)");
                response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
                return;
            }

            if (especialidadDAO.eliminarEspecialidad(idEspecialidad)) {
                session.setAttribute("success", "Especialidad eliminada exitosamente");
            } else {
                session.setAttribute("error", "No se pudo eliminar la especialidad");
            }

            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID de especialidad inválido");
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar la especialidad: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/EspecialidadServlet");
        }
    }
}
