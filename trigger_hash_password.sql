DROP TRIGGER IF EXISTS `db_woofing`.`hasher_mdp`;

DELIMITER $$
USE `db_woofing`$$
CREATE DEFINER = CURRENT_USER TRIGGER `db_woofing`.`hasher_mdp` BEFORE INSERT ON `utilisateur` FOR EACH ROW
BEGIN

UPDATE utilisateur
SET password = MD5(password);

END$$
DELIMITER ;