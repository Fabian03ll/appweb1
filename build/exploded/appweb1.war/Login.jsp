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
                <li class="signin-active"><a class="btn">Iniciar sesión</a></li>                
            </ul>
        </div>

        <form class="form-signin" action="LoginServlet" method="POST">
            
            <label for="username">Nombre de usuario</label>
    <input class="form-styling" type="text" name="usuario" placeholder="" required/>
    
    <label for="password">Contraseña</label>
    <input class="form-styling" type="password" name="contrasena" placeholder="" required/>
    
    
    <div class="btn-animate">
        <button type="submit" class="btn-signin" style="cursor: pointer;">Iniciar sesión</button>
    </div>
            
        </form>                        
        

        <div class="welcome">
            <h2>Bienvenido c:</h2>
            <a class="btn-goback">Go back</a>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="login.js"></script>
    <!-- mod -->
    <script>
    const params = new URLSearchParams(window.location.search);
    if (params.get('error') === 'invalid') {
        const msg = document.createElement('p');
        msg.textContent = '';
        msg.textContent = 'Usuario o contraseña incorrectos';
        msg.style.cssText = 'color:#ff4757;font-size:12px;margin-top:8px;';
        document.querySelector('.form-signin').appendChild(msg);
    } else if (params.get('error') === 'db') {
        const msg = document.createElement('p');
        msg.textContent = 'Error de conexión a la base de datos';
        msg.style.cssText = 'color:#ff4757;font-size:12px;margin-top:8px;';
        document.querySelector('.form-signin').appendChild(msg);
    }
    </script>

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
