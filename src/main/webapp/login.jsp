<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Time Keeper</title>
    <style>
        /* Add your CSS styles from the original HTML */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d); color: white; min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .login-container { background: rgba(255,255,255,0.1); padding: 2rem; border-radius: 12px; backdrop-filter: blur(10px); box-shadow: 0 8px 16px rgba(0,0,0,0.2); width: 100%; max-width: 400px; }
        h1 { text-align: center; margin-bottom: 1rem; }
        input { width: 100%; padding: 0.75rem; margin: 0.5rem 0; border: none; border-radius: 4px; }
        button { width: 100%; padding: 0.75rem; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; margin: 0.5rem 0; }
        .error { color: #ff5252; background: rgba(255,255,255,0.2); padding: 0.5rem; border-radius: 4px; margin: 0.5rem 0; }
        .links { text-align: center; margin-top: 1rem; }
        .links a { color: white; text-decoration: none; }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Time Keeper</h1>
        <h2>Login</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div style="color: #2ed573; background: rgba(255,255,255,0.2); padding: 0.5rem; border-radius: 4px; margin: 0.5rem 0;">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <form action="auth" method="post">
            <input type="hidden" name="action" value="login">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <div class="links">
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </div>
    </div>
</body>
</html>