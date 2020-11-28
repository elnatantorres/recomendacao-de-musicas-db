SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `RecomendacaoDeMusicas` ;
CREATE SCHEMA IF NOT EXISTS `RecomendacaoDeMusicas` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `RecomendacaoDeMusicas` ;

-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`Usuario` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`Usuario` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `Nome` VARCHAR(80) NOT NULL ,
  `Senha` VARCHAR(45) NULL ,
  `GuidUsuario` CHAR(36) NULL ,
  PRIMARY KEY (`Id`) ,
  UNIQUE INDEX `Nome_Unique_Index` (`Nome` ASC) ,
  UNIQUE INDEX `GuidDeUsuario_Unique_Index` (`GuidUsuario` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`Musica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`Musica` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`Musica` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `Nome` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`Genero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`Genero` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`Genero` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `Nome` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`Id`) ,
  UNIQUE INDEX `Genero_Nome_Unique` (`Nome` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`RegistroMusicaGenero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`RegistroMusicaGenero` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`RegistroMusicaGenero` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `MusicaId` INT NOT NULL ,
  `GeneroId` INT NOT NULL ,
  PRIMARY KEY (`Id`, `GeneroId`) ,
  INDEX `Registro_Genero_FK_idx` (`GeneroId` ASC) ,
  INDEX `Registro_Musica_FK_idx` (`MusicaId` ASC) ,
  CONSTRAINT `Registro_Genero_FK`
    FOREIGN KEY (`GeneroId` )
    REFERENCES `RecomendacaoDeMusicas`.`Genero` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Registro_Musica_FK`
    FOREIGN KEY (`MusicaId` )
    REFERENCES `RecomendacaoDeMusicas`.`Musica` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`PreferenciaGenero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`PreferenciaGenero` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`PreferenciaGenero` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `GuidUsuario` CHAR(36) NOT NULL ,
  `GeneroId` INT NOT NULL ,
  `Ordem` INT NOT NULL ,
  PRIMARY KEY (`Id`) ,
  INDEX `PreferenciaGenero_Usuario_FK_idx` (`GuidUsuario` ASC) ,
  INDEX `PreferenciaGenero_Genero_FK_idx` (`GeneroId` ASC) ,
  CONSTRAINT `PreferenciaGenero_Usuario_FK`
    FOREIGN KEY (`GuidUsuario` )
    REFERENCES `RecomendacaoDeMusicas`.`Usuario` (`GuidUsuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PreferenciaGenero_Genero_FK`
    FOREIGN KEY (`GeneroId` )
    REFERENCES `RecomendacaoDeMusicas`.`Genero` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`PreferenciaMusica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`PreferenciaMusica` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`PreferenciaMusica` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `MusicaId` INT NOT NULL ,
  `Nota` DECIMAL(19, 4) NOT NULL DEFAULT 0 ,
  `GuidUsuario` CHAR(36) NOT NULL ,
  PRIMARY KEY (`Id`) ,
  INDEX `Preferencia_Musica_FK_idx` (`MusicaId` ASC) ,
  INDEX `PreferenciaMusica_Usuario_FK_idx` (`GuidUsuario` ASC) ,
  CONSTRAINT `PreferenciaMusica_Musica_FK`
    FOREIGN KEY (`MusicaId` )
    REFERENCES `RecomendacaoDeMusicas`.`Musica` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PreferenciaMusica_Usuario_FK`
    FOREIGN KEY (`GuidUsuario` )
    REFERENCES `RecomendacaoDeMusicas`.`Usuario` (`GuidUsuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `RecomendacaoDeMusicas`.`RegistroLogin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RecomendacaoDeMusicas`.`registrologin` ;

CREATE  TABLE IF NOT EXISTS `RecomendacaoDeMusicas`.`registrologin` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `UltimoLogin` CHAR(36) NULL ,
  PRIMARY KEY (`Id`) ,
  INDEX `FK_RegistroLogin_Usuario_idx` (`UltimoLogin` ASC) ,
  CONSTRAINT `FK_RegistroLogin_Usuario`
    FOREIGN KEY (`UltimoLogin` )
    REFERENCES `recomendacaodemusicas`.`usuario` (`GuidUsuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

ENGINE = InnoDB;

USE `RecomendacaoDeMusicas` ;

-- -----------------------------------------------------
-- View `RecomendacaoDeMusicas`.`Posto`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `RecomendacaoDeMusicas`.`Posto` ;
USE `RecomendacaoDeMusicas`;
CREATE VIEW `RecomendacaoDeMusicas`.`Posto` 
AS 
SELECT 
	MusicaId, 
	SUM(Nota)/COUNT(*) AS 'Nota'
FROM 
	RecomendacaoDeMusicas.PreferenciaMusica
GROUP BY
	MusicaId
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;