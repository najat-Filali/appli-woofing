LOAD DATA LOCAL INFILE 'chantier.csv'
INTO TABLE chantier
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
(id, date_debut,date_fin, nbr_pers_inscrites, type, nbr_pers_presentes,living_place_id);