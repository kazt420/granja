<?php 
session_start();
if (isset($_SESSION['loggedin'])) {
  header('Location: administracion.php');
}
 ?>
<html ng-app="app">

<head>
  <meta charset="utf-8">
    <link rel="shortcut icon" href="img/granja1.png" type="image/x-icon">

  <title>Administración</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="css/materialize.min.css">
  <style type="text/css" ></style>
  <style>
    body {
      display: flex;
      min-height: 100vh;
      flex-direction: column;
    }

    main {
      flex: 1 0 auto;
    }

    body {
      background: #c3c3c3;
    }
    textarea:focus + label,
    .input-field input[type=date]:focus + label,
    .input-field input[type=text]:focus + label,
    .input-field input[type=email]:focus + label,
    .input-field input[type=password]:focus + label {
      color: #212121 ;
    }

    textarea:focus + label,
    .input-field input[type=date]:focus,
    .input-field input[type=text]:focus,
    .input-field input[type=email]:focus,
    .input-field input[type=password]:focus {
      border-bottom: 2px solid #212121 ;
      box-shadow: none;
    }
    .section {padding-top: 0.5rem !important; padding-bottom: 0.5rem !important}

  </style>
</head>

<body ng-controller="loginCtrl">
  
  <div class="section"></div>
  <main>
    <center>
      <img class="responsive-img" style="width: 8em;" src="img/granja2.png" />
      <div class="section"></div>

      <h5 class="blue-text">Por favor, ingrese con su cuenta</h5>
      <div class="section"></div>

      <div class="container">
        <div class="z-depth-1 grey lighten-4 row" style="display: inline-block; border: 1px solid #EEE;">
        <div class="progress" style="margin: 0px;" ng-show="state">      <div class=" blue indeterminate" ></div>  </div>

          <form class="col s12" ng-submit="login()" style="padding: 32px 48px 0px 48px">
            <div class='row'>
              <div class='col s12'>
              </div>
            </div>

            <div class='row'>
              <div class='input-field col s12'>
                <input required type='text'  ng-model="user" />
                <label for='username'>Usuario</label>
              </div>
            </div>

            <div class='row'>
              <div class='input-field col s12'>
                <input required type='password'  ng-model="pass"/>
                <label for='password'>Contraseña</label>
              </div>
            </div>

            <br />
            <center>
              <div class='row'>
                <button type='submit'  class='col s12 btn btn-large waves-effect blue'>Entrar</button>
              </div>
            </center>
          </form>
        </div>
      </div>
    </center>
  </main>
  
</body>

</html>