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

        <form action="LoginServlet" method="POST" class="form-signin" id="miFormularioLogin">
            <label for="username">Username</label>
            <input class="form-styling" type="text" name="usuario" placeholder=""/>
            
            <label for="password">Password</label>
            <input class="form-styling" type="password" name="contrasena" placeholder=""/>
            
            <input type="checkbox" id="checkbox"/>
            <label for="checkbox"><span class="ui"></span>Keep me signed in</label>
            
            <div class="btn-animate">
                <a class="btn-signin">Sign in</a>
            </div>
        </form>

        <div class="form-signup">
            <label for="fullname">Full name</label>
            <input class="form-styling" type="text" name="fullname" placeholder=""/>
            
            <label for="email">Email</label>
            <input class="form-styling" type="text" name="email" placeholder=""/>
            
            <label for="password">Password</label>
            <input class="form-styling" type="text" name="password" placeholder=""/>
            
            <label for="confirmpassword">Confirm password</label>
            <input class="form-styling" type="text" name="confirmpassword" placeholder=""/>
            
            <a ng-click="checked = !checked" class="btn-signup">Sign Up</a>
        </div>

        <div class="success">
            <svg width="150" height="150" viewBox="0 0 150 150" fill="none" xmlns="http://www.w3.org/2000/svg">
                </svg>
            <div class="successtext">
                <p>Thanks for signing up! Check your email for confirmation.</p>
            </div>
        </div>

        <div class="forgot">
            <a href="#">Forgot your password?</a>
        </div>

        <div class="welcome">
            <h2>Welcome, Chris</h2>
            <a class="btn-goback">Go back</a>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script src="login.js"></script>

</body>
</html>




<!-- <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
 -->
