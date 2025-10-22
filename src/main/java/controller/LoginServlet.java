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
        String rolSeleccionado = request.getParameter("rol");

        // Validación de campos vacíos
        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || rolSeleccionado == null || rolSeleccionado.trim().isEmpty()) {
            request.setAttribute("error", "Por favor, completa todos los campos");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Convertir el rol a entero
            int idRol = Integer.parseInt(rolSeleccionado);
            
            // Autenticar con email, password y rol
            Usuario usuario = usuarioDAO.autenticar(email.trim(), password, idRol);

            if (usuario != null) {
                // Verificar que el usuario esté activo
                if (!usuario.isActivo()) {
                    request.setAttribute("error", "Tu cuenta ha sido desactivada. Contacta al administrador.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }

                // Crear sesión
                HttpSession session = request.getSession();
                session.setMaxInactiveInterval(30 * 60); // 30 minutos
                session.setAttribute("usuario", usuario);
                session.setAttribute("rol", usuario.getIdRol());

                // Mensaje de bienvenida
                session.setAttribute("success", "¡Bienvenido(a), " + usuario.getNombreCompleto() + "!");

                // Redirigir según el rol
                switch (usuario.getIdRol()) {
                    case 1: // Administrador
                        response.sendRedirect(request.getContextPath() + "/DashboardAdminServlet");
                        break;
                    case 2: // Especialista Médico
                        response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                        break;
                    case 3: // Especialista No Médico
                        response.sendRedirect(request.getContextPath() + "/DashboardProfesionalServlet");
                        break;
                    default:
                        // Rol no reconocido
                        session.invalidate();
                        request.setAttribute("error", "Rol de usuario no reconocido. Contacta al administrador.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // Credenciales o rol incorrectos
                request.setAttribute("error", "Email, contraseña o rol incorrectos. Verifica tus datos.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Rol inválido. Por favor, selecciona un rol válido.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar el inicio de sesión. Por favor, intenta nuevamente.");
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