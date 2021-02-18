-- MySQL Script generated by MySQL Workbench
-- Sat Jan 25 11:59:07 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema granja
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema granja
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `granja` DEFAULT CHARACTER SET latin1 ;
USE `granja` ;

-- -----------------------------------------------------
-- Table `granja`.`personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`personas` ;

CREATE TABLE IF NOT EXISTS `granja`.`personas` (
  `IdPersona` INT(3) NOT NULL AUTO_INCREMENT,
  `Apellidos` VARCHAR(25) NOT NULL,
  `Nombres` VARCHAR(25) NOT NULL,
  `Ci` INT(10) NOT NULL,
  `Telefono` INT(15) NOT NULL,
  `Correo` VARCHAR(30) NOT NULL,
  `Direccion` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`IdPersona`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`clientes` ;

CREATE TABLE IF NOT EXISTS `granja`.`clientes` (
  `IdCliente` INT(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` INT(3) NOT NULL,
  `RUC` INT(13) NOT NULL,
  PRIMARY KEY (`IdCliente`),
  INDEX `IdPersona_idx` (`IdPersona` ASC) ,
  CONSTRAINT `IdPersona`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `granja`.`personas` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`empleados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`empleados` ;

CREATE TABLE IF NOT EXISTS `granja`.`empleados` (
  `IdEmpleado` INT(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` INT(3) NOT NULL,
  `Sueldo` FLOAT(6,2) NOT NULL,
  `Cargo` VARCHAR(20) NOT NULL,
  `Vita` INT(1) NOT NULL,
  PRIMARY KEY (`IdEmpleado`),
  INDEX `IdPersona_idx2` (`IdPersona` ASC) ,
  CONSTRAINT `IdPersona`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `granja`.`personas` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`galpones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`galpones` ;

CREATE TABLE IF NOT EXISTS `granja`.`galpones` (
  `IdGalpon` INT(3) NOT NULL AUTO_INCREMENT,
  `Capacidad` INT(11) NOT NULL,
  `Estado` TINYINT(1) NOT NULL,
  `Activo` INT(1) NOT NULL,
  PRIMARY KEY (`IdGalpon`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`gastos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`gastos` ;

CREATE TABLE IF NOT EXISTS `granja`.`gastos` (
  `IdGasto` INT(5) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(20) NOT NULL,
  `Vita` INT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`IdGasto`))
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`registrogalpones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`registrogalpones` ;

CREATE TABLE IF NOT EXISTS `granja`.`registrogalpones` (
  `IdRG` INT(11) NOT NULL AUTO_INCREMENT,
  `IdGalpon` INT(11) NOT NULL,
  `FechaInicio` DATE NOT NULL,
  `FechaFin` DATE NOT NULL,
  `Cantidad` INT(11) NOT NULL,
  `Valor` FLOAT(6,2) NOT NULL,
  `Estado` INT(2) NOT NULL,
  `IdEmpleado` INT(3) NOT NULL,
  PRIMARY KEY (`IdRG`),
  INDEX `IdGalpon_idx` (`IdGalpon` ASC) ,
  INDEX `IdEmpleado_idx` (`IdEmpleado` ASC) ,
  CONSTRAINT `IdGalpon`
    FOREIGN KEY (`IdGalpon`)
    REFERENCES `granja`.`galpones` (`IdGalpon`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`mortalidad`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`mortalidad` ;

CREATE TABLE IF NOT EXISTS `granja`.`mortalidad` (
  `IdMort` INT(11) NOT NULL AUTO_INCREMENT,
  `Fecha` DATE NOT NULL,
  `Cantidad` INT(11) NOT NULL,
  `IdRG` INT(11) NOT NULL,
  `Tipo` INT(11) NOT NULL,
  `IdEmpleado` INT(3) NOT NULL,
  `Comentario` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`IdMort`),
  UNIQUE INDEX `IdMort` (`IdMort` ASC) ,
  INDEX `IdEmpleado_idx2` (`IdEmpleado` ASC) ,
  INDEX `IdRG_idx` (`IdRG` ASC) ,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdRG`
    FOREIGN KEY (`IdRG`)
    REFERENCES `granja`.`registrogalpones` (`IdRG`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`presentacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`presentacion` ;

CREATE TABLE IF NOT EXISTS `granja`.`presentacion` (
  `IdPresentacion` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL,
  `presentacioncol` VARCHAR(45) NULL,
  PRIMARY KEY (`IdPresentacion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `granja`.`medidas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`medidas` ;

CREATE TABLE IF NOT EXISTS `granja`.`medidas` (
  `IdMedidas` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(10) NULL,
  PRIMARY KEY (`IdMedidas`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `granja`.`productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`productos` ;

CREATE TABLE IF NOT EXISTS `granja`.`productos` (
  `IdProducto` INT(5) NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(15) NOT NULL,
  `PrecioUnitario` FLOAT(5,2) NULL,
  `peso` INT NULL,
  `IdPresentacion` INT NULL,
  `IdMedida` INT NULL,
  PRIMARY KEY (`IdProducto`),
  INDEX `IdPresentacion_idx` (`IdPresentacion` ASC) ,
  INDEX `IdMedida_idx` (`IdMedida` ASC) ,
  CONSTRAINT `IdPresentacion`
    FOREIGN KEY (`IdPresentacion`)
    REFERENCES `granja`.`presentacion` (`IdPresentacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdMedida`
    FOREIGN KEY (`IdMedida`)
    REFERENCES `granja`.`medidas` (`IdMedidas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`registroalimentacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`registroalimentacion` ;

CREATE TABLE IF NOT EXISTS `granja`.`registroalimentacion` (
  `IdRA` INT(6) NOT NULL,
  `Cantidad` FLOAT(6,1) NOT NULL,
  `IdRG` INT(11) NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `IdEmpleado` INT(3) NOT NULL,
  `IdProducto` INT NULL,
  PRIMARY KEY (`IdRA`),
  UNIQUE INDEX `IdRA` (`IdRA` ASC) ,
  UNIQUE INDEX `IdRA_2` (`IdRA` ASC) ,
  INDEX `IdRG_idx2` (`IdRG` ASC) ,
  INDEX `IdEmpleado_idx3` (`IdEmpleado` ASC) ,
  INDEX `IdProducto_idx` (`IdProducto` ASC) ,
  CONSTRAINT `IdRG`
    FOREIGN KEY (`IdRG`)
    REFERENCES `granja`.`registrogalpones` (`IdRG`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdProducto`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `granja`.`productos` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`registrogastos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`registrogastos` ;

CREATE TABLE IF NOT EXISTS `granja`.`registrogastos` (
  `IdRegGast` INT NOT NULL AUTO_INCREMENT,
  `IdRG` INT(5) NOT NULL,
  `IdGasto` INT(5) NOT NULL,
  `IdEmpleado` INT(3) NOT NULL,
  `Fecha` DATE NULL,
  `Valor` DOUBLE(5,2) NULL,
  INDEX `IdGasto_idx` (`IdGasto` ASC) ,
  PRIMARY KEY (`IdRegGast`),
  INDEX `IdRG_idx3` (`IdRG` ASC) ,
  INDEX `IdEmpleado_idx4` (`IdEmpleado` ASC) ,
  CONSTRAINT `IdGasto`
    FOREIGN KEY (`IdGasto`)
    REFERENCES `granja`.`gastos` (`IdGasto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdRG`
    FOREIGN KEY (`IdRG`)
    REFERENCES `granja`.`registrogalpones` (`IdRG`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`veterinario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`veterinario` ;

CREATE TABLE IF NOT EXISTS `granja`.`veterinario` (
  `IdVeterinario` INT(3) NOT NULL AUTO_INCREMENT,
  `IdPersona` INT(3) NOT NULL,
  `Empresa` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`IdVeterinario`),
  INDEX `IdPersona_idx3` (`IdPersona` ASC) ,
  CONSTRAINT `IdPersona`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `granja`.`personas` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`vacunas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`vacunas` ;

CREATE TABLE IF NOT EXISTS `granja`.`vacunas` (
  `IdVacuna` INT(2) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(30) NOT NULL,
  `Estado` INT(1) NOT NULL,
  PRIMARY KEY (`IdVacuna`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`registroveterinario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`registroveterinario` ;

CREATE TABLE IF NOT EXISTS `granja`.`registroveterinario` (
  `IdRegVet` INT(5) NOT NULL AUTO_INCREMENT,
  `IdRG` INT(5) NOT NULL,
  `IdVeterinario` INT(3) NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `Observacion` VARCHAR(30) NOT NULL,
  `IdVacuna` INT(2) NOT NULL,
  `IdEmpleado` INT(3) NOT NULL,
  `Precio` FLOAT(6,2) NOT NULL,
  PRIMARY KEY (`IdRegVet`),
  INDEX `IdVeterinario_idx` (`IdVeterinario` ASC) ,
  INDEX `IdRg_idx` (`IdRG` ASC) ,
  INDEX `IdVacuna_idx` (`IdVacuna` ASC) ,
  INDEX `IdEmpleado_idx5` (`IdEmpleado` ASC) ,
  CONSTRAINT `IdVeterinario`
    FOREIGN KEY (`IdVeterinario`)
    REFERENCES `granja`.`veterinario` (`IdVeterinario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdRg`
    FOREIGN KEY (`IdRG`)
    REFERENCES `granja`.`registrogalpones` (`IdRG`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdVacuna`
    FOREIGN KEY (`IdVacuna`)
    REFERENCES `granja`.`vacunas` (`IdVacuna`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`usuarios` ;

CREATE TABLE IF NOT EXISTS `granja`.`usuarios` (
  `IdUsuario` INT(3) NOT NULL AUTO_INCREMENT,
  `IdEmpleado` INT(3) NOT NULL,
  `User` VARCHAR(30) NOT NULL,
  `Pass` VARCHAR(16) NOT NULL,
  `Tipo` INT(1) NOT NULL,
  `Vita` INT(1) NOT NULL,
  PRIMARY KEY (`IdUsuario`),
  INDEX `IdEmpledo_idx` (`IdEmpleado` ASC) ,
  CONSTRAINT `IdEmpledo`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `granja`.`factura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`factura` ;

CREATE TABLE IF NOT EXISTS `granja`.`factura` (
  `IdFactura` INT NOT NULL AUTO_INCREMENT,
  `IdCliente` INT(3) NULL,
  `IdEmpleado` INT(3) NULL,
  `iva` INT(2) NULL,
  PRIMARY KEY (`IdFactura`),
  INDEX `IdCliente_idx` (`IdCliente` ASC) ,
  INDEX `IdEmpleado_idx6` (`IdEmpleado` ASC) ,
  CONSTRAINT `IdCliente`
    FOREIGN KEY (`IdCliente`)
    REFERENCES `granja`.`clientes` (`IdCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdEmpleado`
    FOREIGN KEY (`IdEmpleado`)
    REFERENCES `granja`.`empleados` (`IdEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `granja`.`detalle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`detalle` ;

CREATE TABLE IF NOT EXISTS `granja`.`detalle` (
  `IdDetalle` INT NOT NULL AUTO_INCREMENT,
  `IdFactura` INT NULL,
  `IdRG` INT NULL,
  `Cantidad` INT NULL,
  `Precio` DOUBLE(5,2) NULL,
  PRIMARY KEY (`IdDetalle`),
  INDEX `IdFactura_idx` (`IdFactura` ASC) ,
  INDEX `IdRG_idx4` (`IdRG` ASC) ,
  CONSTRAINT `IdFactura`
    FOREIGN KEY (`IdFactura`)
    REFERENCES `granja`.`factura` (`IdFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdRG`
    FOREIGN KEY (`IdRG`)
    REFERENCES `granja`.`registrogalpones` (`IdRG`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `granja`.`iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `granja`.`iva` ;

CREATE TABLE IF NOT EXISTS `granja`.`iva` (
  `valor` INT NOT NULL,
  PRIMARY KEY (`valor`))
ENGINE = InnoDB;

USE `granja` ;

-- -----------------------------------------------------
-- procedure closeRegistroGalpon
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`closeRegistroGalpon`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `closeRegistroGalpon`( xidrg INT, xFechaFin DATE)
BEGIN 
DECLARE xidgalpon int;
SELECT IdGalpon INTO xidgalpon FROM registrogalpones WHERE IdRG = xidrg;
UPDATE galpones SET Estado = 0 where IdGalpon = xidgalpon;
UPDATE registrogalpones SET Estado = 1, FechaFin = xFechaFin WHERE IdRG = xidrg;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteDatoGasto
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteDatoGasto`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDatoGasto`(xidgasto INT)
BEGIN 
UPDATE gastos SET Vita = 0 WHERE IdGasto = xidgasto;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteGalpon
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteGalpon`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGalpon`(xid INT)
BEGIN 
UPDATE galpones SET Activo=0 WHERE IdGalpon = xid;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteGasto
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteGasto`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGasto`(xid INT,xprecio float(6,2), xidrg int)
BEGIN 
declare xtotal float(6,2);
declare xsuma float(6,2);
SELECT Valor INTO xtotal FROM registrogalpones WHERE IdRG = xidrg;
set xsuma = xtotal + xprecio;
UPDATE registrogalpones set Valor = xsuma where IdRG = xidrg;
delete from registrogastos WHERE IdRegGast = xid;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteMortalidad
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteMortalidad`;

DELIMITER $$
USE `granja`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteNomina
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteNomina`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteNomina`(xid INT)
BEGIN 
UPDATE empleados SET Vita=0 WHERE IdEmpleado = xid;
UPDATE usuarios SET Vita=0 WHERE IdEmpleado = xid;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteVacuna
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteVacuna`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVacuna`(xid INT)
BEGIN 
UPDATE vacunas SET Estado=0 WHERE IdVacuna = xid;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteVenta
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`deleteVenta`;

DELIMITER $$
USE `granja`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure editMortalidad
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editMortalidad`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editMortalidad`(xidmort INT, xfecha date,xcantidad int, xidrg int,xtipo int)
BEGIN 
UPDATE mortalidad SET Fecha = xfecha, Cantidad = xcantidad, Tipo=xtipo WHERE IdMort = xidmort and IdRG=xidrg;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure editNomina
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editNomina`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editNomina`(xidempleado int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(10))
BEGIN 
UPDATE empleados SET Sueldo = xsueldo, Cargo = xcargo WHERE IdEmpleado = xidempleado AND IdPersona = xidpersona;
UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure editRegGast
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editRegGast`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editRegGast`(xidreggast INT,xidgasto int, xfecha date,xprecio float(6,2), xidrg int)
BEGIN 
UPDATE registrogastos SET IdGasto = xidgasto, Fecha = xfecha, Precio=xprecio WHERE IdRegGast = xidreggast and IdRG=xidrg;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure editUsuario
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editUsuario`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editUsuario`(xidempleado int(1), xuser varchar(16), xpass varchar(16), xnewpass varchar(16))
BEGIN 
SELECT count(*) INTO @existeusuario from usuarios where IdEmpleado = xidempleado and user = xuser and pass = xpass;
IF(SELECT @existeusuario = 1) THEN
UPDATE usuarios SET pass = xnewpass WHERE user = xuser and pass = xpass;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure editVacuna
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editVacuna`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editVacuna`(xidvacuna INT, xnombre VARCHAR(30))
BEGIN 
UPDATE vacunas SET Nombre = xnombre WHERE IdVacuna = xidvacuna;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure editVeterinario
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`editVeterinario`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editVeterinario`(xidveterinario int(3), xidpersona int(3),xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xempresa varchar(10))
BEGIN 
UPDATE VETERINARIO SET Empresa = xempresa WHERE IdVeterinario = xidveterinario AND IdPersona = xidpersona;
UPDATE personas SET Apellidos = UPPER(xapellidos), Nombres = UPPER(xnombres), Ci = xci, Telefono = xtelefono, Correo = xcorreo, Direccion = xdireccion WHERE IdPersona = xidpersona;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getGalpones
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`getGalpones`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getGalpones`()
BEGIN 
SELECT * from galpones;
SELECT CASE estado WHEN 0 THEN 'libre' ELSE 'nolibre' END FROM galpones;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`login`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(xuser varchar(50), xpass varchar(50))
BEGIN 
DECLARE xid INT;
  SELECT IdUsuario INTO xid FROM usuarios WHERE user = xuser AND pass = xpass;  
  SELECT IdEmpleado,Tipo, IF(ISNULL(xid),0,1) as state from usuarios WHERE user = xuser AND pass = xpass AND Vita=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newGalpon
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newGalpon`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newGalpon`( xcapacidad int)
BEGIN 
INSERT INTO galpones (Capacidad,Estado,Activo) VALUES (xcapacidad,0,1);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newGasto
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newGasto`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newGasto`( xnombre VARCHAR(20))
BEGIN 
SELECT count(*) INTO @existegasto FROM gastos WHERE Nombre = xnombre;
IF (@existegasto = 1) THEN
UPDATE gastos SET Vita= 1 where Nombre = xnombre;
ELSE
INSERT INTO gastos (Nombre,Vita) VALUES (UPPER(xnombre),1); 
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newMortalidad
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newMortalidad`;

DELIMITER $$
USE `granja`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure newNomina
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newNomina`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newNomina`(xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(30), xdireccion varchar(30), xsueldo float(6,2), xcargo varchar(20), xtipo int(1), xuser varchar(30))
BEGIN
SELECT count(*)INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
IF ( SELECT @existepersona = 0 ) THEN                                  
INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xci,xtelefono,xcorreo,xdireccion);
END IF;

SELECT IdPersona INTO @idper FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
SELECT count(*) INTO @existeempleado FROM EMPLEADOS WHERE IdPersona = @idper;
IF(SELECT @existeempleado = 0) THEN
INSERT INTO EMPLEADOS (IdPersona,Sueldo,Cargo) VALUES (@idper,xsueldo,xcargo);
SELECT IdEmpleado INTO @idemple FROM empleados WHERE IdPersona = @idper;
INSERT INTO usuarios(IdEmpleado,User,Pass,Tipo) VALUES (@idemple,xuser,xci,xtipo);
ELSE
UPDATE empleados SET Sueldo=xsueldo,Cargo=xcargo WHERE IdPersona = @idper;
END IF;


SELECT @existepersona existepersona, @existeempleado existeempleado;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newRegVet
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newRegVet`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newRegVet`(xidrg int, xidveterinario int, xfecha date, xhora time, xobservacion varchar(30), xidvacuna int,xidempleado int, xprecio float(6,2))
BEGIN 
INSERT INTO registroveterinario (IdRG,IdVeterinario,Fecha,Hora,Observacion,IdVacuna,IdEmpleado,Precio) VALUES (xidrg,xidveterinario,xfecha,xhora,xobservacion,xidvacuna,xidempleado,xprecio);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newRegistroGalpon
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newRegistroGalpon`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newRegistroGalpon`( xIdGalpon INT, xFechaInicio DATE, xIdEmpleado INT)
BEGIN 
INSERT INTO registrogalpones (IdGalpon, FechaInicio, FechaFin,Cantidad,Valor,Estado,IdEmpleado) VALUES (xIdGalpon,xFechaInicio,"",0,0,0,xIdEmpleado);
UPDATE galpones SET Estado=1 WHERE IdGalpon = xIdGalpon;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newRegistroGasto
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newRegistroGasto`;

DELIMITER $$
USE `granja`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure newVacuna
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newVacuna`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newVacuna`( xnombre varchar(20))
BEGIN 
INSERT INTO vacunas (Nombre,Estado) VALUES (xnombre,1);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure newVenta
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newVenta`;

DELIMITER $$
USE `granja`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure newVeterinario
-- -----------------------------------------------------

USE `granja`;
DROP procedure IF EXISTS `granja`.`newVeterinario`;

DELIMITER $$
USE `granja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newVeterinario`(xapellidos varchar(25), xnombres varchar(25), xci int(10), xtelefono int(15), xcorreo varchar(20), xdireccion varchar(30), xempresa varchar(10))
BEGIN
SELECT count(*)INTO @existepersona FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
IF ( SELECT @existepersona = 0 ) THEN                                  
INSERT INTO personas (Apellidos,Nombres,Ci,Telefono,Correo,Direccion) VALUES (UPPER(xapellidos),UPPER(xnombres),xci,xtelefono,xcorreo,xdireccion);
END IF;

SELECT IdPersona INTO @idper FROM personas WHERE Ci = xci AND Apellidos = xapellidos AND Nombres = xnombres;
SELECT count(*) INTO @existeempleado FROM VETERINARIO WHERE IdPersona = @idper;
IF(SELECT @existeempleado = 0) THEN
INSERT INTO VETERINARIO (IdPersona,Empresa) VALUES (@idper,xempresa);
ELSE
UPDATE VETERINARIO SET Empresa=xempresa WHERE IdPersona = @idper;
END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
