package controller;

import dao.HistorialClinicoDAO;
import model.HistorialClinico;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/HistorialClinicoServlet")
public class HistorialClinicoServlet extends HttpServlet {

    private HistorialClinicoDAO historialDAO;

    @Override
    public void init() {
        historialDAO = new HistorialClinicoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                request.getRequestDispatcher("/admin/nuevoHistorial.jsp").forward(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                eliminarHistorial(request, response);
                break;
            default:
                listarHistoriales(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "crear";
        }

        switch (accion) {
            case "crear":
                crearHistorial(request, response);
                break;
            case "actualizar":
                actualizarHistorial(request, response);
                break;
            default:
                listarHistoriales(request, response);
        }
    }

    private void listarHistoriales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
        List<HistorialClinico> historiales = historialDAO.listarHistorialPorPaciente(idPaciente);
        request.setAttribute("historiales", historiales);
        request.getRequestDispatcher("/admin/historiales.jsp").forward(request, response);
    }

    private void crearHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HistorialClinico historial = new HistorialClinico();
        historial.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
        historial.setFechaRegistro(request.getParameter("fechaRegistro"));
        historial.setDescripcion(request.getParameter("descripcion"));

        if (historialDAO.insertarHistorial(historial)) {
            request.getSession().setAttribute("mensaje", "Historial creado exitosamente");
        } else {
            request.getSession().setAttribute("mensaje", "Error al crear historial");
        }
        response.sendRedirect("HistorialClinicoServlet?idPaciente=" + historial.getIdPaciente());
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idHistorial = Integer.parseInt(request.getParameter("id"));
        HistorialClinico historial = historialDAO.buscarHistorialPorId(idHistorial);
        request.setAttribute("historial", historial);
        request.getRequestDispatcher("/admin/editarHistorial.jsp").forward(request, response);
    }

    private void actualizarHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HistorialClinico historial = new HistorialClinico();
        historial.setIdHistorial(Integer.parseInt(request.getParameter("idHistorial")));
        historial.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
        historial.setFechaRegistro(request.getParameter("fechaRegistro"));
        historial.setDescripcion(request.getParameter("descripcion"));

        if (historialDAO.actualizarHistorial(historial)) {
            request.getSession().setAttribute("mensaje", "Historial actualizado exitosamente");
        } else {
            request.getSession().setAttribute("mensaje", "Error al actualizar historial");
        }
        response.sendRedirect("HistorialClinicoServlet?idPaciente=" + historial.getIdPaciente());
    }

    private void eliminarHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idHistorial = Integer.parseInt(request.getParameter("id"));
        int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
        if (historialDAO.eliminarHistorial(idHistorial)) {
            request.getSession().setAttribute("mensaje", "Historial eliminado exitosamente");
        } else {
            request.getSession().setAttribute("mensaje", "Error al eliminar historial");
        }
        response.sendRedirect("HistorialClinicoServlet?idPaciente=" + idPaciente);
    }
}
