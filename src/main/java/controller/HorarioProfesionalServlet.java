package controller;

import dao.HorarioProfesionalDAO;
import dao.ProfesionalDAO;
import model.HorarioProfesional;
import model.Usuario;
import model.Profesional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/HorarioProfesionalServlet")
public class HorarioProfesionalServlet extends HttpServlet {

    private HorarioProfesionalDAO horarioDAO;
    private ProfesionalDAO profesionalDAO;

    @Override
    public void init() {
        horarioDAO = new HorarioProfesionalDAO();
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
        int rol = usuario.getIdRol();

        // Solo profesionales (rol 2 y 3) y admin (rol 1) pueden acceder
        if (rol != 1 && rol != 2 && rol != 3) {
            response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                mostrarFormularioNuevo(request, response, usuario);
                break;
            case "editar":
                mostrarFormularioEditar(request, response, usuario);
                break;
            case "eliminar":
                eliminarHorario(request, response, usuario);
                break;
            default:
                listarHorarios(request, response, usuario);
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
            accion = "crear";
        }

        switch (accion) {
            case "crear":
                crearHorario(request, response, usuario);
                break;
            case "actualizar":
                actualizarHorario(request, response, usuario);
                break;
            default:
                listarHorarios(request, response, usuario);
        }
    }

    // ========== LISTAR HORARIOS ==========
    private void listarHorarios(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            List<HorarioProfesional> horarios;
            String vistaJSP;

            if (usuario.getIdRol() == 1) {
                // Admin: Ver todos los horarios con detalles
                horarios = horarioDAO.listarHorariosConDetalles();
                vistaJSP = "/admin/horarios.jsp";
            } else {
                // Profesional: Ver solo sus horarios
                int idProfesional = obtenerIdProfesional(usuario.getIdUsuario());
                horarios = horarioDAO.listarHorariosPorProfesional(idProfesional);
                vistaJSP = "/profesional/horarios.jsp";
            }

            request.setAttribute("horarios", horarios);
            request.getRequestDispatcher(vistaJSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los horarios: " + e.getMessage());

            // Forward según el rol
            String vistaError = usuario.getIdRol() == 1 ? "/admin/horarios.jsp" : "/profesional/horarios.jsp";
            request.getRequestDispatcher(vistaError).forward(request, response);
        }
    }

    // ========== MOSTRAR FORMULARIO NUEVO ==========
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            request.setAttribute("accion", "crear");
            request.setAttribute("tituloFormulario", "Nuevo Horario");

            if (usuario.getIdRol() == 1) {
                // Admin: Puede elegir profesional
                List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();
                request.setAttribute("profesionales", profesionales);
                request.getRequestDispatcher("/admin/horario-form.jsp").forward(request, response);
            } else {
                // Profesional: Solo para sí mismo
                request.getRequestDispatcher("/profesional/horarios-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
        }
    }

    // ========== CREAR HORARIO ==========
    private void crearHorario(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idProfesional;

            // Determinar el ID del profesional según el rol
            if (usuario.getIdRol() == 1) {
                // Admin: Puede crear para cualquier profesional
                idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            } else {
                // Profesional: Solo para sí mismo
                idProfesional = obtenerIdProfesional(usuario.getIdUsuario());
            }

            String diaSemana = request.getParameter("diaSemana");
            String horaInicio = request.getParameter("horaInicio");
            String horaFin = request.getParameter("horaFin");
            int duracionConsulta = Integer.parseInt(request.getParameter("duracionConsulta"));
            boolean activo = request.getParameter("activo") != null;

            // Validar que hora fin sea mayor que hora inicio
            if (horaFin.compareTo(horaInicio) <= 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "La hora de fin debe ser mayor que la hora de inicio");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet?accion=nuevo");
                return;
            }

            // Validar que no se solape con horarios existentes
            if (horarioDAO.existeSolapamiento(idProfesional, diaSemana, horaInicio, horaFin)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El horario se solapa con otro horario existente en ese día");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet?accion=nuevo");
                return;
            }

            // Crear objeto HorarioProfesional
            HorarioProfesional horario = new HorarioProfesional();
            horario.setIdProfesional(idProfesional);
            horario.setDiaSemana(diaSemana);
            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);
            horario.setDuracionConsulta(duracionConsulta);
            horario.setActivo(activo);

            HttpSession session = request.getSession();

            if (horarioDAO.insertarHorario(horario)) {
                session.setAttribute("mensaje", "Horario creado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "Error al crear el horario");
            }

            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al crear el horario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
        }
    }

    // ========== MOSTRAR FORMULARIO EDITAR ==========
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idHorario = Integer.parseInt(request.getParameter("id"));
            HorarioProfesional horario = horarioDAO.buscarHorarioPorId(idHorario);

            if (horario == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Horario no encontrado");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
                return;
            }

            // Verificar que el profesional solo pueda editar sus propios horarios
            if (usuario.getIdRol() != 1) {
                int idProfesional = obtenerIdProfesional(usuario.getIdUsuario());
                if (horario.getIdProfesional() != idProfesional) {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "No tienes permiso para editar este horario");
                    response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
                    return;
                }
            }

            request.setAttribute("horario", horario);
            request.setAttribute("accion", "actualizar");
            request.setAttribute("tituloFormulario", "Editar Horario");

            if (usuario.getIdRol() == 1) {
                List<Profesional> profesionales = profesionalDAO.listarProfesionalesActivos();
                request.setAttribute("profesionales", profesionales);
                request.getRequestDispatcher("/admin/horario-form.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/profesional/horarios-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al cargar el horario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
        }
    }

    // ========== ACTUALIZAR HORARIO ==========
    private void actualizarHorario(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idHorario = Integer.parseInt(request.getParameter("idHorario"));
            int idProfesional;

            // Determinar el ID del profesional según el rol
            if (usuario.getIdRol() == 1) {
                idProfesional = Integer.parseInt(request.getParameter("idProfesional"));
            } else {
                idProfesional = obtenerIdProfesional(usuario.getIdUsuario());
            }

            String diaSemana = request.getParameter("diaSemana");
            String horaInicio = request.getParameter("horaInicio");
            String horaFin = request.getParameter("horaFin");
            int duracionConsulta = Integer.parseInt(request.getParameter("duracionConsulta"));
            boolean activo = request.getParameter("activo") != null;

            // Validar que hora fin sea mayor que hora inicio
            if (horaFin.compareTo(horaInicio) <= 0) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "La hora de fin debe ser mayor que la hora de inicio");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet?accion=editar&id=" + idHorario);
                return;
            }

            // Validar solapamiento excluyendo este horario
            if (horarioDAO.existeSolapamientoExcepto(idProfesional, diaSemana, horaInicio, horaFin, idHorario)) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "El horario se solapa con otro horario existente");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet?accion=editar&id=" + idHorario);
                return;
            }

            // Crear objeto HorarioProfesional
            HorarioProfesional horario = new HorarioProfesional();
            horario.setIdHorario(idHorario);
            horario.setIdProfesional(idProfesional);
            horario.setDiaSemana(diaSemana);
            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);
            horario.setDuracionConsulta(duracionConsulta);
            horario.setActivo(activo);

            HttpSession session = request.getSession();

            if (horarioDAO.actualizarHorario(horario)) {
                session.setAttribute("mensaje", "Horario actualizado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo actualizar el horario");
            }

            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al actualizar el horario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
        }
    }

    // ========== ELIMINAR HORARIO ==========
    private void eliminarHorario(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        try {
            int idHorario = Integer.parseInt(request.getParameter("id"));
            HorarioProfesional horario = horarioDAO.buscarHorarioPorId(idHorario);

            if (horario == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Horario no encontrado");
                response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
                return;
            }

            // Verificar permisos (profesional solo puede eliminar sus horarios)
            if (usuario.getIdRol() != 1) {
                int idProfesional = obtenerIdProfesional(usuario.getIdUsuario());
                if (horario.getIdProfesional() != idProfesional) {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "No tienes permiso para eliminar este horario");
                    response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
                    return;
                }
            }

            HttpSession session = request.getSession();

            if (horarioDAO.eliminarHorario(idHorario)) {
                session.setAttribute("mensaje", "Horario eliminado exitosamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("error", "No se pudo eliminar el horario");
            }

            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error al eliminar el horario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/HorarioProfesionalServlet");
        }
    }

    // ========== MÉTODOS AUXILIARES ==========
    private int obtenerIdProfesional(int idUsuario) {
        return profesionalDAO.obtenerIdProfesionalPorIdUsuario(idUsuario);
    }
}
