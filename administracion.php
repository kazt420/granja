<?php 
session_start();
if (!isset($_SESSION['loggedin'])) {
  header('Location: index.php');
}
 ?>
<!DOCTYPE html>
<html ng-app="app">
<head>
	<meta charset="utf-8">
	<meta name="msapplication-tap-highlight" content="no">
	<meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width">
	<link rel="icon" type="image/png" href="img/granja1.png"/>
	<link rel="stylesheet" type="text/css" href="css/materialize.min.css">
	<link  rel="stylesheet" type="text/css" href="css/index.css">
	<link  rel="stylesheet" type="text/css" href="css/dialogBox.css">
	<link  rel="stylesheet" type="text/css" href="css/animate.css">
	<title>Administrador de Granja</title>
</head>
<body ng-controller='mainCtrl as main'>
	<!-- absolute obscure -->
	<div class="fullscreen" ng-show="preloaderShow" ng-cloak></div>



	<div id="editUsuarioModal" class="modal modal-fixed-footer">
		<form class="row" ng-submit="editUsuario()">
			<div class="modal-content" style="padding-bottom: 50px;">
				<span class="modalHeader">Editar Datos del Usuario</span>
				<a href="" class="modal-action modal-close">
					<span class="new badge transparent red-text" data-badge-caption="">
						<i class="material-icons btnTitle">cancel</i>
					</span>
				</a>
				<div class="divider"></div><br>
				<div class="row" style="margin: 0px"><input type="text" class="col s12 " placeholder="Usuario" required ng-model="usuario.user" style="margin:0px;text-transform: none !important;"></div></br>
				<div class="row" style="margin: 0px"><input type="password" class="col s12 " placeholder="Contraseña Actual" required ng-model="usuario.pass" style="margin:0px"></div></br>
				<div class="row" style="margin: 0px"><input type="password" class="col s12 " placeholder="Contraseña Nueva" required ng-model="usuario.newpass" style="margin:0px"></div>
			</div>
			<div class="modal-footer" style="padding-top: 0px;">
				<button class="btn waves-effect waves-red btn-flat modal-action" type="submit">
					Editar<i class="material-icons right">save</i>
				</button>
			</div>
		</form>
	</div>


	<!-- MENU PRINCIPAL-->
	<div class="navbar-fixed" ng-cloak>
		<nav class="grey darken-4">
			<div class="nav-wrapper grey" style="z-index: 5;">
					<a href="#!" class="brand-logo">
						<span style="padding-right: 50px">Administración de Granja</span>
					</a>
				
				<a href="#" data-activates="navMenu" class="button-collapse">
					<i class="material-icons">menu</i>
				</a>
				<ul class="dropDownMenu right" id="dropDownMenu">
					<li style="margin-bottom: -50px; margin-left: 25px">
						<div class="wrap fixed">
							<div class="widget">
								<!-- <div class="fecha">
										<p id="diaSemana" class="diaSemana"></p>
										<p id="dia" class="dia"></p>
										<p>de </p>
										<p id="mes" class="mes"></p>
										<p>del </p>
										<p id="year" class="year"></p>
								</div> -->
								<div class="reloj">
									<p id="horas" class="horas"></p>
									<p>:</p>
									<p id="minutos" class="minutos"></p>
									<p>:</p>
								<div class="caja-segundos">
									<p id="ampm" class="ampm"></p>
									<p id="segundos" class="segundos"></p>
									</div>
								</div>
							</div>
						</div>
					</li>
      				<li>
      					<a class="dropdown-button" data-beloworigin="true" data-constrainwidth="false" data-activates="admin" href="">
      							{{usuario.user}}
      						<i class="material-icons right">
      							arrow_drop_down
      						</i>
      						<i class="material-icons left">
      							account_circle
      						</i>
      					</a>
      					<ul id="admin" class="dropdown-content" >
      						<li>
      							<a onclick="openModal('editUsuarioModal')" ng-click="cleanUsuario()" class="black-text">
      								Editar Usuario
      							</a>
      						</li>
      						<li>
      							<a ng-click="logout()" class="black-text">
      								Salir
      							</a>
      						</li>
      					</ul>
      				</li>

    			</ul>	
			</div>	
			<loading/>
		</nav>
	</div>



	<ul class="side-nav" id="navMenu">
		<!-- <div class="wrap fixed">
			<div class="widget">
					<div class="fecha">
						<p id="diaSemana" class="diaSemana"></p>
						<p id="dia" class="dia"></p>
						<p>de </p>
						<p id="mes" class="mes"></p>
					<p>del </p>
					<p id="year" class="year"></p>
				</div>
		
				<div class="reloj">
					<p id="horas" class="horas"></p>
					<p>:</p>
					<p id="minutos" class="minutos"></p>
					<p>:</p>
					<div class="caja-segundos">
						<p id="ampm" class="ampm"></p>
						<p id="segundos" class="segundos"></p>
					</div>
				</div>
			</div>
		</div>
		<hr> -->
		<br>
		<span ng-hide="usuario.tipo == '0'">INGRESOS</span>
		<div ng-hide="usuario.tipo == '0'" class="divider"></div>
			<li ng-class="checkActive('/alimentos')" ng-hide="usuario.tipo == '0'">
				<a href="#alimentos" class=" waves-effect waves-light">Alimentos</a>
			</li>		
			<li ng-class="checkActive('/galpones')" ng-hide="usuario.tipo == '0'">
				<a href="#galpones" class=" waves-effect waves-light">Galpones</a>
			</li>	
			<li ng-class="checkActive('/gasto')" ng-hide="usuario.tipo == '0'">
				<a href="#gasto" class=" waves-effect waves-light">Gastos</a>
			</li>
			<li ng-class="checkActive('/precios')" ng-hide="usuario.tipo == '0'">
				<a href="#precios" class=" waves-effect waves-light">Precios</a>
			</li>
			<li ng-class="checkActive('/medidas')" ng-hide="usuario.tipo == '0'">
				<a href="#medidas" class=" waves-effect waves-light">Medidas (alimentos)</a>
			</li>	
			<li ng-class="checkActive('/presentacion')" ng-hide="usuario.tipo == '0'">
				<a href="#presentacion" class=" waves-effect waves-light">Presentación (alimentos)</a>
			</li>	
			<li ng-class="checkActive('/vacunas')" ng-hide="usuario.tipo == '0'">
				<a href="#vacunas" class=" waves-effect waves-light">Vacunas</a>
			</li>		

		<br><span ng-hide="usuario.tipo == '0'">PERSONAS</span>
		<div ng-hide="usuario.tipo == '0'" class="divider"></div>
			<li ng-class="checkActive('/clientes')" ng-hide="usuario.tipo == '0'">
				<a href="#clientes" class=" waves-effect waves-light">Clientes</a>
			</li>
			<li ng-class="checkActive('/nomina')" ng-hide="usuario.tipo == '0'">
				<a href="#nomina" class=" waves-effect waves-light">Nómina</a>
			</li>
			<li ng-class="checkActive('/veterinarios')" ng-hide="usuario.tipo == '0'">
				<a href="#veterinarios" class=" waves-effect waves-light">Veterinarios</a>
			</li>
		
		<br><span>PROCESOS</span>
		<div class="divider"></div>
			<li ng-class="checkActive('/alimentacion')" >
				<a href="#alimentacion" class=" waves-effect waves-light">Alimentación</a>
			</li>
			<li ng-class="checkActive('/gastos')" >
				<a href="#gastos" class=" waves-effect waves-light">Gastos</a>
			</li>
			<li ng-class="checkActive('/registrogalpones')" >
				<a href="#registrogalpones" class=" waves-effect waves-light">Lotes</a>
			</li>
			<li ng-class="checkActive('/mortalidad')" >
				<a href="#mortalidad" class=" waves-effect waves-light">Mortalidad</a>
			</li>
			<li ng-class="checkActive('/ventas')" >
				<a href="#ventas" class=" waves-effect waves-light">Ventas</a>
			</li>
			<li ng-class="checkActive('/registroveterinario')" >
				<a href="#registroveterinario" class=" waves-effect waves-light">Veterinaria</a>
			</li>		
	</ul>

<div class="container">
 <div ng-view></div>
</div>
	<script src="js/moment.min.js"></script>
	<script src="js/chart.min.js"></script>
	<script src="js/jquery.js"></script>
	<script src="js/materialize.min.js"></script>
	<script src="js/angular.js"></script>
	<script src="js/angular-route.js"></script>
	<script src="js/index.js"></script>
	<script src="js/ngstorage.js"></script>
	<script src="js/dirPagination.js"></script>
	<script src="js/ngGeolocation.js"></script>
	<script src="js/angular-sham-spinner.js"></script>
	<script src="js/pdfmake.min.js"></script>
	<script src="js/vfs_fonts.js"></script>
	<script src="main.js"></script>
</body>
</html>
