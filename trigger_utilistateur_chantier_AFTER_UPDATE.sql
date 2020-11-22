CREATE DEFINER=`simplon`@`localhost` TRIGGER `db_woofing`.`utilistateur_chantier_AFTER_UPDATE` AFTER UPDATE ON `utilistateur_chantier` FOR EACH ROW
BEGIN

	DECLARE id INT; 
	select id into id From chantier where id=id ; 
	call inscription_chantier(id); 
    
END