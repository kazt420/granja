
-- Base de datos: `granja`
CREATE SCHEMA IF NOT EXISTS `granja` DEFAULT CHARACTER SET latin1 ;
USE `granja` ;


--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE IF NOT EXISTS `clientes` (
  `IdCliente` int(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` int(3) NOT NULL,
  `RUC` int(13) NOT NULL,
  `Vita` int(1) DEFAULT NULL,
  PRIMARY KEY (`IdCliente`),
  KEY `IdPersona_idx` (`IdPersona`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle`
--

CREATE TABLE IF NOT EXISTS `detalle` (
  `IdDetalle` int(5) NOT NULL AUTO_INCREMENT,
  `IdFactura` int(5) NOT NULL,
  `IdRG` int(11) NOT NULL,
  `Cantidad` int(6) NOT NULL,
  `Precio` double(5,2) NOT NULL,
  `tipo` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdDetalle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE IF NOT EXISTS `empleados` (
  `IdEMpleado` int(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` int(3) NOT NULL,
  `Sueldo` double(6,2) NOT NULL,
  `Cargo` varchar(20) NOT NULL,
  `Vita` int(1) NOT NULL,
  PRIMARY KEY (`IdEMpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE IF NOT EXISTS `factura` (
  `IdFactura` int(10) NOT NULL AUTO_INCREMENT,
  `IdCliente` int(3) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  `iva` float(4,2) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`IdFactura`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `galpones`
--

CREATE TABLE IF NOT EXISTS `galpones` (
  `IdGalpon` int(3) NOT NULL AUTO_INCREMENT,
  `Capacidad` int(11) NOT NULL,
  `Estado` tinyint(1) NOT NULL,
  `Activo` int(1) NOT NULL,
  PRIMARY KEY (`IdGalpon`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE IF NOT EXISTS `gastos` (
  `IdGasto` int(5) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(20) NOT NULL,
  `Vita` int(1) DEFAULT NULL,
  PRIMARY KEY (`IdGasto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medidas`
--

CREATE TABLE IF NOT EXISTS `medidas` (
  `IdMedidas` int(3) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(10) NOT NULL,
  `medida` varchar(5) NOT NULL,
  `vita` int(1) NOT NULL,
  PRIMARY KEY (`IdMedidas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mortalidad`
--

CREATE TABLE IF NOT EXISTS `mortalidad` (
  `IdMort` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha` datetime NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `IdRG` int(11) NOT NULL,
  `Tipo` int(11) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  `Comentario` varchar(30) NOT NULL,
  PRIMARY KEY (`IdMort`),
  UNIQUE KEY `IdMort` (`IdMort`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE IF NOT EXISTS `personas` (
  `IdPersona` int(3) NOT NULL AUTO_INCREMENT,
  `Apellidos` varchar(25) NOT NULL,
  `Nombres` varchar(25) NOT NULL,
  `Ci` int(10) NOT NULL,
  `Telefono` int(15) NOT NULL,
  `Correo` varchar(30) NOT NULL,
  `Direccion` varchar(30) NOT NULL,
  PRIMARY KEY (`IdPersona`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios`
--

CREATE TABLE IF NOT EXISTS `precios` (
  `valor` float(6,2) DEFAULT NULL,
  `nombre` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `precios`
--

INSERT INTO `precios` (`valor`, `nombre`) VALUES
(0.90, 'PIE'),
(1.25, 'FAENADO'),
(12.00, 'IVA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presentacion`
--

CREATE TABLE IF NOT EXISTS `presentacion` (
  `IdPresentacion` int(3) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `vita` int(1) NOT NULL,
  PRIMARY KEY (`IdPresentacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE IF NOT EXISTS `productos` (
  `IdProducto` int(5) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(25) DEFAULT NULL,
  `PrecioUnitario` float(5,2) NOT NULL,
  `Peso` float(5,2) NOT NULL,
  `IdPresentacion` int(3) NOT NULL,
  `IdMedidas` int(3) NOT NULL,
  `vita` int(1) DEFAULT NULL,
  PRIMARY KEY (`IdProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroalimentacion`
--

CREATE TABLE IF NOT EXISTS `registroalimentacion` (
  `IdRA` int(5) NOT NULL AUTO_INCREMENT,
  `IdRG` int(5) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Cantidad` int(7) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  `IdProducto` int(5) NOT NULL,
  `Observacion` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`IdRA`),
  UNIQUE KEY `IdRA` (`IdRA`),
  UNIQUE KEY `IdRA_2` (`IdRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registrogalpones`
--

CREATE TABLE IF NOT EXISTS `registrogalpones` (
  `IdRG` int(11) NOT NULL AUTO_INCREMENT,
  `IdGalpon` int(11) NOT NULL,
  `FechaInicio` datetime NOT NULL,
  `FechaFin` datetime NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Valor` double(6,2) NOT NULL,
  `Estado` int(2) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  PRIMARY KEY (`IdRG`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registrogastos`
--

CREATE TABLE IF NOT EXISTS `registrogastos` (
  `IdRegGast` int(5) NOT NULL AUTO_INCREMENT,
  `IdGasto` int(5) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Precio` float(6,2) NOT NULL,
  `IdRG` int(5) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  `Observacion` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`IdRegGast`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroveterinario`
--

CREATE TABLE IF NOT EXISTS `registroveterinario` (
  `IdRegVet` int(5) NOT NULL AUTO_INCREMENT,
  `IdRG` int(5) NOT NULL,
  `IdVeterinario` int(3) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Observacion` varchar(30) NOT NULL,
  `IdVacuna` int(2) NOT NULL,
  `IdEmpleado` int(3) NOT NULL,
  `Precio` float(6,2) NOT NULL,
  PRIMARY KEY (`IdRegVet`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `IdUsuario` int(3) NOT NULL AUTO_INCREMENT,
  `IdEmpleado` int(3) NOT NULL,
  `User` varchar(30) NOT NULL,
  `Pass` varchar(16) NOT NULL,
  `Tipo` int(11) NOT NULL,
  `Vita` int(1) NOT NULL,
  PRIMARY KEY (`IdUsuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`IdUsuario`, `IdEmpleado`, `User`, `Pass`, `Tipo`, `Vita`) VALUES
(0, 0, 'user', '123', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacunas`
--

CREATE TABLE IF NOT EXISTS `vacunas` (
  `IdVacuna` int(2) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(30) NOT NULL,
  `Estado` int(1) NOT NULL,
  PRIMARY KEY (`IdVacuna`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `veterinario`
--

CREATE TABLE IF NOT EXISTS `veterinario` (
  `IdVeterinario` int(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` int(3) NOT NULL,
  `Empresa` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`IdVeterinario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `IdPersona` FOREIGN KEY (`IdPersona`) REFERENCES `personas` (`IdPersona`) ON DELETE NO ACTION ON UPDATE NO ACTION;





DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `closeRegistroGalpon`( xidrg INT, xFechaFin DATE)
BEGIN 
DECLARE xidgalpon int;
SELECT IdGalpon INTO xidgalpon FROM registrogalpones WHERE IdRG = xidrg;
UPDATE galpones SET Estado = 0 where IdGalpon = xidgalpon;
UPDATE registrogalpones SET Estado = 1, FechaFin = xFechaFin WHERE IdRG = xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAlimentacion`(xid INT,xidproducto int, xcantidad int, xidrg int)
BEGIN 
declare xtotal float(6,2);
declare xsuma float(6,2);
SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
SELECT PrecioUnitario into @preciou FROM productos WHERE IdProducto = xidproducto;
set xsuma = xtotal + (@preciou * xcantidad);
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
delete from registroalimentacion WHERE IdRA = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAlimento`(xid INT)
BEGIN 
UPDATE productos SET vita=0 WHERE IdProducto = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDatoGasto`(xidgasto INT)
BEGIN 
UPDATE gastos SET Vita = 0 WHERE IdGasto = xidgasto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGalpon`(xid INT)
BEGIN 
UPDATE galpones SET Activo=0 WHERE IdGalpon = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGasto`(xid INT,xprecio float(6,2), xidrg int)
BEGIN 
declare xtotal float(6,2);
declare xsuma float(6,2);
SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
set xsuma = xtotal + xprecio;
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
delete from registrogastos WHERE IdRegGast = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMedida`(xid INT)
BEGIN 
UPDATE medidas SET vita=0 WHERE IdMedidas = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMortalidad`(xid INT,xidrg INT, xcantidad INT,xtipo int)
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteNomina`(xid INT)
BEGIN 
UPDATE empleados SET Vita=0 WHERE IdEmpleado = xid;
UPDATE usuarios SET Vita=0 WHERE IdEmpleado = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePresentacino`(xid INT)
BEGIN 
UPDATE presentacion SET vita=0 WHERE idpresentacion = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePresentacion`(xid INT)
BEGIN 
UPDATE presentacion SET vita=0 WHERE idpresentacion = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRegVet`(xidregvet INT,xidrg int, xprecio float(6,2))
BEGIN 
declare xsuma float(6,2);
SELECT Valor INTO @xvalor FROM registrogalpones WHERE IdRG = xidrg;
set xsuma = @xvalor + xprecio;
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
delete from registroveterinario WHERE IdRegVet = xidregvet;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVacuna`(xid INT)
BEGIN 
UPDATE vacunas SET Estado=0 WHERE IdVacuna = xid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVenta`(xid INT,xprecio float(6,2), xidrg int, xcantidad int)
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editAlimentacion`(xidra INT,xidrg int, xfecha datetime, xcantidad int, xidempleado int, xidproducto int, xobservacion varchar(30))
BEGIN 
UPDATE registroalimentacion SET IdRA = xidra, IdRG = xidrg, Fecha=xfecha, Cantidad = xcantidad, IdEmpleado = xIdEmpleado, IdProducto = xidproducto, Observacion = xobservacion WHERE IdRA = xidra and IdRG=xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editAlimento`(xidproducto INT, xnombre varchar(25), xpreciou FLOAT(5,2), xpeso float(5,2), xidpresentacion int(3),xidmedida int(3))
BEGIN 
UPDATE productos SET Descripcion = upper(xnombre), Peso =xpeso, IdPresentacion = xidpresentacion, IdMedidas = xidmedida WHERE IdProducto = xidproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editCliente`(xidveterinario int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xruc varchar(10))
BEGIN 
  UPDATE clientes SET RUC = xruc WHERE IdVeterinario = xidveterinario AND IdPersona = xidpersona;
  UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editMedida`(xidmedida INT, xnombre VARCHAR(10), xmedida VARCHAR(5))
BEGIN 
UPDATE medidas SET Nombre = upper(xnombre), medida = UPPER(xmedida) WHERE IdMedidas = xidmedida;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editMortalidad`(xidmort INT, xfecha date,xcantidad int, xidrg int,xtipo int)
BEGIN 
UPDATE mortalidad SET Fecha = xfecha, Cantidad = xcantidad, Tipo=xtipo WHERE IdMort = xidmort and IdRG=xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editNomina`(xidempleado int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(20))
BEGIN 
UPDATE empleados SET Sueldo = xsueldo, Cargo = UPPER(xcargo) WHERE IdEmpleado = xidempleado AND IdPersona = xidpersona;
UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editPrecio`(xvalor float(6,2),xnombre varchar(10))
BEGIN 
UPDATE precios SET valor = xvalor WHERE nombre = xnombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editPresentacion`(xidpresentacion INT, xnombre VARCHAR(30))
BEGIN 
UPDATE presentacion SET Nombre = upper(xnombre) WHERE idpresentacion = xidpresentacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editRegGast`(xidreggast INT,xidgasto int, xfecha date,xprecio float(6,2), xidrg int)
BEGIN 
UPDATE registrogastos SET IdGasto = xidgasto, Fecha = xfecha, Precio=xprecio WHERE IdRegGast = xidreggast and IdRG=xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editUsuario`(xidempleado int(1), xuser varchar(16), xpass varchar(16), xnewpass varchar(16))
BEGIN 
SELECT count(*) INTO @existeusuario from usuarios where IdEmpleado = xidempleado and user = xuser and pass = xpass;
IF(SELECT @existeusuario = 1) THEN
UPDATE usuarios SET pass = xnewpass WHERE user = xuser and pass = xpass;
Else 
SELECT @existeusuario existeusuario;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editVacuna`(xidvacuna INT, xnombre VARCHAR(30))
BEGIN 
UPDATE vacunas SET Nombre = xnombre WHERE IdVacuna = xidvacuna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editVeterinario`(xidveterinario int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xempresa varchar(30))
BEGIN 
UPDATE VETERINARIO SET Empresa = UPPER(xempresa) WHERE IdVeterinario = xidveterinario AND IdPersona = xidpersona;
UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = UPPER(xdireccion) WHERE IdPersona = xidpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getFacturas`()
BEGIN
SELECT f.idfactura,
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGalpones`()
BEGIN 
SELECT * from galpones;
SELECT CASE estado WHEN 0 THEN 'libre' ELSE 'nolibre' END FROM galpones;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRegVet`()
BEGIN
SELECT (SELECT concat (nombres," ", apellidos) FROM personas p, veterinario v, registroveterinario r WHERE p.idpersona = v.idpersona AND v.idveterinario = r.idveterinario)as veterinario, (SELECT concat (nombres," ", apellidos)  FROM personas p, empleados e, registroveterinario r WHERE p.idpersona = e.idpersona AND e.idempleado = r.idempleado)as empleado,IdRegVet,IdRG,registroveterinario.IdVeterinario,Fecha,Observacion,registroveterinario.IdVacuna,vacunas.Nombre,registroveterinario.IdEmpleado,Precio from registroveterinario,vacunas where registroveterinario.IdVacuna = vacunas.IdVacuna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(xuser varchar(50), xpass varchar(50))
BEGIN 
DECLARE xid INT;
  SELECT IdUsuario INTO xid FROM usuarios WHERE user = xuser AND pass = xpass;  
  SELECT IdEmpleado,Tipo, IF(ISNULL(xid),0,1) as state from usuarios WHERE user = xuser AND pass = xpass AND Vita=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newAlimentacion`( xidrg int, xfecha datetime, xcantidad int, xidempleado int, xidproducto int, xobservacion varchar(30))
BEGIN 
declare xsuma float(6,2);
declare xtotal float(6,2);
INSERT INTO registroalimentacion (IdRG,Fecha,Cantidad,IdEmpleado,IdProducto,Observacion) VALUES (xidrg,xfecha,xcantidad,xidempleado,xidproducto,xobservacion);
set xsuma=0;
SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
SELECT PrecioUnitario into @preciou FROM productos WHERE IdProducto = xidproducto;
set xsuma = xtotal - (@preciou * xcantidad);
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newAlimento`( xnombre varchar(25), xpreciou FLOAT(5,2), xpeso float(5,2), xidpresentacion int(3),xidmedida int(3))
BEGIN 
 SELECT count(*) INTO @exist FROM productos WHERE Descripcion = UPPER(xnombre) and peso = xpeso and IdPresentacion = xidpresentacion and IdMedidas = xidmedida;
  IF (SELECT @exist = 0) THEN
    INSERT INTO productos (Descripcion,PrecioUnitario,Peso,IdPresentacion,IdMedidas,vita) VALUES (UPPER(xnombre),xpreciou,xpeso,xidpresentacion,xidmedida,1);
  ELSE
    UPDATE productos SET vita = 1,PrecioUnitario= xpreciou WHERE Descripcion = UPPER(xnombre) and PrecioUnitario = xpreciou and peso = xpeso and IdPresentacion = xidpresentacion and IdMedidas = xidmedida;
  END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newCliente`(xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xruc varchar(10))
BEGIN
  SELECT count(*) INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
  IF ( SELECT @existepersona = 0 ) THEN                                  
    INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xci,xtelefono,xcorreo,xdireccion);
  END IF;

  SELECT IdPersona INTO @idper FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
  SELECT count(*) INTO @existecliente FROM clientes WHERE IdPersona = @idper;
  IF(SELECT @existecliente = 0) THEN
    INSERT INTO clientes (IdPersona,RUC,Vita) VALUES (@idper,xruc,1);
  ELSE
    UPDATE clientes SET RUC=xruc,Vita = 1 WHERE IdPersona = @idper;
    UPDATE personas set Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona= @idper;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newDetalle`(xidfactura int, xidrg int, xcantidad int, xprecio float(6,2),xtipo int)
BEGIN
declare suma_cant int;
declare suma_precio float(6,2);
INSERT INTO detalle (idfactura, idrg, cantidad, precio, tipo) VALUES (xidfactura, xidrg, xcantidad, xprecio, xtipo);
SELECT Cantidad INTO @cant FROM registrogalpones WHERE IdRG = xidrg;
SET suma_cant = @cant - xcantidad;
SELECT Valor INTO @valor FROM registrogalpones WHERE IdRG = xidrg;
SET suma_precio = @valor + (xcantidad * xprecio);
UPDATE registrogalpones set Cantidad = suma_cant, Valor = suma_precio where IdRG = xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newGalpon`( xcapacidad int)
BEGIN 
INSERT INTO galpones (Capacidad,Estado,Activo) VALUES (xcapacidad,0,1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newGasto`( xnombre VARCHAR(20))
BEGIN 
SELECT count(*) INTO @existegasto FROM gastos WHERE Nombre = xnombre;
IF (@existegasto = 1) THEN
UPDATE gastos SET Vita= 1 where Nombre = xnombre;
ELSE
INSERT INTO gastos (Nombre,Vita) VALUES (UPPER(xnombre),1); 
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newMedida`( xnombre varchar(10),xmedida varchar(5))
BEGIN 
 SELECT count(*) INTO @exist FROM medidas WHERE Nombre = UPPER(xnombre) and medida = UPPER(xmedida);
  IF (SELECT @exist = 0) THEN
    INSERT INTO medidas (Nombre,medida,vita) VALUES (UPPER(xnombre),UPPER(xmedida),1);
  ELSE
    UPDATE medidas SET Vita = 1 WHERE Nombre = UPPER(xnombre) and medida = UPPER(xmedida);
  END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newMortalidad`( xfecha date, xcantidad int, xidrg int, xtipo int, xcomentario varchar(30), xidempleado int)
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newNomina`(xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(30), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(20), xtipo int(1), xuser varchar(30))
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newPresentacion`( xnombre varchar(20))
BEGIN 
 SELECT count(*) INTO @exist FROM presentacion WHERE Nombre = UPPER(xnombre);
  IF (SELECT @exist = 0) THEN
    INSERT INTO presentacion (Nombre,Vita) VALUES (UPPER(xnombre),1);
  ELSE
    UPDATE presentacion SET Vita = 1 WHERE Nombre = xnombre;
  END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newRegistroGalpon`( xIdGalpon INT, xFechaInicio DATE, xIdEmpleado INT)
BEGIN 
INSERT INTO registrogalpones (IdGalpon, FechaInicio, FechaFin,Cantidad,Valor,Estado,IdEmpleado) VALUES (xIdGalpon,xFechaInicio,"",0,0,0,xIdEmpleado);
UPDATE galpones SET Estado=1 WHERE IdGalpon = xIdGalpon;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newRegistroGasto`( xidgasto int, xfecha date, xprecio float(6,2), xidrg int, xidempleado int)
BEGIN 
declare xsuma float(6,2);
declare xtotal float(6,2);
INSERT INTO registrogastos (IdGasto,Fecha,Precio,IdRG,IdEmpleado) VALUES (xidgasto,xfecha,xprecio,xidrg,xidempleado);
set xsuma=0;
SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
set xsuma = xtotal - xprecio;
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newRegVet`(xidrg int, xidveterinario int, xfecha datetime, xobservacion varchar(30), xidvacuna int,xidempleado int, xprecio float(6,2))
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newVacuna`( xnombre varchar(20))
BEGIN 
  SELECT count(*) INTO @exist FROM vacunas WHERE Nombre = UPPER(xnombre);
  IF (SELECT @exist = 0) THEN
    INSERT INTO vacunas (Nombre,Estado) VALUES (UPPER(xnombre),1);
  ELSE
    UPDATE vacunas SET Estado = 1 WHERE Nombre = xnombre;
  END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newVenta`(xidrg int, xfecha date, xcantidad int,xprecio float(6,2))
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newVeterinario`(xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xempresa varchar(30))
BEGIN
SELECT count(*)INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
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
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getSumaDetalle`(xid int) RETURNS float(6,2)
    READS SQL DATA
BEGIN
DECLARE sumadetalle float(6,2);
set sumadetalle = 0;
SELECT SUM(cantidad * precio) into sumadetalle from detalle where idfactura = xid; 
RETURN sumadetalle;
END$$

DELIMITER ;

