-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Food_Sense
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Food_Sense
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Food_Sense` DEFAULT CHARACTER SET utf8 ;
USE `Food_Sense` ;

-- -----------------------------------------------------
-- Table `Food_Sense`.`customer_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`customer_table` (
  `customer_id` INT(11) NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `street_address` VARCHAR(45) NULL DEFAULT NULL,
  `city` VARCHAR(45) NULL DEFAULT NULL,
  `state` VARCHAR(45) NULL DEFAULT NULL,
  `zip_code` VARCHAR(45) NULL DEFAULT NULL,
  `dietary_restrictions` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Food_Sense`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`product` (
  `product_id` INT(11) NOT NULL,
  `upc_plu_number` BIGINT(20) NOT NULL,
  `product_name` VARCHAR(250) NULL DEFAULT NULL,
  PRIMARY KEY (`product_id`, `upc_plu_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE  INDEX `fkif_upc_plu_code` ON `Food_Sense`.`product` (`upc_plu_number` ASC);
-- -----------------------------------------------------
-- Table `Food_Sense`.`fridge_inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`fridge_inventory` (
  `inventory_id` INT(11) NOT NULL,
  `upc_plu_Number` BIGINT(20) NOT NULL,
  `weight` DECIMAL(45,4) NULL DEFAULT NULL,
  `customer_id` INT(11) NULL DEFAULT NULL,
  `current_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`inventory_id`),
  INDEX `fkif_customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `fk_upc_plu_Number` (`upc_plu_Number` ASC) VISIBLE,
  CONSTRAINT `fkif_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Food_Sense`.`customer_table` (`customer_id`),
  CONSTRAINT `fkif_upc_plu_code`
    FOREIGN KEY (`upc_plu_Number`)
    REFERENCES `Food_Sense`.`product` (`upc_plu_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Food_Sense`.`grocery_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`grocery_list` (
  `grocery_list_id` INT NOT NULL auto_increment,
  `upc_plu_number` BIGINT NULL,
  `suggested_order_date` DATETIME NULL,
  `remaining_percentage` DEC(10,5) NULL,
  `suggested_product` VARCHAR(200) NULL,
  `customer_id` INT NULL,
  PRIMARY KEY (`grocery_list_id`),
  CONSTRAINT `fk_upc_plu_number_fr_inv`
    FOREIGN KEY (`upc_plu_number`)
    REFERENCES `Food_Sense`.`fridge_inventory` (`upc_plu_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customer_id_cus`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Food_Sense`.`customer_table` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_upc_plu_number_fr_inv` ON `Food_Sense`.`grocery_list` (`upc_plu_number` ASC);
CREATE INDEX `fk_customer_id_cus` ON `Food_Sense`.`grocery_list` (`customer_id` ASC);


-- -----------------------------------------------------
-- Table `Food_Sense`.`store_chain_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`store_chain_info` (
  `store_chain_id` INT(11) NOT NULL,
  `store_chain_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`store_chain_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Food_Sense`.`store_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`store_info` (
  `store_id` INT(11) NOT NULL,
  `store_chain_id` INT(11) NULL DEFAULT NULL,
  `street_address` VARCHAR(45) NULL DEFAULT NULL,
  `city` VARCHAR(45) NULL DEFAULT NULL,
  `state` VARCHAR(45) NULL DEFAULT NULL,
  `zip_code` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`store_id`),
  INDEX `fk_store_chain_id` (`store_chain_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_chain_id`
    FOREIGN KEY (`store_chain_id`)
    REFERENCES `Food_Sense`.`store_chain_info` (`store_chain_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Food_Sense`.`store_inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Food_Sense`.`store_inventory` (
  `store_inventory_id` INT(11) NOT NULL,
  `upc_plu_number` BIGINT(20) NOT NULL,
  `availability` VARCHAR(45) NULL DEFAULT NULL,
  `store_id` INT(11) NOT NULL,
  PRIMARY KEY (`store_inventory_id`),
  INDEX `store_id_idx` (`store_id` ASC) VISIBLE,
  INDEX `upc_plu_number_idx` (`upc_plu_number` ASC) VISIBLE,
  INDEX `fk_upc_plu_number_fridge` (`upc_plu_number` ASC) VISIBLE,
  INDEX `fk_store_id` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `Food_Sense`.`store_info` (`store_id`),
  CONSTRAINT `fk_upc_plu_number_fridge`
    FOREIGN KEY (`upc_plu_number`)
    REFERENCES `Food_Sense`.`fridge_inventory` (`upc_plu_Number`),
  CONSTRAINT `fksi_upc_code`
    FOREIGN KEY (`upc_plu_number`)
    REFERENCES `Food_Sense`.`product` (`upc_plu_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
