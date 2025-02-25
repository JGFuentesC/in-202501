-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema oltp
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema oltp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `oltp` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `oltp` ;

-- -----------------------------------------------------
-- Table `oltp`.`tbl_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_user` (
  `id_user` INT NULL DEFAULT NULL,
  `uuid` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `oltp`.`tbl_card`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_card` (
  `uuid` CHAR(36) NOT NULL,
  `uuid_user` CHAR(36) NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  INDEX `fk_user_card_idx` (`uuid_user` ASC) VISIBLE,
  CONSTRAINT `fk_user_card`
    FOREIGN KEY (`uuid_user`)
    REFERENCES `oltp`.`tbl_user` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `oltp`.`tbl_error`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_error` (
  `error_desc` VARCHAR(20) NULL DEFAULT NULL,
  `uuid` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `oltp`.`tbl_txn_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_txn_type` (
  `txn_type` VARCHAR(18) NULL DEFAULT NULL,
  `uuid` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `oltp`.`tbl_state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_state` (
  `merchant_state` VARCHAR(24) NULL DEFAULT NULL,
  `uuid` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `oltp`.`tbl_mcc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_mcc` (
  `id_mcc` CHAR(4) NULL DEFAULT NULL,
  `mcc_description` VARCHAR(200) NULL DEFAULT NULL,
  `uuid` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



-- -----------------------------------------------------
-- Table `oltp`.`tbl_error_txn`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_error_txn` (
  `uuid` CHAR(36) NOT NULL,
  `uuid_error` CHAR(36) NOT NULL,
  PRIMARY KEY (`uuid`, `uuid_error`),
  INDEX `fk_txn_idx` (`uuid_error` ASC) VISIBLE,
  CONSTRAINT `fk_txn_error`
    FOREIGN KEY (`uuid_error`)
    REFERENCES `oltp`.`tbl_error` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_txn`
    FOREIGN KEY (`uuid`)
    REFERENCES `oltp`.`tbl_txn` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `oltp`.`tbl_txn`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oltp`.`tbl_txn` (
  `uuid` CHAR(36) NOT NULL,
  `c_amt` FLOAT NULL DEFAULT NULL,
  `b_fraud` TINYINT(1) NULL DEFAULT NULL,
  `dt_timestamp` DATETIME NULL DEFAULT NULL,
  `uuid_user` CHAR(36) NULL DEFAULT NULL,
  `uuid_txn_type` CHAR(36) NULL DEFAULT NULL,
  `uuid_state` CHAR(36) NULL DEFAULT NULL,
  `uuid_mcc` CHAR(36) NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  INDEX `fk_user_idx` (`uuid_user` ASC) VISIBLE,
  INDEX `fk_txt_type_idx` (`uuid_txn_type` ASC) VISIBLE,
  INDEX `fk_state_idx` (`uuid_state` ASC) VISIBLE,
  INDEX `fk_mcc_idx` (`uuid_mcc` ASC) VISIBLE,
  CONSTRAINT `fk_user`
    FOREIGN KEY (`uuid_user`)
    REFERENCES `oltp`.`tbl_user` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_txt_type`
    FOREIGN KEY (`uuid_txn_type`)
    REFERENCES `oltp`.`tbl_txn_type` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_state`
    FOREIGN KEY (`uuid_state`)
    REFERENCES `oltp`.`tbl_state` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mcc`
    FOREIGN KEY (`uuid_mcc`)
    REFERENCES `oltp`.`tbl_mcc` (`uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

