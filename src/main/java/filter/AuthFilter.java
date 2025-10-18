package filter;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
@WebFilter({"/admin/*", "/profesional/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        int rol = (int) session.getAttribute("rol");
        if (uri.contains("/admin/") && rol != 1) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/profesional/dashboard.jsp");
            return;
        }
        if (uri.contains("/profesional/") && (rol != 2 && rol != 3)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard.jsp");
            return;
        }
        chain.doFilter(request, response);
    }
}