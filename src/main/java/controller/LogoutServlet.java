package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener nombre del usuario antes de invalidar la sesión
        String nombreUsuario = null;
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Obtener información del usuario si existe
            Object usuario = session.getAttribute("usuario");
            if (usuario != null && usuario instanceof model.Usuario) {
                nombreUsuario = ((model.Usuario) usuario).getNombreCompleto();
            }
            
            // Invalidar sesión
            session.invalidate();
        }
        
        // Crear nueva sesión temporal para el mensaje
        HttpSession newSession = request.getSession(true);
        
        // Mensaje de despedida personalizado si se obtuvo el nombre
        if (nombreUsuario != null && !nombreUsuario.isEmpty()) {
            newSession.setAttribute("success", "¡Hasta pronto, " + nombreUsuario + "! Sesión cerrada correctamente.");
        } else {
            newSession.setAttribute("success", "Sesión cerrada correctamente");
        }
        
        // Redirigir al login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
