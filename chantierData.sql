LOAD DATA LOCAL INFILE 'chantier.csv'
INTO TABLE chantier
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n' -- ou '\r\n' selon l'ordinateur et le programme utilisés pour créer le fichier
(id, date_debut,date_fin, nbr_pers_inscrites, type, nbr_pers_presentes,living_place_id);