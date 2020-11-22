CREATE DEFINER=`simplon`@`localhost` PROCEDURE `montee_competence`(IN id_user INT)
BEGIN

DECLARE level int; 
DECLARE id_comp int; 

select c.niveau into level from utilisateur u 
inner join utilisateur_competence uc on uc.id_user = u.id 
inner join competence c On c.id = uc.id_comp 
where u.id = id_user and c.id = uc.id_comp ; 

select uc.id_comp into id_comp from utilisateur u 
inner join utilisateur_competence uc on uc.id_user = u.id 
inner join competence c On c.id = uc.id_comp 
where u.id = id_user and c.id = uc.id_comp; 


UPDATE competence  SET niveau = level+1  where id = id_comp;

END