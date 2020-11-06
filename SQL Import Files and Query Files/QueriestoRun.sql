USE Food_Sense;
SELECT 
    upc_plu_number, customer_id, max(weight)
FROM
    fridge_inventory
WHERE
    customer_id = 1
GROUP BY upc_plu_number;

SELECT 
    upc_plu_number, customer_id, max(weight)
FROM
    fridge_inventory
WHERE
    customer_id = 2
GROUP BY upc_plu_number;

            
CREATE TABLE IF NOT EXISTS `Food_Sense`.`t` (
  `t_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11),
  `upc_plu_number` BIGINT NULL,
  `max_weight` DEC(10, 5),
  `min_weight` DEC(10,5 ) NULL,
  PRIMARY KEY (`t_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `Food_Sense`.`t`(`customer_id`,`upc_plu_number`,`max_weight`, `min_weight`)
SELECT 
		customer_id, upc_plu_number, MAX(weight) AS max_weight, MIN(weight) AS min_weight
        FROM
            fridge_inventory
            GROUP BY upc_plu_number, customer_id;

CREATE TABLE IF NOT EXISTS `Food_Sense`.`aggregation` (
  `t_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11),
  `upc_plu_number` BIGINT NULL,
  `max_weight` DEC(10, 5),
  `min_weight` DEC(10,5 ) NULL,
  `max_date` DATETIME NULL,
  `min_date` DATETIME NULL,
  PRIMARY KEY (`t_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `Food_Sense`.`aggregation`(`customer_id`,`upc_plu_number`,`max_weight`, `min_weight`, `max_date`, `min_date`)
select t.customer_id, t.upc_plu_number, t.max_weight, t.min_weight, b.max_date, c.min_date
from t 
left join (


				SELECT  a.customer_id, a.upc_plu_number, a.max_weight, max(a.purchase_date) as max_date
				FROM
				(
				SELECT
				   a.customer_id, a.upc_plu_number, a.max_weight, b.purchase_date
				   from t a
				   left join fridge_inventory b
				   on a.customer_id = b.customer_id AND a.upc_plu_number = b.upc_plu_number AND  a.max_weight = b.weight
				) a
				group by a.customer_id, a.upc_plu_number, a.max_weight
                ) b
on t.customer_id = b.customer_id and
t.upc_plu_number = b.upc_plu_number and 
t.max_weight = b.max_weight 
left join (


				SELECT  a.customer_id, a.upc_plu_number, a.min_weight, min(a.purchase_date) as min_date
				FROM
				(
				SELECT
				   a.customer_id, a.upc_plu_number, a.min_weight, b.purchase_date
				   from t a
				   left join fridge_inventory b
				   on a.customer_id = b.customer_id AND a.upc_plu_number = b.upc_plu_number AND  a.min_weight = b.weight
				) a
				group by a.customer_id, a.upc_plu_number, a.min_weight
                ) c
on t.customer_id = c.customer_id and
t.upc_plu_number = c.upc_plu_number and 
t.min_weight = c.min_weight; 

CREATE TABLE IF NOT EXISTS `Food_Sense`.`fridge_2` (
  `fridge2_id` int NOT NULL AUTO_INCREMENT,
  `upc_plu_number` BIGINT NULL,
  `weight` DEC(10,5),
  `customer_ID` INT(11),
  `purchase_date` DATETIME NULL,
  `remaining_percentage` DEC(10,5),
  `consumption_rate` DEC(10,5),
  PRIMARY KEY (`fridge2_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SELECT
t_id,
DATEDIFF( max_date, min_date)AS consumption_rate
FROM
aggregation;

INSERT INTO `Food_Sense`.`fridge_2`(`upc_plu_number`,`weight`,`customer_id`, `purchase_date`, `remaining_percentage`, `consumption_rate`)
SELECT
f.upc_plu_Number, 
f.weight,
f.customer_id,
f.purchase_date,
f.weight/a.max_weight as remaining_percentage,
(a.max_weight - a.min_weight)/(a.max_weight * (ABS(DATEDIFF( a.max_date, a.min_date)+ 0.0001) )) AS consumption_rate
FROM fridge_inventory f
INNER JOIN aggregation a
ON f.upc_plu_number = a.upc_plu_number
AND f.customer_id = a.customer_id
ORDER BY f.customer_id AND f.purchase_date AND f.upc_plu_Number DESC;


UPDATE fridge_2
SET consumption_rate = NULL
WHERE consumption_rate = 10000.00000;

SELECT 
f.upc_plu_number,
DATE_ADD(f.purchase_date, INTERVAL 5 DAY) AS suggested_order_date,
f.remaining_percentage,
p.product_name AS suggested_product,
f.customer_id
FROM fridge_2 f
INNER JOIN product p
ON f.upc_plu_number = p.upc_plu_number
WHERE f.remaining_percentage < 0.25;

            
INSERT INTO `Food_Sense`.`grocery_list`(`upc_plu_number`,`suggested_order_date`,`remaining_percentage`, `suggested_product`, `customer_id`)         
SELECT 
f.upc_plu_number,
DATE_ADD(f.purchase_date, INTERVAL 5 DAY) AS suggested_order_date,
f.remaining_percentage,
p.product_name AS suggested_product,
f.customer_id
FROM fridge_2 f
INNER JOIN product p
ON f.upc_plu_number = p.upc_plu_number
WHERE f.remaining_percentage < 0.25;
