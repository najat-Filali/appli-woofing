CREATE DEFINER=`simplon`@`localhost` PROCEDURE `inscription_chantier`(IN id_chantier INT)
BEGIN

declare inscrits int ; 
declare capacite int ; 

SELECT nbr_pers_inscrites INTO inscrits FROM chantier where id= id_chantier; 
SELECT capacite INTO capacite from living_place lp inner join chantier c on c.id_place =lp.id where c.id = id_chantier; 

if inscrits < capacite then 
	UPDATE chantier SET nbr_pers_inscrites =  nbr_pers_inscrites + 1 , nbr_pers_presentes = nbr_pers_presentes +1 WHERE id = id_chantier; 
 	
end if ;
END