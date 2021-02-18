var ruteo = angular.module('app', [ 'ngStorage', 'angularUtils.directives.dirPagination', 'ngGeolocation', 'ngRoute', 'angularShamSpinner']);

ruteo.config(function($routeProvider) {

	$routeProvider
	.when('/', {templateUrl : 'home.html'})
	.when('/registrogalpones', {templateUrl : 'registrogalpones.html' , controller: 'registrogalponesCtrl'})
	.when('/nomina', {templateUrl : 'nomina.html' , controller: 'nominaCtrl'})
	.when('/clientes', {templateUrl : 'clientes.html' , controller: 'clientesCtrl'})
	.when('/mortalidad', {templateUrl : 'mortalidad.html', controller: 'mortalidadCtrl'})
	.when('/gastos', {templateUrl : 'gastos.html', controller : 'gastosCtrl'})
	.when('/gasto', {templateUrl : 'gasto.html', controller : 'gastoCtrl'})
	.when('/ventas', {templateUrl : 'ventas.html', controller: 'ventasCtrl'})
	.when('/galpones', {templateUrl : 'galpones.html', controller: 'galponesCtrl'})
	.when('/registrototal', {templateUrl : 'registrototal.html', controller: 'registrototalCtrl'})
	.when('/registroveterinario', {templateUrl : 'registroveterinario.html', controller: 'registroveterinarioCtrl'})
	.when('/veterinarios', {templateUrl : 'veterinarios.html', controller: 'veterinariosCtrl'})
	.when('/vacunas', {templateUrl : 'vacunas.html', controller: 'vacunasCtrl'})
	.when('/presentacion', {templateUrl : 'presentacion.html', controller: 'presentacionCtrl'})
	.when('/medidas', {templateUrl : 'medidas.html', controller: 'medidasCtrl'})
	.when('/precios', {templateUrl : 'precios.html', controller: 'preciosCtrl'})
	.when('/alimentos', {templateUrl : 'alimentos.html', controller: 'alimentosCtrl'})
	.when('/alimentacion', {templateUrl : 'alimentacion.html', controller: 'alimentacionCtrl'})
	.otherwise({redirectTo: '/'});
});


ruteo.directive('loading', ['$http', function ($http) 
{
	var html = '<div class="progress transparent" style="margin-top: 0px;" ng-cloak><div class="indeterminate red"></div></div>';
	return {
		restrict: 'E',
		replace: true,
		template: html,
		link: function (scope, element, attrs) 
		{      
			scope.isLoading = function () {return $http.pendingRequests.length > 0;};       
			scope.$watch(scope.isLoading, function (value) {value ? element.removeClass('ng-hide') : element.addClass('ng-hide')});
		}
	};
}]);


ruteo.factory('dataShare', function() 
{
	var data = {
		toggleAll : function(json, model){var toggleStatus = model.value;angular.forEach(json, function(itm){ itm.state = toggleStatus})}	,  
		optionToggled : function(json, model){model.value = json.every(function(itm){ return itm.state})},
		valida_cedula : cedula => {
			cedula =  cedula.trim();
	        var total = 0;
	        var longitud = cedula.length;
	        var longcheck = longitud - 1;

	        if (cedula !== "" && longitud === 10){
		      for(var i = 0; i < longcheck; i++){
		        if (i%2 === 0) {
		          var aux = cedula.charAt(i) * 2;
		          if (aux > 9) aux -= 9;
		          total += aux;
		        } else {
		          total += parseInt(cedula.charAt(i));
		        }
		      }

	          total = total % 10 ? 10 - total % 10 : 0;

	          if (cedula.charAt(longitud-1) == total) {
	          	console.log(true)
	            return true
	          }else{
	          	toast('La cédula ingresada es inválida', 'orange')
	            return false
	          }
	        }
	        else{
	        	toast('La cédula ingresada es inválida', 'orange')
	        	return false
	        }
		}
	}
	return data;	
});

ruteo.controller('mainCtrl', function($scope, $http, dataShare)  
{
	$scope.toggleAll = dataShare.toggleAll;
	$scope.optionToggled = dataShare.optionToggled;
	$scope.isAllSelected = {'value':false};
	$scope.edit = {'state': false };
	// $scope.auxPresentacion = {};
	$scope.usuario = {tipo: localStorage.getItem('Tipo'), user :localStorage.getItem('user'), idempleado :parseInt(localStorage.getItem('IdEmpleado'))};
	//$scope.user = localStorage.getItem('user')

	moment.locale('es')
	//pdfMake.vfs = pdfFonts.pdfMake.vfs;

	$scope.cleanUsuario = function(){
		$scope.usuario.pass="";
		$scope.usuario.newpass="";
	}

	$scope.editUsuario = function ()
	{
		
		closeModal("editUsuarioModal");
		$http.post('php/put/index.php?op=editUsuario', $scope.usuario)
		.then(function(data)
		{	
			if(data.data['success']==false)
			{
				toast("Datos incorrectos");
				setTimeout(function(){openModal("editUsuarioModal")},500);
			}
			else
			{
				toast("Registro modificado exitosamente!");	
				$scope.cleanUsuario();
			}
			
		})
		.catch(function(data)
		{
			setTimeout(function(){openModal("editUsuarioModal")},500);
			toast("Se ha producido un error al modificar el registro. Inténtelo nuevamente");

		});
	};


	$scope.desactiveJson = function(json)
	{
		for (var i = 0; i < json.length; i++) 
			if(json[i].state) json[i].state = false;
	}

	$scope.add = function(origen, destino, campo)
	{
		if (typeof destino !== 'undefined' && typeof campo !== 'undefined' )
		{
			destino[campo] = [];
			for (var i = 0; i < origen.length; i++) 
				if (origen[i].state) {destino[campo].push(origen[i])}
			}
		else if (typeof destino !== 'undefined' && typeof campo == 'undefined' )
		{
			$scope.edit.state  ? destino[$scope.edit.index] = origen : destino.push(origen);	

		}		
	}

	getItem = function(json, item, id, idE)
	{
		for (var i = 0; i < json.length; i++) 
		{
			if (json[i][id] == idE) 
			{
				return json[i][item];
			}
		}
		return false;
	}

	getIndex = function(json, id, idE)
	{
		for (var i = 0; i < json.length; i++) 
		{
			if (json[i][id] == idE) 
			{
				return i;
			}
		}
	}	

	$scope.logout = function ()
	{
		$http.post('php/logout.php')
		.success(function(data)
		{
			window.location.href = 'index.php';
		})
		.error(function(data)
		{
			Materialize.toast("No se logró establecer la comunicación. Revise su conexión", 5000, 'red');
		});
	}
});

ruteo.controller('mortalidadCtrl', function($scope, $http)
{
	$scope.tipo = [{"nombre": "ALTAS", "id": 1}, {"nombre":"BAJAS" , "id": 0}];	
	$scope.filtro = {"IdRG": {"lote":0}};
	$scope.refreshMortalidad = function()
	{
		$http.get("php/get/index.php?op=listaMortalidad")
		.success(function(data)
		{
			console.log(data);
			$scope.listaMortalidad = data;
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });
		});

		$http.get("php/get/index.php?op=lotesproduccion")
		.success(function(data)
		{
			console.log(data);
			$scope.lotesproduccion = data;
		});
	}


	$scope.cleanMortalidad = function ()
	{
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.mortalidad = {"fecha": moment().format("YYYY-MM-DD HH:mm:ss"),"cantidad": "", "IdRG": {"lote":""}, "tipo": "","Comentario":"","IdEmpleado": parseInt(IdEmpleado)};
		
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth(); 
		var yyyy = today.getFullYear();
		var diaSemana = today.getDay();
		
		pDiaSemana = document.getElementById('diaSemana'),
        pDia = document.getElementById('dia'),
        pMes = document.getElementById('mes'),
        pYear = document.getElementById('year');

		// Obtenemos el dia se la semana y lo mostramos
        var semana = ['DOMINGO', 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'];
        pDiaSemana.textContent = semana[diaSemana];

        // Obtenemos el dia del mes
        pDia.textContent = dd;

        // Obtenemos el Mes y año y lo mostramos
        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE']
        pMes.textContent = meses[mm];
        pYear.textContent = yyyy;
	}

	$scope.refreshMortalidad();
	$scope.cleanMortalidad();
	$scope.$watch("tarea.f_ini", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("tarea.f_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});	

	$scope.selectEditMortalidad = function (event)
	{
		var id = event.currentTarget.id;
		$scope.mortalidad.id = id;
		// console.log(id);
		$scope.mortalidad.fecha = new Date (getItem($scope.listaMortalidad, 'Fecha', 'IdMort', id));
		$scope.mortalidad.cantidad = parseInt(getItem($scope.listaMortalidad, 'Cantidad', 'IdMort', id));
		$scope.mortalidad.IdRG = $scope.filtro.IdRG.lote;
		// console.log(getItem($scope.listaMortalidad, 'Tipo', 'IdMort', id));
		$scope.mortalidad.tipo = getItem($scope.listaMortalidad, 'Tipo_n', 'IdMort', id) == "1" ? {"nombre": "ALTAS", "id": 1} :  {"nombre": "BAJAS", "id": 0};	
		$scope.mortalidad.empleado = getItem($scope.listaMortalidad, 'Apellidos', 'IdMort', id) + " " + getItem($scope.listaMortalidad, 'Nombres', 'IdMort', id);
		$scope.mortalidad.comentario = getItem($scope.listaMortalidad, 'Comentario', 'IdMort', id);	
		$scope.mortalidad.observacion = getItem($scope.listaMortalidad, 'Observacion', 'IdMort', id);	
	}

	$scope.newMortalidad = function ()
	{	
		$scope.mortalidad.IdRG.lote = $scope.filtro.IdRG.lote;
		closeModal("newMortalidadModal");
		$http.post('php/put/index.php?op=newMortalidad', $scope.mortalidad)
		.success(function(data)
		{
			$scope.refreshMortalidad();
			$scope.cleanMortalidad();
			toast("Mortalidad agregada exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newMortalidadModal")},500);
			toast("Se ha producido un error al guardar la tarea. Inténtelo nuevamente");
		});
	};

	$scope.editMortalidad = function ()
	{
		closeModal("editMortalidadModal");
		$http.post('php/put/index.php?op=editMortalidad', $scope.mortalidad)
		.success(function(data)
		{
			$scope.refreshMortalidad();
			$scope.cleanMortalidad();
			toast("Registro modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newMortalidadModal")},500);
			toast("Se ha producido un error al modificar el registro. Inténtelo nuevamente");
		});
	};

	$scope.deleteMortalidad = function ()
	{ 
		closeModal("editMortalidadModal");
		$http.post('php/del/index.php?op=mortalidad', $scope.mortalidad)
		.success(function(data)
		{
			$scope.refreshMortalidad();
			$scope.cleanMortalidad();
			toast("Registro eliminado exitosamente!");

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editMortalidadModal")},500);
			toast("Se ha producido un error al eliminar el registro Inténtelo nuevamente");
		});
	};

}); 

ruteo.controller('gastosCtrl', function($scope, $http)
{
	$scope.filtro = {"IdRG": {"lote":0}};
	$scope.refreshGastos = function()
	{
		$http.get("php/get/index.php?op=listaGastos")
		.success(function(data)
		{
			$scope.listaGastos = data;
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });

		});
		$http.get("php/get/index.php?op=gastos")
		.success(function(data)
		{
			$scope.gastos = data;
		});	
		$http.get("php/get/index.php?op=lotesproduccion")
		.success(function(data)
		{
			$scope.lotesproduccion = data;	
		});
		$http.get("php/get/index.php?op=producto")
		.success(function(data)
		{
			console.log(data);
			$scope.productos = data;	
		});
		
	}

	$scope.cleanGastos = function ()
	{
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.gasto = {"IdRegGast": "", 
						"IdRG": {"lote":""}, 
						"Nombre": {"IdGasto":"","Nombre":""}, 
						"Fecha": moment().format("YYYY-MM-DD HH:mm:ss"), 
						"Precio": "",
						"IdEmpleado":parseInt(IdEmpleado)
					};

		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth(); 
		var yyyy = today.getFullYear();
		var diaSemana = today.getDay();
		
		pDiaSemana = document.getElementById('diaSemana'),
        pDia = document.getElementById('dia'),
        pMes = document.getElementById('mes'),
        pYear = document.getElementById('year');

		// Obtenemos el dia se la semana y lo mostramos
        var semana = ['DOMINGO', 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'];
        pDiaSemana.textContent = semana[diaSemana];

        // Obtenemos el dia del mes
        pDia.textContent = dd;

        // Obtenemos el Mes y año y lo mostramos
        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE']
        pMes.textContent = meses[mm];
        pYear.textContent = yyyy;
	}

	$scope.refreshGastos();
	$scope.cleanGastos();
	$scope.$watch("tarea.f_ini", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("tarea.f_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});	

	
	$scope.newGasto = function ()
	{
		closeModal("newGastoModal");
		$scope.gasto.IdRG.lote=$scope.filtro.IdRG.lote;
		$http.post('php/put/index.php?op=newGasto', $scope.gasto)
		.success(function(data)
		{
			$scope.refreshGastos();
			$scope.cleanGastos();
			toast("Registro de gasto agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};

	$scope.selectEditGasto = function (event)
	{
		var id = event.currentTarget.id;
		// console.log(id);
		$scope.gasto.IdRegGast = id;
		$scope.gasto.Fecha = new Date (getItem($scope.listaGastos, 'Fecha', 'IdRegGast', id));
		$scope.gasto.Precio = getItem($scope.listaGastos, 'Precio', 'IdRegGast', id);
		$scope.gasto.Nombre = {"IdGasto": getItem($scope.listaGastos, 'IdGasto', 'IdRegGast', id),"Nombre":getItem($scope.listaGastos, 'Nombre', 'IdRegGast', id)};
		$scope.gasto.IdRG.lote = $scope.filtro.IdRG.lote;
		$scope.gasto.empleado = getItem($scope.listaGastos, 'Apellidos', 'IdRegGast', id) + " " + getItem($scope.listaGastos, 'Nombres', 'IdRegGast', id);
		$scope.gasto.idproducto = getItem($scope.listaGastos, 'IdAlimento', 'IdRegGast', id); 
		$scope.gasto.cantidad = getItem($scope.listaGastos, 'Cantidad', 'IdRegGast', id);
		$scope.gasto.producto = {"descripcion":getItem($scope.productos, 'descripcion', 'idproducto', ($scope.gasto.idproducto)),
								 "presentacion":getItem($scope.productos, 'presentacion', 'idproducto', ($scope.gasto.idproducto)),
								 "abreviatura":getItem($scope.productos, 'abreviatura', 'idproducto', ($scope.gasto.idproducto)),
								 "peso":getItem($scope.productos, 'peso', 'idproducto', ($scope.gasto.idproducto)),
								 "precio":getItem($scope.productos, 'preciounitario', 'idproducto', ($scope.gasto.idproducto))
								}; 
		$scope.gasto.total = ($scope.gasto.cantidad * $scope.gasto.producto.precio).toFixed(2);
		// $scope.mortalidad.tipo = getItem($scope.listaMortalidad, 'Tipo_n', 'IdMort', id) == "ALTAS" ? {"nombre": "ALTAS", "id": 1} :  {"nombre": "BAJAS", "id": 0};	
	};

	

	$scope.editGasto = function ()
	{
		closeModal("editGastoModal");
		$http.post('php/put/index.php?op=editGasto', $scope.gasto)
		.success(function(data)
		{
			
			toast("Gasto modificado exitosamente!");	
			$scope.refreshGastos();
			$scope.cleanGastos();
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editGastoModal")},500);
			toast("Se ha producido un error al modificar el registro. Inténtelo nuevamente");
		});
	};

	$scope.deleteGasto = function ()
	{ 
		closeModal("editGastoModal");
		$http.post('php/del/index.php?op=gasto', $scope.gasto)
		.success(function(data)
		{
			$scope.refreshGastos();
			$scope.cleanGastos();
			toast("Registro eliminado exitosamente!");

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editGastoModal")},500);
			toast("Se ha producido un error al eliminar el registro Inténtelo nuevamente");
		});
	};

	
});

ruteo.controller('gastoCtrl', function($scope, $http)
{
	$scope.refreshGasto = function()
	{
		$http.get("php/get/index.php?op=gastos")
		.success(function(data)
		{
			console.log(data);
			$scope.gastos = data;
		});	
	}

	$scope.cleanGasto = function ()
	{
		$scope.gasto = {"Nombre": ""};
	}

	$scope.refreshGasto();
	$scope.cleanGasto();
	// $scope.$watch("tarea.f_ini", function()
	// {
	// 	$('button.btn-flat.picker__close').click();
	// });	
	// $scope.$watch("tarea.f_fin", function()
	// {
	// 	$('button.btn-flat.picker__close').click();
	// });	

	$scope.nuevoGasto = function ()
	{
		closeModal("newGastoModal");
		$http.post('php/put/index.php?op=nuevoGasto', $scope.gasto)
		.success(function(data)
		{
			$scope.refreshGasto();
			toast("Gasto agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};


	$scope.selectEditGasto = function (event)
	{
		var id = event.currentTarget.id;
		console.log(id);
		$scope.gasto.id = id;
		$scope.gasto.Nombre = getItem($scope.gastos, 'Nombre', 'IdGasto', id);
	}

	

	$scope.editGasto = function ()
	{
		closeModal("editGastoModal");
		$http.post('php/put/index.php?op=editarGasto', $scope.gasto)
		.success(function(data)
		{
			$scope.refreshGasto();
			$scope.cleanGasto();
			toast("Gasto modificada exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editGastoModal")},500);
			toast("Se ha producido un error al modificar el gasto. Inténtelo nuevamente");
		});
	};

	$scope.deleteGasto = function ()
	{ 
		closeModal("editGastoModal");
		$http.post('php/del/index.php?op=datogasto', $scope.gasto.id)
		.success(function(data)
		{
			$scope.refreshGasto();
			$scope.cleanGasto();
			toast("Registro eliminado exitosamente!");

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editGastoModal")},500);
			toast("Se ha producido un error al eliminar el registro Inténtelo nuevamente");
		});
	};

	
});

ruteo.controller('ventasCtrl', function($scope, $http, dataShare)
{
	$scope.valida_cedula = dataShare.valida_cedula;
	$scope.venta = {};
	$scope.detalle = {"tipo":'',"idrg":{"lote":""},"cantidad":""};
	$scope.listdet = [];
	$scope.filtro = {"IdRG": {"lote":0}};

	$scope.$watch('detalle', (n,o) => {
		if (n ===o) return;

		if (parseInt(n.cantidad) > parseInt($scope.detalle.idrg.cantidad))
			n.cantidad = parseInt($scope.detalle.idrg.cantidad)
	}, true)
	$scope.refreshVentas = function()
	{
		
		$http.get("php/get/index.php?op=listaVentas")
		.success(function(data)
		{
			console.log(data);
			$scope.listaVentas = data;
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });
		});
		$http.get("php/get/index.php?op=lotesproduccion")
		.success(function(data)
		{
			console.log(data);
			$scope.lotesproduccion = data;	
		});
		$http.get("php/get/index.php?op=getClientes")
		.success(function(data)
		{
			console.log(data);
			$scope.clientes = data;	
		});
		$http.get("php/get/index.php?op=detalles")
		.success(function(data)
		{
			console.log(data);
			$scope.detalles = data;	
		});
		$http.get("php/get/index.php?op=precios")
		.success(function(data)
		{
			console.log(data);
			$scope.precios = data;	
		});
	}


	$scope.getCliente = function ()
	{	
		$scope.venta.cliente = getItem($scope.clientes, 'apellidos', 'ci', parseInt($scope.venta.ci)) + " " + getItem($scope.clientes, 'nombres', 'ci', parseInt($scope.venta.ci));
		$scope.venta.idcliente= getItem($scope.clientes, 'idcliente', 'ci', parseInt($scope.venta.ci));
		
		if(typeof $scope.venta.ci === 'undefined' || $scope.venta.ci == ""){
			toast('Ingrese cédula', 'orange');
		}else{
			if(dataShare.valida_cedula($scope.venta.ci.toString())!=false){
				if ($scope.venta.idcliente === false ) {
					var isConfirmed = confirm("Cliente no registrado ¿Desea agregarlo?");
      				if(isConfirmed){
      					$scope.cliente = {"ci": ""};
      					$scope.cliente.ci = $scope.venta.ci;
        				openModal("newClienteModal");
      				}		
				}
			}
		}
		
	}

	$scope.addDetalle = function()
	{
		if ($scope.detalle.cantidad == ""){
			toast('Ingrese datos', 'orange');
			return;
		}
		$scope.listdet.push({
			preciou: $scope.detalle.tipo ? parseFloat(getItem($scope.precios, 'valor', 'nombre', "FAENADO")) :  parseFloat(getItem($scope.precios, 'valor', 'nombre', "PIE")), 
			tipo: $scope.detalle.tipo ? "FAENADO" : "PIE", 
			lote: $scope.detalle.idrg.lote,
			cantidad: $scope.detalle.cantidad,
			preciot: $scope.detalle.cantidad * ($scope.detalle.tipo ? parseFloat(getItem($scope.precios, 'valor', 'nombre', "FAENADO")) :  parseFloat(getItem($scope.precios, 'valor', 'nombre', "PIE")))
		});
		$scope.detalle = {"tipo":'',"idrg":{"lote":""},"cantidad":""};
		var suma = 0;
		for(var i = 0; i < $scope.listdet.length; i++){
			suma = suma + $scope.listdet[i]["preciot"];
		}
		$scope.venta.preciob = suma.toFixed(2);
		var x = suma.toFixed(2) * parseFloat(getItem($scope.precios, 'valor', 'nombre', "IVA")) / 100;
		$scope.venta.iva = x.toFixed(2);
		var t = parseFloat($scope.venta.preciob) + parseFloat($scope.venta.iva); 
		$scope.venta.preciot = t.toFixed(2);
	}

	$scope.cleanVentas = function ()
	{
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth(); 
		var yyyy = today.getFullYear();
		if(dd<10) {    dd = '0'+dd};
		if(mm<10) {    mm = '0'+mm};
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.venta = {"idventa": "", "idcliente":"", "ci":0, "cliente":"", 
						"fecha": moment().format("YYYY-MM-DD HH:mm:ss"), 
						"iva": "","idempleado": parseInt(IdEmpleado)};
		$scope.listdet = [];
	
		var diaSemana = today.getDay();
		
		pDiaSemana = document.getElementById('diaSemana'),
        pDia = document.getElementById('dia'),
        pMes = document.getElementById('mes'),
        pYear = document.getElementById('year');

		// Obtenemos el dia se la semana y lo mostramos
        var semana = ['DOMINGO', 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'];
        pDiaSemana.textContent = semana[diaSemana];

        // Obtenemos el dia del mes
        pDia.textContent = dd;

        // Obtenemos el Mes y año y lo mostramos
        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE']
        pMes.textContent = meses[mm];
        pYear.textContent = yyyy;
	}

	$scope.refreshVentas();
	$scope.cleanVentas();
	$scope.$watch("venta.fecha", function()
	{
		$('button.btn-flat.picker__close').click();
	});	

	$scope.newCliente = function ()
	{
		if (!dataShare.valida_cedula($scope.cliente.ci)){
			return;
		}
		$scope.cliente.ci = string($scope.cliente.ci);
		$scope.cliente.telefono = string($scope.cliente.telefono);
		closeModal("newClienteModal");
		$http.post('php/put/index.php?op=newCliente', $scope.cliente)
		.success(function(data)
		{
			$scope.refreshVentas();
			toast("Cliente agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
		$scope.cliente = { "ruc": "", "apellidos": "", "nombres": "", "ci": "", "telefono": "", "correo":"", "direccion": ""};
	};
	
	$scope.newVenta = function ()
	{
		$scope.venta.valoriva = parseFloat(getItem($scope.precios, 'valor', 'nombre', "IVA"))
		closeModal("newVentaModal");
		$http.post('php/put/index.php?op=newVenta', {cabecera: $scope.venta, cuerpo: $scope.listdet})
		.success(function(data)
		{
			$scope.refreshVentas();
			$scope.cleanVentas();
			toast("Registro de venta agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};

	$scope.selectEditVenta = function (event)
	{
		var id = event.currentTarget.id;
		console.log(id);
		$scope.venta.idventa = id;
		$scope.venta.fecha = new Date (getItem($scope.listaVentas, 'fecha', 'idfactura', id));
		$scope.venta.idcliente = parseInt(getItem($scope.listaVentas, 'idcliente', 'idfactura', id));
		$scope.venta.ci = parseInt(getItem($scope.listaVentas, 'ci', 'idfactura', id));
		$scope.venta.cliente = getItem($scope.listaVentas, 'cliente', 'idfactura', id);
		$scope.venta.iva = parseInt(getItem($scope.listaVentas, 'iva', 'idfactura', id));
		$scope.venta.idempleado = parseInt(getItem($scope.listaVentas, 'idempleado', 'idfactura', id));
		$scope.venta.empleado = parseInt(getItem($scope.listaVentas, 'empleado', 'idfactura', id));
		$scope.venta.iva = parseFloat(getItem($scope.listaVentas, 'valor', 'idfactura', id)) * parseFloat(getItem($scope.listaVentas, 'iva', 'idfactura', id)) / 100;
		$scope.venta.preciob = parseFloat(getItem($scope.listaVentas, 'valor', 'idfactura', id));
		$scope.venta.preciot = $scope.venta.preciob + $scope.venta.iva;
	};

	$scope.print = () =>{

        var productos = [];
        $scope.detalles.forEach(i => {
            productos.push([{
                text: i.iddetalle,
            }, {
                text: i.idrg + i.ntipo,
            }, {
                text: i.cantidad,
                style: 'right'
            }, {
                text: i.precio,
                style: 'right'
            }, {
                text: (parseFloat(i.precio) * parseFloat(i.cantidad)).toFixed(2),
                style: 'right'
            }]);
            
        });
        var dd = {
            page: 'A4',
            pageMargins: [28, 28, 28, 539],
            styles: {
                empresa: {
                    fontSize: 12,
                    bold: true,
                    alignment: 'center'
                },
                headerTitle: {
                    fontSize: 8,
                    bold: true,
                    alignment: 'right'
                },
                headerSubtitle: {
                    fontSize: 8,
                },
                headerRow: {
                    fontSize: 8,
                    bold: true,
                    alignment: 'center'
                },
                right: {
                    alignment: 'right'
                }
            },
            defaultStyle: {
                fontSize: 8,
            },
            content: [{
                layout: 'noBorders',
                table: {
                    widths: ['10%', '45%', '*', '*'],
                    body: [
                        [{
                            text: 'AVÍCOLA LAURITA',
                            style: 'empresa',
                            rowSpan: 2,
                            colSpan: 2
                        }, {}, {
                            text: 'RUC: ',
                            style: 'headerTitle'
                        }, {
                            text: '1313347765001',
                            style: 'headerSubtitle'
                        }],
                        [{}, {}, {
                            text: 'Factura #: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.idventa,
                            style: 'headerSubtitle'
                        }],
                        [{
                            text: 'Dir. Matriz: ',
                            style: 'headerTitle',
                        }, {
                            text: 'CDLA. VICENTE VELIZ',
                            style: 'headerSubtitle'
                        }, {
                            text: 'Teléfono:',
                            style: 'headerTitle'
                        }, {
                            text: '0999999999999',
                            style: 'headerSubtitle'
                        }]
                    ]
                }
            }, {
                layout: {
                    hLineWidth: (i, node) => {
                        if (i === 0 || i === node.table.body.length) return 1;
                        return 0;
                    },
                    vLineWidth: (i, node) => {
                        if (i === 0 || i === node.table.body[0].length) return 1;
                        return 0;
                    },
                },
                table: {
                    widths: ['*', '*', '*', '*', '*', '*'],
                    body: [
                        [{
                            text: 'Nombre: ',
                            style: 'headerTitle',
                        }, {
                            text: $scope.venta.cliente,
                            style: 'headerSubtitle',
                            colSpan: 3
                        }, {}, {}, {
                            text: 'Vendedor: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.empleado,
                            style: 'headerSubtitle'
                        }],
                        [{
                            text: 'Cédula/RUC: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.ci,
                            style: 'headerSubtitle'
                        }, {
                            text: 'Teléfono: ',
                            style: 'headerTitle'
                        }, {
                            text: '099999999999',
                            style: 'headerSubtitle'
                        }, {
                            text: 'Fecha Emisión: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.fecha,
                            style: 'headerSubtitle'
                        }],
                        [{
                            text: 'Dirección: ',
                            style: 'headerTitle',
                        }, {
                            text: 'PORTOVIEJO',
                            style: 'headerSubtitle'
                        }, {
                            text: 'Forma Pago:',
                            style: 'headerTitle'
                        }, {
                            text: 'EFECTIVO',
                            style: 'headerSubtitle'
                        }, {
                            text: 'Fecha Impresion: ',
                            style: 'headerTitle'
                        }, {
                            text: moment().format('DD/MM/YYYY'),
                            style: 'headerSubtitle'
                        }]
                    ]
                },
            }, {
                layout: {
                    hLineWidth: (i, node) => {
                        if (i === 0) return 0;
                        return 1
                    },
                    vLineWidth: (i, node) => 1,
                },
                table: {
                    widths: ['10%', '45%', '15%', '15%', '15%'],
                    headerRows: 1,
                    body: [
                        [{
                            text: 'CÓDIGO: ',
                            style: 'headerRow',
                        }, {
                            text: 'DESCRIPCIÓN',
                            style: 'headerRow',
                        }, {
                            text: 'CANT.',
                            style: 'headerRow'
                        }, {
                            text: 'PRECIO UNIT.',
                            style: 'headerRow'
                        }, {
                            text: 'SUBTOTAL',
                            style: 'headerRow'
                        }],
                    ]
                },
            }, {
                layout: 'noBorders',
                table: {
                    widths: ['10%', '45%', '15%', '15%', '15%'],
                    body: productos
                },
            }],
            footer: {
                margin: [28, 0, 28, 0],
                layout: {
                    hLineWidth: (i, node) => {
                        if (i === 0 || i === node.table.widths.length) return 1;
                        return 0
                    },
                    vLineWidth: (i, node) => {
                        if (i === 0 || i === node.table.body.length) return 1;
                        return 0
                    },
                },
                table: {
                    widths: ['65%', '20%', '15%'],
                    body: [
                        [{
                            text: 'DETALLES',
                            style: 'headerRow'
                        }, {
                            text: 'PRECIO BRUTO: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.preciob,
                            style: 'right'
                        }],
                        [{
                            text: 'Este documento no tiene validez tributaria',
                            rowSpan: 2
                        }, {
                            text: 'IVA: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.iva,
                            style: 'right'
                        }],
                        [{}, {
                            text: 'TOTAL: ',
                            style: 'headerTitle'
                        }, {
                            text: $scope.venta.preciot,
                            style: 'right'
                        }]                   
                    ]
                }
            }
        };
        pdfMake.createPdf(dd).print();
	}

	$scope.deleteVenta = function ()
	{ 
		closeModal("editVentaModal");
		$http.post('php/del/index.php?op=venta', $scope.venta)
		.success(function(data)
		{
			$scope.refreshVentas();
			$scope.cleanVentas();
			toast("Registro eliminado exitosamente!");

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editVentaModal")},500);
			toast("Se ha producido un error al eliminar el registro Inténtelo nuevamente");
		});
	};
	
});

ruteo.controller('galponesCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.galpon = {};
	$scope.refreshGalpones = function()
	{
		$http.get("php/get/index.php?op=Galpones")
		.success(function(data)
		{
			console.log(data);
			$scope.galpones = data;	
		});
	}

	$scope.refreshGalpones();

	$scope.cleanGalpon = function()
	{
		$scope.galpon = {"IdGalpon": "", "capacidad":""};
	}


	$scope.selectEditContratista = function (event)
	{
		var id = event.currentTarget.id;
		$scope.galpon.IdGalpon = id;
		$scope.galpon.capacidad = getItem($scope.galpones, 'Capacidad', 'IdGalpon', id);
	}

	$scope.newGalpon = function ()
	{
		closeModal("newGalponModal");
		$http.post('php/put/index.php?op=newGalpon', $scope.galpon)
		.success(function(data)
		{
			$scope.refreshGalpones();
			$scope.cleanGalpon();
			toast("Galpón agregado exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newGalponModal")},500);
			toast("Se ha producido un error al guardar el galpón. Inténtelo nuevamente");
		});
	};

	// $scope.editContratista = function ()
	// {
	// 	console.log("hola");
	// 	closeModal("editContratistaModal");
	// 	$http.post('php/put/index.php?op=editContratista', $scope.contratista)
	// 	.success(function(data)
	// 	{
	// 		$scope.refreshGalpones();
	// 		$scope.cleanContratista();
	// 		toast("Contratista modificado exitosamente!");	
	// 	})
	// 	.error(function(data)
	// 	{
	// 		setTimeout(function(){openModal("newContratistaModal")},500);
	// 		toast("Se ha producido un error al modificar el contratista. Inténtelo nuevamente");
	// 	});
	// };

	$scope.deleteGalpon = function ()
	{
		closeModal("editGalponModal");
		$http.post('php/del/index.php?op=galpon', $scope.galpon.IdGalpon)
		.success(function(data)
		{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editContratistaModal")},500);
			// 	toast("No se puede eliminar este galpon porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshGalpones();
				$scope.cleanGalpon();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editContratistaModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('registrogalponesCtrl', function($scope, $http)
{

	$scope.refreshRegGal = function()
	{
		$http.get("php/get/index.php?op=galponesvacios")
		.success(function(data)
		{
			console.log(data);
			$scope.galpones = data;	
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });
		});
		$http.get("php/get/index.php?op=registrogalpones")
		.success(function(data)
		{
			console.log(data);
			$scope.registrogalpones = data;
			$http.get("php/get/index.php?op=listaMortalidad")
			.success(function(data)
			{
				console.log(data);
				$scope.listaMortalidad = data;
				bajas = 0;
				altas = 0;
				for (var i = 0; i < $scope.registrogalpones.length; i++) {
					bajas = 0;
					altas = 0
					for (var j = 0; j < $scope.listaMortalidad.length; j++) {
						if ($scope.listaMortalidad[j].IdRG == $scope.registrogalpones[i].id)
							if ($scope.listaMortalidad[j].Tipo_n == 1)
							 altas = parseInt(altas) + parseInt($scope.listaMortalidad[j].Cantidad); 
							 else
							 bajas = parseInt(bajas) + parseInt($scope.listaMortalidad[j].Cantidad);
					}
					$scope.registrogalpones[i]["altas"] = altas;
					$scope.registrogalpones[i]["bajas"] = bajas;
				}

			});

		});	
		$http.get("php/get/index.php?op=gastos")
		.success(function(data)
		{
			console.log(data);
			$scope.gastos = data;
		});	
		$http.get("php/get/index.php?op=listaGastos")
		.success(function(data)
		{
			console.log(data);	
			$scope.listaGastos = data;
		});
		$http.get("php/get/index.php?op=listaVentas")
		.success(function(data)
		{
			console.log(data);
			$scope.listaVentas = data;
		});		
	}


	$scope.CleanRegistroGalpones = function()
	{
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.registrogalpon = {"IdRG":"",
								"IdEmpleado":parseInt(IdEmpleado),
								"fecha": moment().format("YYYY-MM-DD HH:mm:ss")
								};
	}

	$scope.refreshRegGal();
	$scope.CleanRegistroGalpones();
	$scope.$watch("obra.fecha_ini", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("obra.fecha_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});		


	$scope.selectEditRegistroGalpon = function (event)
	{
		$scope.selectgastos = [];	//gastos de lote
		$scope.selectventas = [];
		$scope.selectmortalidad = [];
		$scope.CleanRegistroGalpones();

		var id = event.currentTarget.id;
		console.log(id);
		for (var x=0; x<$scope.listaGastos.length; x++)
			if (id== $scope.listaGastos[x].IdRG)
				$scope.selectgastos.push($scope.listaGastos[x]);

			for (var x=0; x<$scope.listaVentas.length; x++)
				if (id== $scope.listaVentas[x].IdRG)
					$scope.selectventas.push($scope.listaVentas[x]);

				for (var x=0; x<$scope.listaMortalidad.length; x++)
					if (id== $scope.listaMortalidad[x].IdRG)
						$scope.selectmortalidad.push($scope.listaMortalidad[x]);

					$scope.registrogalpon.IdRG = id;
					labels_gastos = [];
					data_gastos = [];
					for (var i = $scope.selectgastos.length - 1; i >= 0; i--) {
						labels_gastos.push($scope.selectgastos[i].Nombre);
						data_gastos.push($scope.selectgastos[i].Precio);
					}
					var ctx = document.getElementById("gastos");
					var gastos = new Chart(ctx, {
						type: 'doughnut',
						data: {
							labels: labels_gastos,
							datasets: [{
								label: 'Gastos',
								data: data_gastos,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});
					labels_mortalidad = [];
					data_mortalidad = [];
					for (var i = 0; i < $scope.selectmortalidad.length; i ++) {
						labels_mortalidad.push($scope.selectmortalidad[i].Fecha);
						if (i > 0)
							data_mortalidad.push(data_mortalidad[i-1] - $scope.selectmortalidad[i].Cantidad );
						else data_mortalidad.push(parseInt($scope.selectmortalidad[i].Cantidad));

					}
					var ctx = document.getElementById("mortalidad");
					var mortalidad = new Chart(ctx, {
						type: 'line',
						data: {
							labels: labels_mortalidad,
							datasets: [{
								label: 'Mortalidad',
								data: data_mortalidad,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});




					labels_ventas = [];
					data_ventas = [];
					for (var i = 0; i < $scope.selectventas.length; i ++) {
						labels_ventas.push($scope.selectventas[i].Fecha);
						if (i > 0)
							data_ventas.push(data_ventas[i-1] - $scope.selectventas[i].Cantidad );
						else data_ventas.push(parseInt($scope.selectmortalidad[i].Cantidad));
					}
					var ctx = document.getElementById("ventas");
					var ventas = new Chart(ctx, {
						type: 'line',
						data: {
							labels: labels_ventas,
							datasets: [{
								label: 'Ventas',
								data: data_ventas,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});
				}

				$scope.newRegistroGalpon = function ()
				{
					closeModal("newRegGalModal");
					$http.post('php/put/index.php?op=newRegistroGalpon', $scope.registrogalpon)
					.success(function(data)
					{
						$scope.refreshRegGal();
						$scope.CleanRegistroGalpones();
						toast("Registro de galpón agregado exitosamente!");
					})
					.error(function(data)
					{
						setTimeout(function(){openModal("newRegistroGalpon")},500);
						toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
					});
				};

				$scope.newGasto = function ()
				{
					$http.post('php/put/index.php?op=newGasto', $scope.gasto)
					.success(function(data)
					{
						$scope.refreshRegGal();
						toast("Registro de gasto agregado exitosamente!");
					})
					.error(function(data)
					{
						toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
					});
				};


				$scope.newRegistroGasto = function ()
				{

					$scope.selectgastos.push({ "IdGasto": $scope.registrogasto.nombre.IdGasto, "Nombre": $scope.registrogasto.nombre.Nombre, "Fecha": $scope.registrogasto.fecha , "Precio": $scope.registrogasto.precio ,"IdRG": $scope.registrogasto.IdRG});

				};

				$scope.newRegistroMortalidad = function ()
				{
					$scope.selectmortalidad.push({"Cantidad": $scope.registromortalidad.cantidad ,"Fecha": $scope.registromortalidad.fecha ,"Tipo": $scope.registromortalidad.tipo ,"IdRG": $scope.registromortalidad.IdRG});

				};

				$scope.deleteRegGal = function ()
				{
					closeModal("editRegGapModal");
					$http.post('php/del/index.php?op=registrogalpon', $scope.registrogalpon)
					.success(function(data)
					{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editContratistaModal")},500);
			// 	toast("No se puede eliminar este galpon porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshRegGal();
				$scope.CleanRegistroGalpones();
				toast("Lote cerrado exitosamente!");	
			// }

		})
					.error(function(data)
					{
						setTimeout(function(){openModal("editRegGapModal")},500);
						toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
					});
				};

}); 


ruteo.controller('registrototalCtrl', function($scope, $http)
{

	$scope.refreshRegGal = function()
	{
		$http.get("php/get/index.php?op=galponesvacios")
		.success(function(data)
		{
			console.log(data);
			$scope.galpones = data;	
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });
		});
		$http.get("php/get/index.php?op=regtotal")
		.success(function(data)
		{
			console.log(data);
			$scope.registrogalpones = data;
			$http.get("php/get/index.php?op=listaMortalidad")
			.success(function(data)
			{
				console.log(data);
				$scope.listaMortalidad = data;
				bajas = 0;
				altas = 0;
				for (var i = 0; i < $scope.registrogalpones.length; i++) {
					bajas = 0;
					altas = 0
					for (var j = 0; j < $scope.listaMortalidad.length; j++) {
						if ($scope.listaMortalidad[j].IdRG == $scope.registrogalpones[i].id)
							if ($scope.listaMortalidad[j].Tipo_n == 1)
							 altas = parseInt(altas) + parseInt($scope.listaMortalidad[j].Cantidad); 
							 else
							 bajas = parseInt(bajas) + parseInt($scope.listaMortalidad[j].Cantidad);
					}
					$scope.registrogalpones[i]["altas"] = altas;
					$scope.registrogalpones[i]["bajas"] = bajas;
				}

			});

		});	
		$http.get("php/get/index.php?op=gastos")
		.success(function(data)
		{
			console.log(data);
			$scope.gastos = data;
		});	
		$http.get("php/get/index.php?op=listaGastos")
		.success(function(data)
		{
			console.log(data);	
			$scope.listaGastos = data;
		});
		$http.get("php/get/index.php?op=listaVentas")
		.success(function(data)
		{
			console.log(data);
			$scope.listaVentas = data;
		});		


	}



	$scope.refreshRegGal();
	$scope.$watch("obra.fecha_ini", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("obra.fecha_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});		


	$scope.selectEditRegistroGalpon = function (event)
	{
		$scope.selectgastos = [];	//gastos de lote
		$scope.selectventas = [];
		$scope.selectmortalidad = [];

		var id = event.currentTarget.id;
		console.log(id);
		for (var x=0; x<$scope.listaGastos.length; x++)
			if (id== $scope.listaGastos[x].IdRG)
				$scope.selectgastos.push($scope.listaGastos[x]);

			for (var x=0; x<$scope.listaVentas.length; x++)
				if (id== $scope.listaVentas[x].IdRG)
					$scope.selectventas.push($scope.listaVentas[x]);

				for (var x=0; x<$scope.listaMortalidad.length; x++)
					if (id== $scope.listaMortalidad[x].IdRG)
						$scope.selectmortalidad.push($scope.listaMortalidad[x]);

					$scope.registrogalpon.IdRG = id;
					labels_gastos = [];
					data_gastos = [];
					for (var i = $scope.selectgastos.length - 1; i >= 0; i--) {
						labels_gastos.push($scope.selectgastos[i].Nombre);
						data_gastos.push($scope.selectgastos[i].Precio);
					}
					var ctx = document.getElementById("gastos");
					var gastos = new Chart(ctx, {
						type: 'doughnut',
						data: {
							labels: labels_gastos,
							datasets: [{
								label: 'Gastos',
								data: data_gastos,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});
					labels_mortalidad = [];
					data_mortalidad = [];
					for (var i = 0; i < $scope.selectmortalidad.length; i ++) {
						labels_mortalidad.push($scope.selectmortalidad[i].Fecha);
						if (i > 0)
							data_mortalidad.push(data_mortalidad[i-1] - $scope.selectmortalidad[i].Cantidad );
						else data_mortalidad.push(parseInt($scope.selectmortalidad[i].Cantidad));

					}
					var ctx = document.getElementById("mortalidad");
					var mortalidad = new Chart(ctx, {
						type: 'line',
						data: {
							labels: labels_mortalidad,
							datasets: [{
								label: 'Mortalidad',
								data: data_mortalidad,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});
					labels_ventas = [];
					data_ventas = [];
					for (var i = 0; i < $scope.selectventas.length; i ++) {
						labels_ventas.push($scope.selectventas[i].Fecha);
						data_ventas.push($scope.selectventas[i].Cantidad);
					}
					var ctx = document.getElementById("ventas");
					var ventas = new Chart(ctx, {
						type: 'line',
						data: {
							labels: labels_ventas,
							datasets: [{
								label: 'Ventas',
								data: data_ventas,
								backgroundColor: [
								'rgba(255, 159, 64, 0.2)'
								],
								borderColor: [
								'rgba(255, 159, 64, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero:true
									}
								}]
							}
						}
					});
				}

			

				$scope.newGasto = function ()
				{
					$http.post('php/put/index.php?op=newGasto', $scope.gasto)
					.success(function(data)
					{
						$scope.refreshRegGal();
						toast("Registro de gasto agregado exitosamente!");
					})
					.error(function(data)
					{
						toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
					});
				};


				$scope.newRegistroGasto = function ()
				{

					$scope.selectgastos.push({ "IdGasto": $scope.registrogasto.nombre.IdGasto, "Nombre": $scope.registrogasto.nombre.Nombre, "Fecha": $scope.registrogasto.fecha , "Precio": $scope.registrogasto.precio ,"IdRG": $scope.registrogasto.IdRG});

				};

				$scope.newRegistroMortalidad = function ()
				{
					$scope.selectmortalidad.push({"Cantidad": $scope.registromortalidad.cantidad ,"Fecha": $scope.registromortalidad.fecha ,"Tipo": $scope.registromortalidad.tipo ,"IdRG": $scope.registromortalidad.IdRG});

				};

				$scope.deleteRegGal = function ()
				{
					closeModal("editRegGapModal");
					$http.post('php/del/index.php?op=registrogalpon', $scope.registrogalpon)
					.success(function(data)
					{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editContratistaModal")},500);
			// 	toast("No se puede eliminar este galpon porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshRegGal();
				toast("Registro eliminado exitosamente!");	
			// }

		})
					.error(function(data)
					{
						setTimeout(function(){openModal("editRegGapModal")},500);
						toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
					});
				};

}); 


ruteo.controller('nominaCtrl', function($scope, $http, dataShare)
{

	$scope.valida_cedula = dataShare.valida_cedula;

	$scope.refreshNomina = function()
	{
		$http.get("php/get/index.php?op=personas")
		.success(function(data)
		{
			console.log(data);
			$scope.listaNomina = data;
		});
		
	}


	$scope.cleanNomina = function()
	{
		$scope.nomina = {"user":"","IdEmpleado":"","IdPersona":"","ci":"","apellidos":"","nombres":"","correo":"","cargo":"","salario":"","direccion":"","permiso":""};
	}

	$scope.refreshNomina();
	$scope.cleanNomina();
	$scope.$watch("obra.fecha_ini", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("obra.fecha_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});		




	$scope.nuevoNomina = function ()
	{
		
		if (!dataShare.valida_cedula($scope.nomina.ci)){
			return;
		}

		$scope.nomina.user = $scope.nomina.correo.split('@')[0];
		$scope.nomina.ci = string($scope.nomina.ci);
		$scope.nomina.telefono = string($scope.nomina.telefono);

		closeModal("newNominaModal")
		$http.post('php/put/index.php?op=newNomina', $scope.nomina)
		.success(function(data)
		{
			toast(data.msg, data.success ? undefined : 'orange')
			$scope.refreshNomina();
		})
		.error(() => toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente", 'red'));
	};

	
	$scope.selectEditNomina = function (event)
	{
		var id = event.currentTarget.id;
		$scope.nomina.IdEmpleado = id;
		$scope.nomina.cargo = getItem($scope.listaNomina, 'Cargo', 'IdEmpleado', id);
		$scope.nomina.salario = parseFloat(getItem($scope.listaNomina, 'Sueldo', 'IdEmpleado', id));
		$scope.nomina.IdPersona = getItem($scope.listaNomina, 'IdPersona', 'IdEmpleado', id);
		$scope.nomina.ci = getItem($scope.listaNomina, 'Ci', 'IdEmpleado', id);
		$scope.nomina.apellidos = getItem($scope.listaNomina, 'Apellidos', 'IdEmpleado', id);
		$scope.nomina.nombres = getItem($scope.listaNomina, 'Nombres', 'IdEmpleado', id);
		$scope.nomina.correo = getItem($scope.listaNomina, 'Correo', 'IdEmpleado', id);
		$scope.nomina.direccion = getItem($scope.listaNomina, 'Direccion', 'IdEmpleado', id);
		$scope.nomina.telefono = getItem($scope.listaNomina, 'Telefono', 'IdEmpleado', id);
	}

	$scope.editNomina = function ()
	{
		closeModal("editnominaModal");
		$http.post('php/put/index.php?op=editNomina', $scope.nomina)
		.success(function(data)
		{
			$scope.refreshNomina();
			$scope.cleanNomina();
			toast("Registro modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editnominaModal")},500);
			toast("Se ha producido un error al modificar el registro. Inténtelo nuevamente");
		});
	};

	$scope.deleteNomina = function ()
	{
		closeModal("editnominaModal");
		$http.post('php/del/index.php?op=nomina', $scope.nomina.IdEmpleado)
		.success(function(data)
		{
				$scope.refreshNomina();
				$scope.cleanNomina();
				toast("Registro eliminado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editnominaModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};

}); 

ruteo.controller('veterinariosCtrl', function($scope, $http,dataShare)
{
	$scope.valida_cedula = dataShare.valida_cedula;
	$scope.refreshVeterinarios = function()
	{
		$http.get("php/get/index.php?op=veterinarios")
		.success(function(data)
		{
			console.log(data);
			$scope.veterinarios = data;
		});	
	}


	$scope.cleanVeterinario = function ()
	{
		$scope.veterinario = { "empresa": "", "apellidos": "", "nombres": "", "ci": "", "telefono": "", "correo":"", "direccion": ""};
	}

	$scope.refreshVeterinarios();
	$scope.cleanVeterinario();

	$scope.nuevoVeterinario = function ()
	{
		$scope.veterinario.ci = String($scope.veterinario.ci);
		$scope.veterinario.telefono = String($scope.veterinario.telefono);
		closeModal("newVeterinarioModal");
		$http.post('php/put/index.php?op=newVeterinario', $scope.veterinario)
		.success(function(data)
		{
			$scope.refreshVeterinarios();
			toast("Veterinario agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};


	$scope.selectEditVeterinario = function (event)
	{
		var id = event.currentTarget.id;
		console.log(id);
		$scope.veterinario.IdVeterinario = id;
		$scope.veterinario.empresa = getItem($scope.veterinarios, 'Empresa', 'IdVeterinario', id);
		$scope.veterinario.IdPersona = getItem($scope.veterinarios, 'IdPersona', 'IdVeterinario', id);
		$scope.veterinario.ci = getItem($scope.veterinarios, 'Ci', 'IdVeterinario', id);
		$scope.veterinario.apellidos = getItem($scope.veterinarios, 'Apellidos', 'IdVeterinario', id);
		$scope.veterinario.nombres = getItem($scope.veterinarios, 'Nombres', 'IdVeterinario', id);
		$scope.veterinario.correo = getItem($scope.veterinarios, 'Correo', 'IdVeterinario', id);
		$scope.veterinario.direccion = getItem($scope.veterinarios, 'Direccion', 'IdVeterinario', id);
		$scope.veterinario.telefono = getItem($scope.veterinarios, 'Telefono', 'IdVeterinario', id);	
	}

	

	$scope.editVeterinario = function ()
	{
		$scope.veterinario.ci = String($scope.veterinario.ci);
		$scope.veterinario.telefono = String($scope.veterinario.telefono);
		closeModal("editVeterinarioModal");
		$http.post('php/put/index.php?op=editVeterinario', $scope.veterinario)
		.success(function(data)
		{
			$scope.refreshVeterinarios();
			$scope.cleanVeterinario();
			toast("Veterinario modificada exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editGastoModal")},500);
			toast("Se ha producido un error al modificar el veterinario. Inténtelo nuevamente");
		});
	};

	
});

ruteo.controller('clientesCtrl', function($scope, $http, dataShare)
{
	$scope.valida_cedula = dataShare.valida_cedula;
	$scope.refreshCliente = function()
	{
		$http.get("php/get/index.php?op=getClientes")
		.success(function(data)
		{
			console.log(data);
			$scope.clientes = data;
		});	
	}

	$scope.cleanCliente = function ()
	{
		$scope.cliente = {"apellidos": "", 
						  "nombres": "", 
						  "ci": "", 
						  "telefono": "", 
						  "correo":"", 
						  "direccion": "",
						  "identificacion":false
						};
		
	}

	$scope.identificar = function(i){
		if (i.identificacion == false) {
			$scope.valida_cedula(i.ci);
		}
		else 
		{
			if(i.ci.length !== 13){
				toast("RUC incorrecto",'orange');
			}
		}	
	}


	$scope.refreshCliente();
	$scope.cleanCliente();

	$scope.newCliente = function ()
	{
		if ($scope.cliente.identificacion == false) {
			if (!dataShare.valida_cedula($scope.cliente.ci)){
			return;
			}
		}
		else 
		{
			if($scope.cliente.ci.length !== 13){
				toast("RUC incorrecto",'orange');
				return;
			}
		}
		$scope.cliente.ci = string($scope.cliente.ci);
		$scope.cliente.telefono = string($scope.cliente.telefono);
		closeModal("newClienteModal");
		$http.post('php/put/index.php?op=newCliente', $scope.cliente)
		.success(function(data)
		{
			$scope.refreshCliente();
			toast("Cliente agregado exitosamente!");
		})
		.error(function(data)
		{
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};


	$scope.selectEditCliente = function (event)
	{
		var id = event.currentTarget.id;
		console.log(id);
		$scope.cliente.idcliente = id;
		$scope.cliente.ruc = getItem($scope.clientes, 'ruc', 'idcliente', id);
		$scope.cliente.idpersona = getItem($scope.clientes, 'idpersona', 'idcliente', id);
		$scope.cliente.ci = getItem($scope.clientes, 'ci', 'idcliente', id);
		$scope.cliente.apellidos = getItem($scope.clientes, 'apellidos', 'idcliente', id);
		$scope.cliente.nombres = getItem($scope.clientes, 'nombres', 'idcliente', id);
		$scope.cliente.correo = getItem($scope.clientes, 'correo', 'idcliente', id);
		$scope.cliente.direccion = getItem($scope.clientes, 'direccion', 'idcliente', id);
		$scope.cliente.telefono = getItem($scope.clientes, 'telefono', 'idcliente', id);	
	}

	

	$scope.editCliente= function ()
	{
		if($scope.cliente.ci.length == 13){
			$scope.cliente.identificacion = 1;
		}else{
			$scope.cliente.identificacion = 0;
		}
		closeModal("editClienteModal");
		$http.post('php/put/index.php?op=editCliente', $scope.cliente)
		.success(function(data)
		{
			$scope.refreshCliente();
			$scope.cleanCliente();
			toast("Cliente modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editClienteModal")},500);
			toast("Se ha producido un error al modificar el cliente. Inténtelo nuevamente");
		});
	};

	
});

ruteo.controller('vacunasCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.vacuna = {};
	$scope.refreshVacunas = function()
	{
		$http.get("php/get/index.php?op=vacunas")
		.success(function(data)
		{
			console.log(data);
			$scope.vacunas = data;	
		});
	}

	$scope.refreshVacunas();

	$scope.cleanVacuna = function()
	{
		$scope.vacuna = {"IdVacuna": "", "nombre":""};
	}


	$scope.selectEditVacuna = function (event)
	{
		var id = event.currentTarget.id;
		$scope.vacuna.IdVacuna = id;
		$scope.vacuna.nombre = getItem($scope.vacunas, 'Nombre', 'IdVacuna', id);
	}

	$scope.newVacuna = function ()
	{
		closeModal("newVacunaModal");
		$http.post('php/put/index.php?op=newVacuna', $scope.vacuna)
		.success(function(data)
		{
			$scope.refreshVacunas();
			$scope.cleanVacuna();
			toast("Vacuna agregada exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newVacunaModal")},500);
			toast("Se ha producido un error al guardar la vacuna. Inténtelo nuevamente");
		});
	};

	$scope.editVacuna = function ()
	{
		closeModal("editVacunaModal");
		$http.post('php/put/index.php?op=editVacuna', $scope.vacuna)
		.success(function(data)
		{
			$scope.refreshVacunas();
			$scope.cleanVacuna();
			toast("Vacuna modificada exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editVacunaModal")},500);
			toast("Se ha producido un error al modificar la vacuna. Inténtelo nuevamente");
		});
	};



	$scope.deleteVacuna = function ()
	{
		closeModal("editVacunaModal");
		$http.post('php/del/index.php?op=vacuna', $scope.vacuna.IdVacuna)
		.success(function(data)
		{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editVacunaModal")},500);
			// 	toast("No se puede eliminar este vacuna porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshVacunas();
				$scope.cleanVacuna();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editVacunaModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('registroveterinarioCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.registroveterinario = {};
	$scope.filtro = {"idrg": {"lote":0}};	
	$scope.refreshRegVet = function()
	{
		$http.get("php/get/index.php?op=registrovacunas")
		.success(function(data)
		{
			console.log(data);
			$scope.listaRegVacunas = data;	
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });	
		});
		$http.get("php/get/index.php?op=vacunas")
		.success(function(data)
		{
			console.log(data);
			$scope.vacunas = data;	
		});
		$http.get("php/get/index.php?op=veterinarios")
		.success(function(data)
		{
			console.log(data);
			$scope.veterinarios = data;	
		});
		$http.get("php/get/index.php?op=lotesproduccion")
		.success(function(data)
		{
			console.log(data);
			$scope.lotesproduccion = data;	
		});
	}

	$scope.cleanRegVet = function()
	{
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth(); 
		var yyyy = today.getFullYear();
		if(dd<10) {    dd = '0'+dd};
		if(mm<10) {    mm = '0'+mm};
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.registroveterinario = {"idregvet": "", "idrg":{"lote":""},"veterinario":{"IdVeterinario":""},"fecha": moment().format("YYYY-MM-DD HH:mm:ss"),"observacion":"","vacuna":{"IdVacuna":""},"precio":"","idempleado": parseInt(IdEmpleado)};
		
		var diaSemana = today.getDay();
		
		pDiaSemana = document.getElementById('diaSemana'),
        pDia = document.getElementById('dia'),
        pMes = document.getElementById('mes'),
        pYear = document.getElementById('year');

		// Obtenemos el dia se la semana y lo mostramos
        var semana = ['DOMINGO', 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'];
        pDiaSemana.textContent = semana[diaSemana];

        // Obtenemos el dia del mes
        pDia.textContent = dd;

        // Obtenemos el Mes y año y lo mostramos
        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE']
        pMes.textContent = meses[mm];
        pYear.textContent = yyyy;
	}

	$scope.refreshRegVet();
	$scope.cleanRegVet();
	$scope.$watch("registroveterinario.fecha", function()
	{
		$('button.btn-flat.picker__close').click();
	});

	$scope.selectEditRegVet = function (event)
	{
		var id = event.currentTarget.id;
		$scope.registroveterinario.idregvet = id;
		$scope.registroveterinario.idrg = $scope.filtro.idrg.lote;
		$scope.registroveterinario.veterinario = {"IdVeterinario":getItem($scope.listaRegVacunas, 'idveterinario', 'idregvet', id)};
		$scope.registroveterinario.fecha = new Date (getItem($scope.listaRegVacunas, 'fecha', 'idregvet', id));
		$scope.registroveterinario.observacion = getItem($scope.listaRegVacunas, 'observacion', 'idregvet', id);
		$scope.registroveterinario.vacuna = {"IdVacuna": getItem($scope.listaRegVacunas, 'idvacuna', 'idregvet', id)};
		$scope.registroveterinario.empleado = getItem($scope.listaRegVacunas, 'empleado', 'idregvet', id);
		$scope.registroveterinario.precio = parseFloat(getItem($scope.listaRegVacunas, 'precio', 'idregvet', id));
	}

	$scope.newRegVet = function ()
	{
		$scope.registroveterinario.idrg.lote = $scope.filtro.idrg.lote;
		console.log($scope.registroveterinario);
		closeModal("newRegVetModal");
		$http.post('php/put/index.php?op=newRegVet', $scope.registroveterinario)
		.success(function(data)
		{
			toast(data.msg, data.success ? undefined : 'orange')
			$scope.refreshRegVet();
			$scope.cleanRegVet();
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newRegVetModal")},500);
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};

	$scope.deleteRegVet = function ()
	{
		closeModal("editRegVetModal");
		$http.post('php/del/index.php?op=registroveterinario', $scope.registroveterinario)
		.success(function(data)
		{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editVacunaModal")},500);
			// 	toast("No se puede eliminar este vacuna porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshRegVet();
				$scope.cleanRegVet();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editRegVetModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('presentacionCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.presentacion = {};
	$scope.refreshPresentacion = function()
	{
		$http.get("php/get/index.php?op=presentacion")
		.success(function(data)
		{
			console.log(data);
			$scope.presentaciones = data;	
		});
	}

	$scope.refreshPresentacion();

	$scope.cleanPresentacion = function()
	{
		$scope.presentacion = {"idpresentacion": "", "nombre":""};
	}


	$scope.selectEditPresentacion = function (event)
	{
		var id = event.currentTarget.id;
		$scope.presentacion.idpresentacion = id;
		$scope.presentacion.nombre = getItem($scope.presentaciones, 'nombre', 'idpresentacion', id);
	}

	$scope.newPresentacion = function ()
	{
		closeModal("newPresentacionModal");
		$http.post('php/put/index.php?op=newPresentacion', $scope.presentacion)
		.success(function(data)
		{
			$scope.refreshPresentacion();
			$scope.cleanPresentacion();
			toast("Presentación agregada exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newPresentacionModal")},500);
			toast("Se ha producido un error al guardar la presentación. Inténtelo nuevamente");
		});
	};

	$scope.editPresentacion = function ()
	{
		closeModal("editPresentacionModal");
		$http.post('php/put/index.php?op=editPresentacion', $scope.presentacion)
		.success(function(data)
		{
			$scope.refreshPresentacion();
			$scope.cleanPresentacion();
			toast("Presentación modificada exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editPresentacionModal")},500);
			toast("Se ha producido un error al modificar la presentación. Inténtelo nuevamente");
		});
	};



	$scope.deletePresentacion = function ()
	{
		closeModal("editPresentacionModal");
		$http.post('php/del/index.php?op=presentacion', $scope.presentacion.idpresentacion)
		.success(function(data)
		{
			// if(data==0)
			// {
			// 	setTimeout(function(){openModal("editVacunaModal")},500);
			// 	toast("No se puede eliminar este vacuna porque tiene obras asignadas");
			// }
			// else
			// {
				$scope.refreshPresentacion();
				$scope.cleanPresentacion();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editPresentacionModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('medidasCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.medida = {};
	$scope.refreshMedida = function()
	{
		$http.get("php/get/index.php?op=medida")
		.success(function(data)
		{
			console.log(data);
			$scope.medidas = data;	
		});
	}

	$scope.refreshMedida();

	$scope.cleanMedida = function()
	{
		$scope.medida = {"idmedida": "", "nombre":"", "medida":""};
	}


	$scope.selectEditMedida = function (event)
	{
		var id = event.currentTarget.id;
		$scope.medida.idmedida = id;
		$scope.medida.nombre = getItem($scope.medidas, 'nombre', 'idmedida', id);
		$scope.medida.medida = getItem($scope.medidas, 'medida', 'idmedida', id);
	}

	$scope.newMedida = function ()
	{
		closeModal("newMedidaModal");
		$http.post('php/put/index.php?op=newMedida', $scope.medida)
		.success(function(data)
		{
			$scope.refreshMedida();
			$scope.cleanMedida();
			toast("Medida agregada exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newMedidaModal")},500);
			toast("Se ha producido un error al guardar la medida. Inténtelo nuevamente");
		});
	};

	$scope.editMedida = function ()
	{
		closeModal("editMedidaModal");
		$http.post('php/put/index.php?op=editMedida', $scope.medida)
		.success(function(data)
		{
			$scope.refreshMedida();
			$scope.cleanMedida();
			toast("Medida modificada exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editMedidaModal")},500);
			toast("Se ha producido un error al modificar la medida. Inténtelo nuevamente");
		});
	};



	$scope.deleteMedida = function ()
	{
		closeModal("editMedidaModal");
		$http.post('php/del/index.php?op=medida', $scope.medida.idmedida)
		.success(function(data)
		{
				$scope.refreshMedida();
				$scope.cleanMedida();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editMedidaModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('preciosCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.precio = {};
	$scope.refreshPrecios = function()
	{
		$http.get("php/get/index.php?op=precios")
		.success(function(data)
		{
			console.log(data);
			$scope.precios = data;	
		});
	}

	$scope.refreshPrecios();

	$scope.cleanPrecios = function()
	{
		$scope.precio = {"valor": "","nombre":""};
	}


	$scope.selectEditPrecio = function (event)
	{
		var nombre = event.currentTarget.id;
		$scope.precio.nombre = nombre;
		$scope.precio.valor = getItem($scope.precios, 'valor', 'nombre', nombre);		
	}


	$scope.editPrecio = function ()
	{
		closeModal("editPreciosModal");
		$http.post('php/put/index.php?op=editPrecio', $scope.precio)
		.success(function(data)
		{
			$scope.refreshPrecios();
			$scope.cleanPrecios();
			toast("Precio modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editPreciosModal")},500);
			toast("Se ha producido un error al modificar el valor del registro. Inténtelo nuevamente");
		});
	};

}]);

ruteo.controller('alimentosCtrl', ['$scope', '$http', function($scope,$http) 
{
	
	$scope.alimento = {};
	$scope.refreshMedida = function()
	{
		$http.get("php/get/index.php?op=medida")
		.success(function(data)
		{
			console.log(data);
			$scope.medidas = data;	
		});
	}
	$scope.refreshPresentacion = function()
	{
		$http.get("php/get/index.php?op=presentacion")
		.success(function(data)
		{
			console.log(data);
			$scope.presentaciones = data;	
		});
	}
	$scope.refreshProductos = function()
	{
		$http.get("php/get/index.php?op=producto")
		.success(function(data)
		{
			console.log(data);
			$scope.productos = data;	
		});
	}

	$scope.refreshMedida();
	$scope.refreshPresentacion();
	$scope.refreshProductos();

	$scope.cleanProducto = function()
	{
		$scope.alimento = {"idalimento": "", "descripcion":"", "preciou":"","peso":"","presentacion":{"idpresentacion":"","nombre":""},"medida":{"idmedida":"","nombre":"","medida":""}};
	}


	$scope.selectEditAlimento = function (event)
	{
		var id = event.currentTarget.id;
		$scope.alimento.idalimento = id;
		$scope.alimento.descripcion = getItem($scope.productos, 'descripcion', 'idproducto', id);
		$scope.alimento.preciou = parseFloat(getItem($scope.productos, 'preciounitario', 'idproducto', id));
		$scope.alimento.peso = parseFloat(getItem($scope.productos, 'peso', 'idproducto', id));
		$scope.alimento.presentacion = {"idpresentacion":getItem($scope.productos, 'idpresentacion', 'idproducto', id)};
		$scope.alimento.medida = {"idmedida": getItem($scope.productos, 'idmedidas', 'idproducto', id)};
	}

	$scope.newAlimento = function ()
	{
		closeModal("newAlimentoModal");
		$http.post('php/put/index.php?op=newAlimento', $scope.alimento)
		.success(function(data)
		{
			$scope.refreshProductos();
			$scope.cleanProducto();
			toast("Alimento agregado exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newAlimentoModal")},500);
			toast("Se ha producido un error al guardar el alimento. Inténtelo nuevamente");
		});
	};

	$scope.editAlimento = function ()
	{
		closeModal("editAlimentoModal");
		$http.post('php/put/index.php?op=editAlimento', $scope.alimento)
		.success(function(data)
		{
			$scope.refreshProductos();
			$scope.cleanProducto();
			toast("Alimento modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editAlimentoModal")},500);
			toast("Se ha producido un error al modificar el alimento. Inténtelo nuevamente");
		});
	};



	$scope.deleteAlimento = function ()
	{
		closeModal("editAlimentoModal");
		$http.post('php/del/index.php?op=alimento', $scope.alimento.idalimento)
		.success(function(data)
		{
				$scope.refreshProductos();
				$scope.cleanProducto();
				toast("Registro eliminado exitosamente!");	
			// }

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editAlimentoModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);

ruteo.controller('alimentacionCtrl', ['$scope', '$http', function($scope,$http) 
{
	$scope.alimentacion = {};
	$scope.filtro = {"IdRG": {"lote":0}};	
	$scope.refreshAlimentaciones = function()
	{
		$http.get("php/get/index.php?op=alimentacion")
		.success(function(data)
		{
			console.log(data);
			$scope.alimentaciones = data;	
			$(".datepicker").pickadate({closeOnSelect: true,format: "yyyy-mm-dd" });
		});
		$http.get("php/get/index.php?op=producto")
		.success(function(data)
		{
			console.log(data);
			$scope.productos = data;	
		});
		$http.get("php/get/index.php?op=lotesproduccion")
		.success(function(data)
		{
			console.log(data);
			$scope.lotesproduccion = data;
		});
	}

	$scope.cleanAlimentacion = function()
	{
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth(); 
		var yyyy = today.getFullYear();
		if(dd<10) {    dd = '0'+dd};
		if(mm<10) {    mm = '0'+mm};
		var IdEmpleado = localStorage.getItem('IdEmpleado');
		$scope.alimentacion = {"idrg":"","idrg":{"lote":""},
		 						"fecha": moment().format("YYYY-MM-DD"), 
		 						"cantidad":"", 
		 						"producto": {"idproducto":""},
		 						"observacion":"",
		 						"idempleado":parseInt(IdEmpleado)
		 					};
		var diaSemana = today.getDay();
		
		pDiaSemana = document.getElementById('diaSemana'),
        pDia = document.getElementById('dia'),
        pMes = document.getElementById('mes'),
        pYear = document.getElementById('year');

		// Obtenemos el dia se la semana y lo mostramos
        var semana = ['DOMINGO', 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'];
        pDiaSemana.textContent = semana[diaSemana];

        // Obtenemos el dia del mes
        pDia.textContent = dd;

        // Obtenemos el Mes y año y lo mostramos
        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE']
        pMes.textContent = meses[mm];
        pYear.textContent = yyyy;
	}


	$scope.refreshAlimentaciones();
	$scope.cleanAlimentacion();
	$scope.$watch("alimentacion.fecha", function()
	{
		$('button.btn-flat.picker__close').click();
	});	
	$scope.$watch("tarea.f_fin", function()
	{
		$('button.btn-flat.picker__close').click();
	});	

	$scope.selectEditAlimentacion = function (event)
	{
		var id = event.currentTarget.id;
		$scope.alimentacion.idra = id;
		$scope.alimentacion.idrg = $scope.filtro.IdRG.lote;
		$scope.alimentacion.fecha = new Date (getItem($scope.alimentaciones, 'fecha', 'idra', id));
		$scope.alimentacion.cantidad = parseInt(getItem($scope.alimentaciones, 'cantidad', 'idra', id));
		$scope.alimentacion.producto = {"idproducto": getItem($scope.alimentaciones, 'idproducto', 'idra', id),"descripcion":getItem($scope.alimentaciones, 'alimento', 'idra', id)};
		$scope.alimentacion.observacion = getItem($scope.alimentaciones, 'observacion', 'idra', id);
		$scope.alimentacion.empleado = getItem($scope.alimentaciones, 'apellidos', 'idra', id) + " " + getItem($scope.alimentaciones, 'nombres', 'idra', id);
		$scope.alimentacion.preciou = parseFloat(getItem($scope.alimentaciones, 'preciou', 'idra', id));

	}

	$scope.newAlimentacion = function ()
	{
		$scope.alimentacion.idrg.lote = $scope.filtro.IdRG.lote;
		closeModal("newAlimentacionModal");
		$http.post('php/put/index.php?op=newAlimentacion', $scope.alimentacion)
		.success(function(data)
		{
			$scope.refreshAlimentaciones();
			$scope.cleanAlimentacion();
			toast("Registro de Alimento agregado exitosamente!");
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("newAlimentacionModal")},500);
			toast("Se ha producido un error al guardar el registro. Inténtelo nuevamente");
		});
	};

	$scope.editAlimentacion = function ()
	{
		closeModal("editAlimentacionModal");
		$http.post('php/put/index.php?op=editAlimentacion', $scope.alimentacion)
		.success(function(data)
		{
			$scope.refreshAlimentaciones();
			$scope.cleanAlimentacion();
			toast("Registro de Alimento modificado exitosamente!");	
		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editAlimentacionModal")},500);
			toast("Se ha producido un error al modificar el registro. Inténtelo nuevamente");
		});
	};



	$scope.deleteAlimentacion = function ()
	{
		//$scope.alimentacion.idrg = $scope.filtro.IdRG.lote;
		closeModal("editAlimentacionModal");
		$http.post('php/del/index.php?op=alimentacion', $scope.alimentacion)
		.success(function(data)
		{
			$scope.refreshAlimentaciones();
			$scope.cleanAlimentacion();
			toast("Registro eliminado exitosamente!");	

		})
		.error(function(data)
		{
			setTimeout(function(){openModal("editAlimentacionModal")},500);
			toast("Se ha producido un error al eliminar el registro. Inténtelo nuevamente");
		});
	};


}]);
