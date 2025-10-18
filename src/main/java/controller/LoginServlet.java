package controller;

import dao.UsuarioDAO;
import model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario usuario = usuarioDAO.autenticar(email, password);

        if (usuario != null) {
            // Crear sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("rol", usuario.getIdRol());

            // Redirigir según el rol usando SERVLETS (no JSP directo)
            switch (usuario.getIdRol()) {
                case 1: // Administrador
                    response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
                    break;

                case 2: // Especialista Médico
                case 3: // Especialista No Médico
                    response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        } else {
            // Credenciales incorrectas
            request.setAttribute("error", "Email o contraseña incorrectos");
            request.setAttribute("tipoMensaje", "danger");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si alguien accede por GET, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
