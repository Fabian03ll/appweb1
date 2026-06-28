<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="Login.css">
</head>
<body>
    <div class="frame">
        <div class="nav">
            <ul class="links">
                <li class="signin-active"><a class="btn">Sign in</a></li>
                <li class="signup-inactive"><a class="btn">Sign up</a></li>
            </ul>
        </div>

        <%-- SIGN IN conectado al servlet --%>
        <form class="form-signin" action="LoginServlet" method="POST">
            <label for="usuario">Username</label>
            <input class="form-styling" type="text" name="usuario" placeholder="" required/>
            
            <label for="contrasena">Password</label>
            <input class="form-styling" type="password" name="contrasena" placeholder="" required/>
            
            <input type="checkbox" id="checkbox"/>
            <label for="checkbox"><span class="ui"></span>Keep me signed in</label>
            
            <div class="btn-animate">
                <button type="submit" class="btn-signin" style="cursor:pointer; border:none; background:none;">Sign in</button>
            </div>
            
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <p style="color:red; font-size:12px; margin-top:8px;">Usuario o contraseña incorrectos</p>
            <% } else if ("db".equals(request.getParameter("error"))) { %>
                <p style="color:red; font-size:12px; margin-top:8px;">Error de conexión a la base de datos</p>
            <% } %>
        </form>

        <%-- SIGN UP conectado al servlet de registro --%>
        <form class="form-signup" action="RegistroServlet" method="POST">
            <label for="fullname">Full name</label>
            <input class="form-styling" type="text" name="fullname" placeholder=""/>
            
            <label for="email">Email</label>
            <input class="form-styling" type="text" name="email" placeholder=""/>
            
            <label for="password">Password</label>
            <input class="form-styling" type="password" name="password" placeholder=""/>
            
            <label for="confirmpassword">Confirm password</label>
            <input class="form-styling" type="password" name="confirmpassword" placeholder=""/>
            
            <button type="submit" class="btn-signup" style="cursor:pointer; border:none; background:none;">Sign Up</button>
        </form>

        <div class="success">
            <svg width="150" height="150" viewBox="0 0 150 150" fill="none" xmlns="http://www.w3.org/2000/svg"></svg>
            <div class="successtext">
                <p>Thanks for signing up! Check your email for confirmation.</p>
            </div>
        </div>
        <div class="forgot">
            <a href="#">Forgot your password?</a>
        </div>
        <div class="welcome">
            <h2>Welcome, <%= session.getAttribute("usuario") %></h2>
            <a class="btn-goback">Go back</a>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="login.js"></script>
</body>
</html>