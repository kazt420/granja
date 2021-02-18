


___________________________________________________________________________________________
___________________________________________________________________________________________
----ALIMENTACION
DROP PROCEDURE IF EXISTS newAlimentacion;
DELIMITER //
CREATE PROCEDURE newAlimentacion( xidrg int, xfecha datetime, xidempleado int, xidproducto int, xobservacion varchar(30))
BEGIN 
	INSERT INTO registroalimentacion (IdRG,Fecha,IdEmpleado,IdProducto,Observacion) VALUES (xidrg,xfecha,xidempleado,xidproducto,xobservacion);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editAlimentacion;
DELIMITER //
CREATE PROCEDURE editAlimentacion(xidra INT,xidrg int, xfecha datetime, xidempleado int, xidproducto int, xobservacion varchar(30))
BEGIN 
	UPDATE registroalimentacion SET IdRA = xidra, IdRG = xidrg, Fecha=xfecha, IdEmpleado = xIdEmpleado, IdProducto = xidproducto, Observacion = xobservacion WHERE IdRA = xidra and IdRG=xidrg;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteAlimentacion;
DELIMITER //
CREATE PROCEDURE deleteAlimentacion(xid INT,xidproducto int, xidrg int)
BEGIN 
	delete from registroalimentacion WHERE IdRA = xid;
END //
DELIMITER ;



----CLIENTES

DROP PROCEDURE IF EXISTS newCliente;
DELIMITER //
CREATE PROCEDURE newCliente(xapellidos varchar(25), xnombres varchar(25), xidentificacion varchar(13), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xid int(1))
BEGIN
  IF  (xid = 1) THEN ##RUC
  	SELECT count(*) INTO @existepersona FROM personas,clientes WHERE clientes.RUC = xidentificacion AND personas.Apellidos = xapellidos AND personas.Nombres = xnombres;
	IF ( SELECT @existepersona = 0 ) THEN                                  
	  INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),"0",xtelefono,xcorreo,UPPER(xdireccion));
	END IF;

	SELECT IdPersona INTO @idper FROM personas WHERE Ci = "0" AND Apellidos = xapellidos AND Nombres = xnombres;
	SELECT count(*) INTO @existecliente FROM clientes WHERE IdPersona = @idper;
	IF(SELECT @existecliente = 0) THEN
	  INSERT INTO clientes (IdPersona,RUC,Vita) VALUES (@idper,xidentificacion,1);
	ELSE
	 UPDATE clientes SET RUC=xidentificacion,Vita = 1 WHERE IdPersona = @idper;
	 UPDATE personas set Telefono = xtelefono, Correo = xcorreo, Direccion = UPPER(xdireccion) WHERE IdPersona= @idper;
	END IF;
  ELSE     ##CI
  	SELECT count(*) INTO @existepersona FROM personas WHERE Ci = xidentificacion AND Apellidos = xapellidos AND Nombres = xnombres;
	 IF ( SELECT @existepersona = 0 ) THEN                                  
	   INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xidentificacion,xtelefono,xcorreo,UPPER(xdireccion));
	 END IF;

	 SELECT IdPersona INTO @idper FROM personas WHERE Ci = xidentificacion AND Apellidos = xapellidos AND Nombres = xnombres;
	 SELECT count(*) INTO @existecliente FROM clientes WHERE IdPersona = @idper;
	 IF(SELECT @existecliente = 0) THEN
	   INSERT INTO clientes (IdPersona,RUC,Vita) VALUES (@idper,"0",1);
	 ELSE
	   UPDATE clientes SET RUC=xidentificacion,Vita = 1 WHERE IdPersona = @idper;
	   UPDATE personas set Telefono = xtelefono, Correo = xcorreo, Direccion = UPPER(xdireccion) WHERE IdPersona= @idper;
	 END IF;
  END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS editCliente;
DELIMITER //
CREATE PROCEDURE editCliente(xidveterinario int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci varchar(13), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xidentificacion int(1))
BEGIN 
  IF(xidentificacion = 1) THEN
  	UPDATE clientes SET RUC = xci WHERE IdVeterinario = xidveterinario AND IdPersona = xidpersona;
  	UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
  ELSE
  	UPDATE personas SET Ci = xci, Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
  END IF;
END //
DELIMITER ;


#ALIMENTOS _________________-----------------------

DROP PROCEDURE IF EXISTS newAlimento;
DELIMITER //
CREATE PROCEDURE newAlimento( xnombre varchar(35), xpreciou FLOAT(5,2), xpeso float(5,2), xidpresentacion int(3),xidmedida int(3))
BEGIN 
 SELECT count(*) INTO @exist FROM productos WHERE Descripcion = UPPER(xnombre) and peso = xpeso and IdPresentacion = xidpresentacion and IdMedidas = xidmedida;
  IF (SELECT @exist = 0) THEN
    INSERT INTO productos (Descripcion,PrecioUnitario,Peso,IdPresentacion,IdMedidas,vita) VALUES (UPPER(xnombre),xpreciou,xpeso,xidpresentacion,xidmedida,1);
  ELSE
    UPDATE productos SET vita = 1,PrecioUnitario= xpreciou WHERE Descripcion = UPPER(xnombre) and PrecioUnitario = xpreciou and peso = xpeso and IdPresentacion = xidpresentacion and IdMedidas = xidmedida;
  END IF ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editAlimento;
DELIMITER //
CREATE PROCEDURE editAlimento(xidproducto INT, xnombre varchar(35), xpreciou FLOAT(5,2), xpeso float(5,2), xidpresentacion int(3),xidmedida int(3))
BEGIN 
	UPDATE productos SET Descripcion = upper(xnombre), Peso =xpeso, IdPresentacion = xidpresentacion, IdMedidas = xidmedida WHERE IdProducto = xidproducto;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteAlimento;
DELIMITER //
CREATE PROCEDURE deleteAlimento(xid INT)
BEGIN 
	UPDATE productos SET vita=0 WHERE IdProducto = xid;
END //
DELIMITER ;


#PRECIOS_______________________

DROP PROCEDURE IF EXISTS editPrecio;
DELIMITER //
CREATE PROCEDURE editPrecio(xvalor float(6,2),xnombre varchar(10))
BEGIN 
	UPDATE precios SET valor = xvalor WHERE nombre = xnombre;
END //
DELIMITER ;


#MEDIDAS _________________-----------------------

DROP PROCEDURE IF EXISTS newMedida;
DELIMITER //
CREATE PROCEDURE newMedida( xnombre varchar(10),xmedida varchar(5))
BEGIN 
 SELECT count(*) INTO @exist FROM medidas WHERE Nombre = UPPER(xnombre) and medida = UPPER(xmedida);
  IF (SELECT @exist = 0) THEN
    INSERT INTO medidas (Nombre,medida,vita) VALUES (UPPER(xnombre),UPPER(xmedida),1);
  ELSE
    UPDATE medidas SET Vita = 1 WHERE Nombre = UPPER(xnombre) and medida = UPPER(xmedida);
  END IF ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editMedida;
DELIMITER //
CREATE PROCEDURE editMedida(xidmedida INT, xnombre VARCHAR(10), xmedida VARCHAR(5))
BEGIN 
	UPDATE medidas SET Nombre = upper(xnombre), medida = UPPER(xmedida) WHERE IdMedidas = xidmedida;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteMedida;
DELIMITER //
CREATE PROCEDURE deleteMedida(xid INT)
BEGIN 
	UPDATE medidas SET vita=0 WHERE IdMedidas = xid;
END //
DELIMITER ;



#PRESENTACION _________________-----------------------

DROP PROCEDURE IF EXISTS newPresentacion;
DELIMITER //
CREATE PROCEDURE newPresentacion( xnombre varchar(20))
BEGIN 
 SELECT count(*) INTO @exist FROM presentacion WHERE Nombre = UPPER(xnombre);
  IF (SELECT @exist = 0) THEN
    INSERT INTO presentacion (Nombre,Vita) VALUES (UPPER(xnombre),1);
  ELSE
    UPDATE presentacion SET Vita = 1 WHERE Nombre = xnombre;
  END IF ;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS editPresentacion;
DELIMITER //
CREATE PROCEDURE editPresentacion(xidpresentacion INT, xnombre VARCHAR(30))
BEGIN 
	UPDATE presentacion SET Nombre = upper(xnombre) WHERE idpresentacion = xidpresentacion;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deletePresentacion;
DELIMITER //
CREATE PROCEDURE deletePresentacion(xid INT)
BEGIN 
	UPDATE presentacion SET vita=0 WHERE idpresentacion = xid;
END //
DELIMITER ;


#REGISTROVETERINARIO _________________-----------------------

DROP PROCEDURE IF EXISTS newRegVet;
DELIMITER //
CREATE PROCEDURE newRegVet(xidrg int, xidveterinario int, xfecha datetime, xobservacion varchar(30), xidvacuna int,xidempleado int, xprecio float(6,2))
BEGIN 
	declare xsuma float(6,2);
	SElECT count(*) into @existreg from registroveterinario where IdRG = xidrg and IdVacuna = xidvacuna;
	IF (SELECT @existreg != 1) THEN
		INSERT INTO registroveterinario (IdRG,IdVeterinario,Fecha,Observacion,IdVacuna,IdEmpleado,Precio) VALUES (xidrg,xidveterinario,xfecha,xobservacion,xidvacuna,xidempleado,xprecio);
		SELECT Valor INTO @xtotal FROM registrogalpones WHERE IdRG = xidrg;
		set xsuma = @xtotal - xprecio;
		UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
	Else 
		SELECT @existreg existreg;
	END IF ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteRegVet;
DELIMITER //
CREATE PROCEDURE deleteRegVet(xidregvet INT,xidrg int, xprecio float(6,2))
BEGIN 
	declare xsuma float(6,2);
	SELECT Valor INTO @xvalor FROM registrogalpones WHERE IdRG = xidrg;
	set xsuma = @xvalor + xprecio;
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;	
	delete from registroveterinario WHERE IdRegVet = xidregvet;
END //
DELIMITER ;


#VACUNA _________________-----------------------

DROP PROCEDURE IF EXISTS newVacuna;
DELIMITER //
CREATE PROCEDURE newVacuna( xnombre varchar(20))
BEGIN 
  SELECT count(*) INTO @exist FROM vacunas WHERE Nombre = UPPER(xnombre);
  IF (SELECT @exist = 0) THEN
    INSERT INTO vacunas (Nombre,Estado) VALUES (UPPER(xnombre),1);
  ELSE
    UPDATE vacunas SET Estado = 1 WHERE Nombre = xnombre;
  END IF ;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS editVacuna;
DELIMITER //
CREATE PROCEDURE editVacuna(xidvacuna INT, xnombre VARCHAR(30))
BEGIN 
	UPDATE vacunas SET Nombre = xnombre WHERE IdVacuna = xidvacuna;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteVacuna;
DELIMITER //
CREATE PROCEDURE deleteVacuna(xid INT)
BEGIN 
	UPDATE vacunas SET Estado=0 WHERE IdVacuna = xid;
END //
DELIMITER ;


#VETERINARIO

DROP PROCEDURE IF EXISTS newVeterinario;
DELIMITER //
CREATE PROCEDURE newVeterinario(xapellidos varchar(25), xnombres varchar(25), xci varchar(10), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xempresa varchar(30))
BEGIN
	SELECT count(*)	INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
	IF ( SELECT @existepersona = 0 ) THEN                                  
		INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xci,xtelefono,xcorreo,UPPER(xdireccion));
	END IF;

	SELECT IdPersona INTO @idper FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
	SELECT count(*) INTO @existeempleado FROM VETERINARIO WHERE IdPersona = @idper;
	IF(SELECT @existeempleado = 0) THEN
		INSERT INTO VETERINARIO (IdPersona,Empresa) VALUES (@idper,UPPER(xempresa));
	ELSE
		UPDATE VETERINARIO SET Empresa=UPPER(xempresa) WHERE IdPersona = @idper;
	END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS editVeterinario;
DELIMITER //
CREATE PROCEDURE editVeterinario(xidveterinario int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci varchar(10), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xempresa varchar(30))
BEGIN 
	UPDATE VETERINARIO SET Empresa = UPPER(xempresa) WHERE IdVeterinario = xidveterinario AND IdPersona = xidpersona;
	UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = UPPER(xdireccion) WHERE IdPersona = xidpersona;
END //
DELIMITER ;


#NOMINA----------------------


DROP PROCEDURE IF EXISTS newNomina;
DELIMITER //
CREATE PROCEDURE newNomina(xapellidos varchar(25), xnombres varchar(25), xci varchar(10), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(20), xtipo int(1), xuser varchar(30))
BEGIN
  SELECT count(*) INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
  IF ( SELECT @existepersona = 0 ) THEN                                  
    INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xci,xtelefono,xcorreo,xdireccion);
  END IF;

  SELECT IdPersona INTO @idper FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
  SELECT count(*) INTO @existeempleado FROM EMPLEADOS WHERE IdPersona = @idper;
  IF(SELECT @existeempleado = 0) THEN
    INSERT INTO EMPLEADOS (IdPersona,Sueldo,Cargo,Vita) VALUES (@idper,xsueldo,UPPER(xcargo),1);
    SELECT IdEmpleado INTO @idemple FROM empleados WHERE IdPersona = @idper;
    INSERT INTO usuarios(IdEmpleado,User,Pass,Tipo,Vita) VALUES (@idemple,xuser,xci,xtipo,1);
  ELSE
    UPDATE empleados SET Sueldo=xsueldo,Cargo=xcargo, Vita=1 WHERE IdPersona = @idper;
  END IF;

  SELECT @existepersona existepersona, @existeempleado existeempleado;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editUsuario; 
DELIMITER //
CREATE PROCEDURE editUsuario(xidempleado int(1), xuser varchar(16), xpass varchar(16), xnewpass varchar(16))
BEGIN 
	SELECT count(*) INTO @existeusuario from usuarios where IdEmpleado = xidempleado and user = xuser and pass = xpass;
	IF(SELECT @existeusuario = 1) THEN
		UPDATE usuarios SET pass = xnewpass WHERE user = xuser and pass = xpass;
	ELSE
		SELECT @existeusuario existeusuario;
	END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS editNomina; 
DELIMITER //
CREATE PROCEDURE editNomina(xidempleado int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci varchar(10), xtelefono varchar(15), xcorreo varchar(30), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(20))
BEGIN 
	UPDATE empleados SET Sueldo = xsueldo, Cargo = UPPER(xcargo) WHERE IdEmpleado = xidempleado AND IdPersona = xidpersona;
	UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteNomina;
DELIMITER //
CREATE PROCEDURE deleteNomina(xid INT)
BEGIN 
	UPDATE empleados SET Vita=0 WHERE IdEmpleado = xid;
	UPDATE usuarios SET Vita=0 WHERE IdEmpleado = xid;
END //
DELIMITER ;

#GALPON-------------------

DROP PROCEDURE IF EXISTS newGalpon;
DELIMITER //
CREATE PROCEDURE newGalpon( xcapacidad int)
BEGIN 
	INSERT INTO galpones (Capacidad,Estado,Activo) VALUES (xcapacidad,0,1);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteGalpon;
DELIMITER //
CREATE PROCEDURE deleteGalpon(xid INT)
BEGIN 
	UPDATE galpones SET Activo=0 WHERE IdGalpon = xid;
END //
DELIMITER ;

#REGISTRO GALPON ------------------

DROP PROCEDURE IF EXISTS newRegistroGalpon;
DELIMITER //
CREATE PROCEDURE newRegistroGalpon( xIdGalpon INT, xFechaInicio datetime, xIdEmpleado INT)
BEGIN 
	INSERT INTO registrogalpones (IdGalpon, FechaInicio, FechaFin,Cantidad,Valor,Estado,IdEmpleado) VALUES (xIdGalpon,xFechaInicio,"",0,0,0,xIdEmpleado);
	UPDATE galpones SET Estado=1 WHERE IdGalpon = xIdGalpon;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS closeRegistroGalpon;
DELIMITER //
CREATE PROCEDURE closeRegistroGalpon( xidrg INT, xFechaFin DATE)
BEGIN 
	DECLARE xidgalpon int;
	SELECT IdGalpon INTO xidgalpon FROM registrogalpones WHERE IdRG = xidrg;
	UPDATE galpones SET Estado = 0 where IdGalpon = xidgalpon;
	UPDATE registrogalpones SET Estado = 1, FechaFin = xFechaFin WHERE IdRG = xidrg;
END //
DELIMITER ;

#GASTO -------------

DROP PROCEDURE IF EXISTS newGasto;
DELIMITER //
CREATE PROCEDURE newGasto( xnombre VARCHAR(20))
BEGIN 
	SELECT count(*) INTO @existegasto FROM gastos WHERE Nombre = xnombre;
	IF (@existegasto = 1) THEN
		UPDATE gastos SET Vita= 1 where Nombre = xnombre;
	ELSE
		INSERT INTO gastos (Nombre,Vita) VALUES (UPPER(xnombre),1); 
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editarGasto;
DELIMITER //
CREATE PROCEDURE editarGasto(xidgasto INT, xnombre VARCHAR(20))
BEGIN 
	UPDATE gastos SET Nombre = xnombre WHERE IdGasto = xidgasto;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteDatoGasto;
DELIMITER //
CREATE PROCEDURE deleteDatoGasto(xidgasto INT)
BEGIN 
	UPDATE gastos SET Vita = 0 WHERE IdGasto = xidgasto;
END //
DELIMITER ;


#MORTALIDAD -------------

DROP PROCEDURE IF EXISTS newMortalidad;
DELIMITER //
CREATE PROCEDURE newMortalidad( xfecha datetime, xcantidad int, xidrg int, xtipo int, xcomentario varchar(30), xidempleado int)
BEGIN 
	declare xsuma int;
	declare xtotal int;
	INSERT INTO mortalidad (Fecha,Cantidad,IdRG,Tipo,Comentario,IdEmpleado) VALUES (xfecha,xcantidad,xidrg,xtipo,xcomentario,xidempleado);
	set xsuma=0;
	SELECT Cantidad INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
		IF xtipo = 1 THEN
			set xsuma = xtotal + xcantidad;
		elseif xtipo = 0 THEN
			set xsuma = xtotal - xcantidad;
		END IF;
	UPDATE registrogalpones set Cantidad = xsuma where IdRG = xidrg;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS editMortalidad;
DELIMITER //
CREATE PROCEDURE editMortalidad(xidmort INT, xfecha date,xcantidad int, xidrg int,xtipo int)
BEGIN 
	UPDATE mortalidad SET Fecha = xfecha, Cantidad = xcantidad, Tipo=xtipo WHERE IdMort = xidmort and IdRG=xidrg;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS deleteMortalidad;
DELIMITER //
CREATE PROCEDURE deleteMortalidad(xid INT,xidrg INT, xcantidad INT,xtipo int)
BEGIN 
	declare xsuma int;
	declare xtotal int;
	set xsuma = 0; 
	SELECT Cantidad INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
		IF xtipo = 1 THEN
			set xsuma = xtotal - xcantidad;
		elseif xtipo = 0 THEN
			set xsuma = xtotal + xcantidad;
		END IF;
	UPDATE registrogalpones set Cantidad = xsuma where IdRG = xidrg;
	delete from mortalidad WHERE IdMort = xid;
END //
DELIMITER ;


#GASTOS POR LOTE -------------

DROP PROCEDURE IF EXISTS newRegistroGasto;
DELIMITER //
CREATE PROCEDURE newRegistroGasto( xidgasto int, xfecha datetime, xprecio float(6,2), xidrg int, xidempleado int, xidalimento int, xcantidad int)
BEGIN 
	declare xsuma float(6,2);
	declare xtotal float(6,2);
	INSERT INTO registrogastos (IdGasto,Fecha,Precio,IdRG,IdEmpleado,cantidad,idalimento) VALUES (xidgasto,xfecha,xprecio,xidrg,xidempleado, xcantidad, xidalimento);
	set xsuma=0;
	SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
		set xsuma = xtotal - (xprecio * xcantidad);
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS editRegGast;
DELIMITER //
CREATE PROCEDURE editRegGast(xidreggast INT,xidgasto int, xfecha date,xprecio float(6,2), xidrg int)
BEGIN 
	UPDATE registrogastos SET IdGasto = xidgasto, Fecha = xfecha, Precio=xprecio WHERE IdRegGast = xidreggast and IdRG=xidrg;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteGasto;
DELIMITER //
CREATE PROCEDURE deleteGasto(xid INT,xprecio float(6,2), xidrg int)
BEGIN 
	declare xtotal float(6,2);
	declare xsuma float(6,2);
	SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
	set xsuma = xtotal + xprecio;
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;	
	delete from registrogastos WHERE IdRegGast = xid;
END //
DELIMITER ;


#VENTAS POR LOTE -------------

DROP FUNCTION IF EXISTS getSumaDetalle;
DELIMITER //
CREATE FUNCTION getSumaDetalle(xid int) RETURNS float(6,2) reads sql data
BEGIN
	DECLARE sumadetalle float(6,2);
	set sumadetalle = 0;
	SELECT SUM(cantidad * precio) into sumadetalle from detalle where idfactura = xid; 
	RETURN sumadetalle;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS getFacturas;
DELIMITER //
CREATE PROCEDURE getFacturas()
BEGIN
	SELECT 	f.idfactura,
	f.idcliente,
	pc.ci,
	concat (pc.nombres,' ', pc.apellidos) as cliente,
	f.fecha,
	f.iva,
	f.idempleado,
	concat (pe.apellidos,' ', pe.nombres) as empleado,
	granja.getSumaDetalle(f.idfactura) as valor,
	d.IdRG
	FROM factura as f,
 	clientes as c,
 	personas as pc,
 	empleados as e,
 	personas as pe,
 	detalle as d
 	where 
	f.idcliente = c.idcliente AND c.idpersona = pc.idpersona AND f.idempleado = e.idempleado AND e.idpersona = pe.idpersona AND f.idfactura = d.idfactura;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS newVenta;
DELIMITER //
CREATE PROCEDURE newVenta(xidrg int, xfecha date, xcantidad int,xprecio float(6,2))
BEGIN 
	declare xsuma float(6,2);
	declare xtotal float(6,2);
	declare xcant int;
	declare xsumcant int;
	INSERT INTO ventas (IdRG,Fecha,Cantidad,Precio) VALUES (xidrg,xfecha,xcantidad,xprecio);
	SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
	SELECT Cantidad INTO xcant FROM registrogalpones WHERE IdRG = xidrg;
		set xsuma = xtotal + xprecio;
		set xsumcant =  xcant - xcantidad;
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
	UPDATE registrogalpones set Cantidad = xsumcant where IdRG = xidrg;
END //
DELIMITER ;


drop PROCEDURE if exists putrutas;
DELIMITER //
CREATE PROCEDURE putrutas(xchofer varchar(45), xsalida varchar(45), xdestino varchar(45))
BEGIN
	declare idch int;
	declare ids int;
	declare idd int;
	set idch =(select idlinea from linea where chofer = xchofer);
	set ids =(select idubicacion from ubicacion where ubicacion = xsalida);
	set idd =(select idubicacion from ubicacion where ubicacion = xdestino);
	Insert into rutas(idlinea,salida,destino) values(idch,ids,idd);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS newDetalle;
DELIMITER //
CREATE PROCEDURE newDetalle(xidfactura int, xidrg int, xcantidad int, xprecio float(6,2),xtipo int)
BEGIN
	declare suma_cant int;
	declare suma_precio float(6,2);
	INSERT INTO detalle (idfactura, idrg, cantidad, precio, tipo) VALUES (xidfactura, xidrg, xcantidad, xprecio, xtipo);
	SELECT Cantidad INTO @cant FROM registrogalpones WHERE IdRG = xidrg;
	SET suma_cant = @cant - xcantidad;
	SELECT Valor INTO @valor FROM registrogalpones WHERE IdRG = xidrg;
	SET suma_precio = @valor + (xcantidad * xprecio);
	UPDATE registrogalpones set Cantidad = suma_cant, Valor = suma_precio where IdRG = xidrg;
END //
DELIMITER ;

SELECT PrecioUnitario into @preciou FROM productos WHERE IdProducto = xidproducto;
		set xsuma = xtotal - (@preciou * xcantidad);
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;

DROP PROCEDURE IF EXISTS deleteVenta;
DELIMITER //
CREATE PROCEDURE deleteVenta(xid INT,xprecio float(6,2), xidrg int, xcantidad int)
BEGIN 
	declare xtotal float(6,2);
	declare xsuma float(6,2);
	declare xcant int;
	declare xsumcant int;
	SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
	SELECT Cantidad INTO xcant FROM registrogalpones WHERE IdRG = xidrg;
	set xsuma = xtotal - xprecio;
	set xsumcant =  xcant + xcantidad;
	UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;	
	UPDATE registrogalpones set Cantidad = xsumcant where IdRG = xidrg;	
	delete from ventas WHERE IdVenta = xid;
END //
DELIMITER ;



--------------------------------- LOGIN
/*
DROP PROCEDURE IF EXISTS login;
DELIMITER //
CREATE PROCEDURE login(xuser varchar(50), xpass varchar(50))
BEGIN 
  DECLARE xid INT;
  SELECT IdUsuario INTO xid FROM usuarios WHERE user = xuser AND pass = xpass;  
  IF ISNULL(xid)THEN SELECT 0 as state;
  ELSE SELECT 1 as state;
  END IF;
END //
DELIMITER ;
*/

DROP PROCEDURE IF EXISTS login;
DELIMITER //
CREATE PROCEDURE login(xuser varchar(50), xpass varchar(50))
BEGIN 
	DECLARE xid INT;
  	SELECT IdUsuario INTO xid FROM usuarios WHERE user = xuser AND pass = xpass;  
  	SELECT IdEmpleado,Tipo, IF(ISNULL(xid),0,1) as state from usuarios WHERE user = xuser AND pass = xpass AND Vita=1;
END //
DELIMITER ;


---------------------------------------------------------------------




DROP PROCEDURE IF EXISTS editContratista;
DELIMITER //
CREATE PROCEDURE editContratista(xid INT, xnombre VARCHAR(30),xruc VARCHAR(12))
BEGIN 
	UPDATE encargado SET nombre=UPPER(xnombre), ruc = UPPER(xruc) WHERE id_encargado = xid;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteContratista;
DELIMITER //
CREATE PROCEDURE deleteContratista(xid INT)
BEGIN 
	delete from encargado WHERE id_encargado = xid;
END //
DELIMITER ;


#RECURSO-------------------


DROP PROCEDURE IF EXISTS newTipoItem;
DELIMITER //
CREATE PROCEDURE newTipoItem( xnombre VARCHAR(45))
BEGIN 
	INSERT INTO tipoitem (Nombre) VALUES (UPPER(xnombre));
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editRecurso;
DELIMITER //
CREATE PROCEDURE editRecurso(xid INT, xrecurso VARCHAR(30),xprecio float(10,2), xmedida VARCHAR(5))
BEGIN 
	UPDATE recursos SET nombre=UPPER(xrecurso), precio = xprecio, medida=UPPER(xmedida) WHERE id_recurso = xid;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteRecurso;
DELIMITER //
CREATE PROCEDURE deleteRecurso(xid INT)
BEGIN 
	delete from recursos WHERE id_recurso = xid;
END //
DELIMITER ;

#TRANSPORTE-------------------

DROP PROCEDURE IF EXISTS newTransporte;
DELIMITER //
CREATE PROCEDURE newTransporte( xrecurso VARCHAR(30),xprecio float(10,2), xdistancia int)
BEGIN 
	DECLARE xid INT;
	SELECT id_recurso INTO xid FROM recursos WHERE nombre = UPPER(xrecurso) limit 1;
	INSERT INTO transporte (id_recurso, precio, distancia) VALUES (xid, xprecio, xdistancia);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editTransporte;
DELIMITER //
CREATE PROCEDURE editTransporte(xid INT, xrecurso VARCHAR(30),xprecio float(10,2), xdistancia int)
BEGIN 
	DECLARE id_rec INT;
	SELECT id_recurso INTO id_rec FROM recursos WHERE nombre = UPPER(xrecurso) limit 1;
	UPDATE transporte SET id_recurso = id_rec, precio = xprecio, distancia = xdistancia WHERE id_transporte = xid;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteTransporte;
DELIMITER //
CREATE PROCEDURE deleteTransporte(xid INT)
BEGIN 
	delete from transporte WHERE id_transporte = xid;
END //
DELIMITER ;

#OBRA __________________________________________

DROP PROCEDURE IF EXISTS newObra;
DELIMITER //
CREATE PROCEDURE newObra( xid_encargado int, xnombre VARCHAR(30),xpresupuesto float(10,2), xf_ini date, xf_fin date)
BEGIN 
	INSERT INTO obra (id_encargado, nombre, presupuesto,f_ini,f_fin) VALUES (xid_encargado, UPPER(xnombre), xpresupuesto, xf_ini, xf_fin);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS editObra;
DELIMITER // 
CREATE PROCEDURE editObra(xid INT,  xid_encargado int, xnombre VARCHAR(30),xpresupuesto float(10,2), xf_ini date, xf_fin date)
BEGIN
	UPDATE obra SET id_encargado = xid_encargado, nombre = UPPER(xnombre), presupuesto = xpresupuesto, f_ini = xf_ini , f_ini = xf_fin WHERE id_obra = xid;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteObra;
DELIMITER //
CREATE PROCEDURE deleteObra(xid INT)
BEGIN 
	delete from obra WHERE id_obra = xid;
END //
DELIMITER ;

#TAREA --------------------------------------------

DROP PROCEDURE IF EXISTS newTarea;
DELIMITER //
CREATE PROCEDURE newTarea( xid_obra int, xdescripcion VARCHAR(30),xid_recurso int, xcantidad int, xf_ini date, xf_fin date, xtransporte int, xdistancia int)
BEGIN 
	declare xsuma int;
	declare precio_recurso float;
	declare precio_transporte float;
	declare xid_tarea int;
	SELECT recursos.precio INTO precio_recurso from recursos where recursos.id_recurso = xid_recurso limit 1;
	SELECT transporte.precio INTO precio_transporte from transporte where transporte.id_recurso = xid_recurso limit 1;
	set xsuma=0;
	IF xtransporte = 1 THEN
		set xsuma = (precio_recurso * xcantidad) + (precio_transporte * xdistancia);
	elseif xtransporte = 0 THEN
		set xsuma = (precio_recurso * xcantidad);
	END IF;
	INSERT INTO tareas (id_obra,descripcion,id_recurso,cantidad,f_ini,f_fin,transporte,distancia,suma) VALUES (xid_obra, UPPER(xdescripcion), xid_recurso, xcantidad, xf_ini, xf_fin, xtransporte,xdistancia,xsuma);
	SELECT tareas.id_tarea into xid_tarea from tareas where tareas.id_obra = xid_obra and tareas.id_recurso = xid_recurso limit 1;
	insert into control (id_tarea) values (xid_tarea);
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS editTarea;
DELIMITER // 
CREATE PROCEDURE editTarea(xid INT,  xid_obra int, xdescripcion VARCHAR(30),xid_recurso int, xcantidad int, xf_ini date, xf_fin date, xtransporte int, xdistancia int)
BEGIN
	declare xsuma int;
	declare precio_recurso float;
	declare precio_transporte float;
	SELECT recursos.precio INTO precio_recurso from recursos where recursos.id_recurso = xid_recurso limit 1;
	SELECT transporte.precio INTO precio_transporte from transporte where transporte.id_recurso = xid_recurso limit 1;
	set xsuma=0;
	IF xtransporte = 1 THEN
		set xsuma = (precio_recurso * xcantidad) + (precio_transporte * xdistancia);
	elseif xtransporte = 0 THEN
		set xsuma = (precio_recurso * xcantidad);
	END IF;
	UPDATE tareas SET id_obra = xid_obra, descripcion = UPPER(xdescripcion), id_recurso = xid_recurso, cantidad = xcantidad , f_ini = xf_ini, f_fin = xf_fin, transporte = xtransporte , distancia = xdistancia , suma = xsuma WHERE id_tarea = xid;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS deleteTarea;
DELIMITER //
CREATE PROCEDURE deleteTarea(xid INT)
BEGIN 
	delete from tareas WHERE id_tarea = xid;
	delete from control WHERE id_tarea = xid;

END //
DELIMITER ;


#CONTROL -----------------------------------------------------------

DROP PROCEDURE IF EXISTS editControl;
DELIMITER //
CREATE PROCEDURE editControl( xid_tarea int,xid_recurso int, xcantidad int, xf_ini date, xf_fin date, xtransporte int, xdistancia int)
BEGIN 
	declare xsuma int;
	declare precio_recurso float;
	declare precio_transporte float;
	SELECT recursos.precio INTO precio_recurso from recursos where recursos.id_recurso = xid_recurso limit 1;
	SELECT transporte.precio INTO precio_transporte from transporte where transporte.id_recurso = xid_recurso limit 1;
	set xsuma=0;
	IF xtransporte = 1 THEN
		set xsuma = (precio_recurso * xcantidad) + (precio_transporte * xdistancia);
	elseif xtransporte = 0 THEN
		set xsuma = (precio_recurso * xcantidad);
	END IF;
	UPDATE control SET  cantidad = xcantidad , f_ini = xf_ini, f_fin = xf_fin, transporte = xtransporte , distancia = xdistancia , suma = xsuma WHERE control.id_tarea = xid_tarea;
END //
DELIMITER ;