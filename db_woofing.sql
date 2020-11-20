-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 20 nov. 2020 à 17:04
-- Version du serveur :  10.4.11-MariaDB
-- Version de PHP : 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `db_woofing`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`simplon`@`localhost` PROCEDURE `inscription_chantier` (IN `id_chantier` INT)  BEGIN
declare inscrits int ; 
declare capacite int ; 

SELECT nbr_pers_inscrites INTO inscrits FROM chantier where id= id_chantier; 
SELECT capacite INTO capacite from living_place lp inner join chantier c on c.id_place =lp.id where c.id_place = id_chantier limit 1; 

if inscrits < capacite then 
	UPDATE chantier SET nbr_pers_inscrites =  nbr_pers_inscrites + 1 WHERE id = id_chantier; 
 	
end if ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `activite`
--

CREATE TABLE `activite` (
  `id` int(11) NOT NULL,
  `nom` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `activite`
--

INSERT INTO `activite` (`id`, `nom`) VALUES
(1, 'jardinage'),
(2, 'bricolage'),
(3, 'maconnerie');

-- --------------------------------------------------------

--
-- Structure de la table `activite_competence`
--

CREATE TABLE `activite_competence` (
  `id_activite` int(11) NOT NULL,
  `id_competence` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `activite_competence`
--

INSERT INTO `activite_competence` (`id_activite`, `id_competence`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1);

-- --------------------------------------------------------

--
-- Structure de la table `chantier`
--

CREATE TABLE `chantier` (
  `id` int(11) NOT NULL,
  `type_chantier` varchar(50) NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `nbr_pers_inscrites` smallint(6) DEFAULT NULL,
  `nbr_pers_presentes` smallint(6) DEFAULT NULL,
  `id_place` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `chantier`
--

INSERT INTO `chantier` (`id`, `type_chantier`, `date_debut`, `date_fin`, `nbr_pers_inscrites`, `nbr_pers_presentes`, `id_place`) VALUES
(1, 'Plants et semis', '2021-02-12', '2021-11-02', 1, 0, 1),
(2, 'Refaire toiture', '2021-05-06', '2021-05-23', 3, 0, 2),
(3, 'construction terrasses de culture', '2021-05-06', '2021-05-23', 2, 0, 1),
(4, 'maconnerie', '2021-02-12', '2021-11-02', 2, 0, 2),
(5, 'maconnerie', '2021-05-06', '2021-05-23', 2, 0, 1),
(6, 'maconnerie', '2021-05-06', '2021-05-23', 2, 0, 1),
(7, 'Bricolage', '2021-05-06', '2021-05-23', 2, 0, 1),
(8, 'plomberie', '2021-04-25', '2021-04-30', 1, 0, 1);

--
-- Déclencheurs `chantier`
--
DELIMITER $$
CREATE TRIGGER `chantier_AFTER_UPDATE` AFTER UPDATE ON `chantier` FOR EACH ROW BEGIN

DECLARE presence TINYINT; 
DECLARE id_user INT; 
DECLARE id_chantier INT; 

Select is_present  INTO presence from utilistateur_chantier where id_user=id_user and id_chantier=id_chantier; 
select id INTO id_user from utilisateur; 
    
    IF presence = 1 THEN
        call montee_competence(id_user); 
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `chantier_activite`
--

CREATE TABLE `chantier_activite` (
  `id_activite` int(11) NOT NULL,
  `id_chantier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `chantier_activite`
--

INSERT INTO `chantier_activite` (`id_activite`, `id_chantier`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 3),
(3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `competence`
--

CREATE TABLE `competence` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `niveau` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `competence`
--

INSERT INTO `competence` (`id`, `nom`, `niveau`) VALUES
(1, 'zinguerie', 1),
(2, 'elagage', 0),
(3, 'cuisine', 2),
(4, 'zinguerie', 1),
(5, 'elagage', 0),
(6, 'maraichage', 3),
(7, 'cuisine', 2),
(8, 'zinguerie', 1),
(9, 'elagage', 0),
(10, 'maraichage', 3),
(11, 'cuisine', 2);

-- --------------------------------------------------------

--
-- Structure de la table `living_place`
--

CREATE TABLE `living_place` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `capacite` smallint(6) NOT NULL,
  `adresse` varchar(50) NOT NULL,
  `code_postal` int(11) NOT NULL,
  `ville` varchar(50) NOT NULL,
  `pays` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `living_place`
--

INSERT INTO `living_place` (`id`, `type`, `capacite`, `adresse`, `code_postal`, `ville`, `pays`) VALUES
(1, 'ferme', 5, 'avenue du rocher des fées', 48400, 'Florac', 'France'),
(2, 'Auberge', 8, 'rue Victor Hugo', 48620, 'Ste-Enimie', 'France');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_naissance` date NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) NOT NULL,
  `is_host` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `first_name`, `last_name`, `date_naissance`, `email`, `password`, `is_host`) VALUES
(1, 'Pierre', 'Solignac', '1986-05-06', 'pierre@ici.fr', '1234', 1),
(22, 'Pierre', 'Solignac', '1986-05-06', 'pierre@gmail.fr', '1234', 1),
(23, 'Paul', 'Solignac', '1980-11-12', 'paul@ici.fr', '1234', 0),
(24, 'Jacques', 'Henry', '1991-08-15', 'jacques@la.fr', '1234', 1),
(25, 'Edouard', 'Maurel', '1973-04-05', 'EdM@ici.fr', '1234', 0);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur_competence`
--

CREATE TABLE `utilisateur_competence` (
  `id_comp` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateur_competence`
--

INSERT INTO `utilisateur_competence` (`id_comp`, `id_user`) VALUES
(1, 1),
(1, 24),
(2, 22),
(3, 23);

-- --------------------------------------------------------

--
-- Structure de la table `utilistateur_chantier`
--

CREATE TABLE `utilistateur_chantier` (
  `id_chantier` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `ask_chantier` tinyint(4) DEFAULT NULL,
  `is_present` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilistateur_chantier`
--

INSERT INTO `utilistateur_chantier` (`id_chantier`, `id_user`, `ask_chantier`, `is_present`) VALUES
(1, 25, NULL, 0),
(2, 1, 1, 1),
(2, 23, 1, 0),
(3, 22, NULL, 0),
(5, 1, NULL, 0);

-- --------------------------------------------------------

--
-- Structure de la table `utilistateur_living_place`
--

CREATE TABLE `utilistateur_living_place` (
  `id_place` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilistateur_living_place`
--

INSERT INTO `utilistateur_living_place` (`id_place`, `id_user`) VALUES
(1, 1),
(2, 22),
(2, 23);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `voir_chantiers_lieu_competence`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `voir_chantiers_lieu_competence` (
`date_debut` date
,`date_fin` date
,`type_chantier` varchar(50)
,`ville` varchar(50)
,`pays` varchar(50)
,`type_activite` varchar(55)
,`competences_demandees` mediumtext
,`niveau_demande` int(11)
);

-- --------------------------------------------------------

--
-- Structure de la vue `voir_chantiers_lieu_competence`
--
DROP TABLE IF EXISTS `voir_chantiers_lieu_competence`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplon`@`localhost` SQL SECURITY DEFINER VIEW `voir_chantiers_lieu_competence`  AS  select `c`.`date_debut` AS `date_debut`,`c`.`date_fin` AS `date_fin`,`c`.`type_chantier` AS `type_chantier`,`lp`.`ville` AS `ville`,`lp`.`pays` AS `pays`,`a`.`nom` AS `type_activite`,group_concat(`co`.`nom` separator ' - ') AS `competences_demandees`,`co`.`niveau` AS `niveau_demande` from (((`chantier` `c` join `living_place` `lp` on(`c`.`id_place` = `lp`.`id`)) join `activite` `a` on(`lp`.`id` = `a`.`id`)) join `competence` `co` on(`co`.`id` = `a`.`id`)) group by `c`.`type_chantier` ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `activite`
--
ALTER TABLE `activite`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `activite_competence`
--
ALTER TABLE `activite_competence`
  ADD PRIMARY KEY (`id_activite`,`id_competence`),
  ADD KEY `id_1` (`id_competence`);

--
-- Index pour la table `chantier`
--
ALTER TABLE `chantier`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_1` (`id_place`);

--
-- Index pour la table `chantier_activite`
--
ALTER TABLE `chantier_activite`
  ADD PRIMARY KEY (`id_activite`,`id_chantier`),
  ADD KEY `id_1` (`id_chantier`);

--
-- Index pour la table `competence`
--
ALTER TABLE `competence`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `living_place`
--
ALTER TABLE `living_place`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `utilisateur_competence`
--
ALTER TABLE `utilisateur_competence`
  ADD PRIMARY KEY (`id_comp`,`id_user`),
  ADD KEY `id_1` (`id_user`);

--
-- Index pour la table `utilistateur_chantier`
--
ALTER TABLE `utilistateur_chantier`
  ADD PRIMARY KEY (`id_chantier`,`id_user`),
  ADD KEY `id_1` (`id_user`);

--
-- Index pour la table `utilistateur_living_place`
--
ALTER TABLE `utilistateur_living_place`
  ADD PRIMARY KEY (`id_place`,`id_user`),
  ADD KEY `utilistateur_living_place_ibfk_2` (`id_user`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `activite`
--
ALTER TABLE `activite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `chantier`
--
ALTER TABLE `chantier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `competence`
--
ALTER TABLE `competence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `living_place`
--
ALTER TABLE `living_place`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `activite_competence`
--
ALTER TABLE `activite_competence`
  ADD CONSTRAINT `activite_competence_ibfk_1` FOREIGN KEY (`id_activite`) REFERENCES `activite` (`id`),
  ADD CONSTRAINT `activite_competence_ibfk_2` FOREIGN KEY (`id_competence`) REFERENCES `competence` (`id`);

--
-- Contraintes pour la table `chantier`
--
ALTER TABLE `chantier`
  ADD CONSTRAINT `chantier_ibfk_1` FOREIGN KEY (`id_place`) REFERENCES `living_place` (`id`);

--
-- Contraintes pour la table `chantier_activite`
--
ALTER TABLE `chantier_activite`
  ADD CONSTRAINT `chantier_activite_ibfk_1` FOREIGN KEY (`id_activite`) REFERENCES `activite` (`id`),
  ADD CONSTRAINT `chantier_activite_ibfk_2` FOREIGN KEY (`id_chantier`) REFERENCES `chantier` (`id`);

--
-- Contraintes pour la table `utilisateur_competence`
--
ALTER TABLE `utilisateur_competence`
  ADD CONSTRAINT `utilisateur_competence_ibfk_1` FOREIGN KEY (`id_comp`) REFERENCES `competence` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `utilisateur_competence_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`);

--
-- Contraintes pour la table `utilistateur_chantier`
--
ALTER TABLE `utilistateur_chantier`
  ADD CONSTRAINT `utilistateur_chantier_ibfk_1` FOREIGN KEY (`id_chantier`) REFERENCES `chantier` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `utilistateur_chantier_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`);

--
-- Contraintes pour la table `utilistateur_living_place`
--
ALTER TABLE `utilistateur_living_place`
  ADD CONSTRAINT `utilistateur_living_place_ibfk_1` FOREIGN KEY (`id_place`) REFERENCES `living_place` (`id`),
  ADD CONSTRAINT `utilistateur_living_place_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
