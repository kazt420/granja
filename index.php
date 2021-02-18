<?php 
session_start();
if (isset($_SESSION['loggedin'])) {
  header('Location: administracion.php');
}
 ?>
<!DOCTYPE html>
<html lang="en" ng-app="app">
<head>
	<title>Administrador de Granja</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================-->	
	<link rel="icon" type="image/png" href="img/granja1.png"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="login/vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="login/vendor/animate/animate.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="login/vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="login/vendor/select2/select2.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="login/css/util.css">
	<link rel="stylesheet" type="text/css" href="login/css/main.css">
	<link rel="stylesheet" type="text/css" href="login/css/toastr.min.css">
<!--===============================================================================================-->
</head>
<body ng-controller="loginCtrl">
	
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<div class="login100-pic js-tilt" data-tilt>
					<img src="img/granja2.png" alt="IMG">
				</div>

				<form class="login100-form validate-form" ng-submit="login()">
					<span class="login100-form-title">
						Inicio de Sesión
					</span>

					<div class="wrap-input100" >
						<input class="input100" type="text" name="email" placeholder="Usuario" ng-model="user">
						<span class="focus-input100"></span>
						<span class="symbol-input100">
							<i class="fa fa-envelope" aria-hidden="true"></i>
						</span>
					</div>

					<div class="wrap-input100">
						<input class="input100" type="password" name="pass" placeholder="Contraseña" ng-model="pass">
						<span class="focus-input100"></span>
						<span class="symbol-input100">
							<i class="fa fa-lock" aria-hidden="true"></i>
						</span>
					</div>
					
					<div class="container-login100-form-btn">
						<button class="login100-form-btn" type="submit">
							Iniciar
						</button>
					</div>

					<div class="text-center p-t-12">
						<!-- <span class="txt1">
							Forgot
						</span>
						<a class="txt2" href="#">
							Username / Password?
						</a> -->
					</div>

					<div class="text-center p-t-136">
						<!-- <a class="txt2" href="#">
							Create your Account
							<i class="fa fa-long-arrow-right m-l-5" aria-hidden="true"></i>
						</a> -->
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script src="js/jquery.js"></script>
  <script src="js/angular.js"></script>
  <script src="js/materialize.min.js"></script>
  <script>
    var app = angular.module('app', []);
    app.controller('loginCtrl', function($scope, $http,$window)
    {
      $scope.login = function ()
      {
        $scope.state = true;
        $http.post('checklogin.php', {"user": $scope.user, "pass": $scope.pass})
        .success(function(data)
        {
        	console.log(data);
          if (data.IdEmpleado)
          { 
            localStorage.setItem('IdEmpleado',data.IdEmpleado);
            localStorage.setItem('Tipo',data.Tipo);
            localStorage.setItem('user', $scope.user);
            $window.location.href = 'administracion.php';
          }
          else{
            $scope.user = ""; 
            $scope.pass = "";
            toastr.warning("Usuario o contraseña incorrectos. Intente de nuevo");
          }
          $scope.state = false;          
        })
        .error(function(data)
        {
          toastr.warning("No se logró establecer la comunicación. Revise su conexión", 5000, 'red');
          $scope.state = false;

        });
      }
    })

  </script>

	
<!--===============================================================================================-->	
	<script src="login/vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="login/vendor/bootstrap/js/popper.js"></script>
	<script src="login/vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="login/vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="login/vendor/tilt/tilt.jquery.min.js"></script>
	<script src="css/materialize.min.js" type="text/javascript"></script>
	<script src="login/js/toastr.min.js" type="text/javascript" ></script>
	<script >
		$('.js-tilt').tilt({
			scale: 1.1
		})
	</script>
<!--===============================================================================================-->
	<script src="login/js/main.js"></script>

</body>
</html>