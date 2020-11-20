use db_woofing; 

CREATE TABLE activite(
   id INT NOT NULL AUTO_INCREMENT,
   nom VARCHAR(55) NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE competence(
    id INT NOT NULL AUTO_INCREMENT,
   nom VARCHAR(50) NOT NULL,
   niveau INT,
   PRIMARY KEY(id)
);

CREATE TABLE living_place(
    id INT NOT NULL AUTO_INCREMENT,
   type VARCHAR(50) NOT NULL,
   capacite SMALLINT NOT NULL,
   adresse VARCHAR(50) NOT NULL,
   code_postal INT NOT NULL,
   ville VARCHAR(50) NOT NULL,
   pays VARCHAR(50) NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE utilisateur(
    id INT NOT NULL AUTO_INCREMENT,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   date_naissance DATE NOT NULL,
   email VARCHAR(50) UNIQUE,
   password VARCHAR(50) NOT NULL,
   is_host TINYINT NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE chantier(
    id INT NOT NULL AUTO_INCREMENT,
   type_chantier VARCHAR(50) NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE NOT NULL,
   nbr_pers_inscrites SMALLINT,
   nbr_pers_presentes SMALLINT,
   id_1 INT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY(id_1) REFERENCES living_place(id)
);

CREATE TABLE utilistateur_living_place(
   id INT,
   id_1 INT,
   PRIMARY KEY(id, id_1),
   FOREIGN KEY(id) REFERENCES living_place(id),
   FOREIGN KEY(id_1) REFERENCES utilisateur(id)
);

CREATE TABLE utilisateur_competence(
   id INT,
   id_1 INT,
   PRIMARY KEY(id, id_1),
   FOREIGN KEY(id) REFERENCES competence(id),
   FOREIGN KEY(id_1) REFERENCES utilisateur(id)
);

CREATE TABLE activite_competence(
   id INT,
   id_1 INT,
   PRIMARY KEY(id, id_1),
   FOREIGN KEY(id) REFERENCES activite(id),
   FOREIGN KEY(id_1) REFERENCES competence(id)
);

CREATE TABLE chantier_activite(
   id INT,
   id_1 INT,
   PRIMARY KEY(id, id_1),
   FOREIGN KEY(id) REFERENCES activite(id),
   FOREIGN KEY(id_1) REFERENCES chantier(id)
);

CREATE TABLE utilistateur_chantier(
   id INT,
   id_1 INT,
   ask_chantier TINYINT,
   PRIMARY KEY(id, id_1),
   FOREIGN KEY(id) REFERENCES chantier(id),
   FOREIGN KEY(id_1) REFERENCES utilisateur(id)
);
