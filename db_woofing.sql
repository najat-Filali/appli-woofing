
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
SELECT capacite INTO capacite from living_place lp inner join chantier c on c.id_place =lp.id where c.id = id_chantier; 

if inscrits < capacite then 
	UPDATE chantier SET nbr_pers_inscrites =  nbr_pers_inscrites + 1 , nbr_pers_presentes = nbr_pers_presentes +1 WHERE id = id_chantier; 
 	
end if ;
END$$

CREATE DEFINER=`simplon`@`localhost` PROCEDURE `montee_competence` (IN `id_user` INT)  BEGIN

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
-- RELATIONS POUR LA TABLE `activite`:
--

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
-- RELATIONS POUR LA TABLE `activite_competence`:
--   `id_activite`
--       `activite` -> `id`
--   `id_competence`
--       `competence` -> `id`
--

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
-- RELATIONS POUR LA TABLE `chantier`:
--   `id_place`
--       `living_place` -> `id`
--

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

-- --------------------------------------------------------

--
-- Structure de la table `chantier_activite`
--

CREATE TABLE `chantier_activite` (
  `id_activite` int(11) NOT NULL,
  `id_chantier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONS POUR LA TABLE `chantier_activite`:
--   `id_activite`
--       `activite` -> `id`
--   `id_chantier`
--       `chantier` -> `id`
--

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
-- RELATIONS POUR LA TABLE `competence`:
--

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
-- RELATIONS POUR LA TABLE `living_place`:
--

--
-- Déchargement des données de la table `living_place`
--

INSERT INTO `living_place` (`id`, `type`, `capacite`, `adresse`, `code_postal`, `ville`, `pays`) VALUES
(1, 'ferme', 5, 'avenue du rocher des fées', 48400, 'Florac', 'France'),
(2, 'Auberge', 8, 'rue Victor Hugo', 48620, 'Ste-Enimie', 'France'),
(3, 'Exploitation horticole', 3, 'via cupello 74', 86047, 'Santa Croce di Magliano ', 'Italie');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_naissance` date NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `is_host` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONS POUR LA TABLE `utilisateur`:
--

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `first_name`, `last_name`, `date_naissance`, `email`, `password`, `is_host`) VALUES
(1, 'Pierre', 'Solignac', '1986-05-06', 'pierre@ici.fr', '1234', 1),
(22, 'Pierre', 'Solignac', '1986-05-06', 'pierre@gmail.fr', '1234', 1),
(23, 'Paul', 'Solignac', '1980-11-12', 'paul@ici.fr', '1234', 0),
(24, 'Jacques', 'Henry', '1991-08-15', 'jacques@la.fr', '1234', 1),
(25, 'Edouard', 'Maurel', '1973-04-05', 'EdM@ici.fr', '1234', 0);

--
-- Déclencheurs `utilisateur`
--
DELIMITER $$
CREATE TRIGGER `hasher_mdp` BEFORE INSERT ON `utilisateur` FOR EACH ROW BEGIN

UPDATE utilisateur SET NEW.password = MD5(password);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur_competence`
--

CREATE TABLE `utilisateur_competence` (
  `id_comp` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONS POUR LA TABLE `utilisateur_competence`:
--   `id_comp`
--       `competence` -> `id`
--   `id_user`
--       `utilisateur` -> `id`
--

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
  `ask_chantier` tinyint(1) DEFAULT 0,
  `is_present` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONS POUR LA TABLE `utilistateur_chantier`:
--   `id_chantier`
--       `chantier` -> `id`
--   `id_user`
--       `utilisateur` -> `id`
--

--
-- Déchargement des données de la table `utilistateur_chantier`
--

INSERT INTO `utilistateur_chantier` (`id_chantier`, `id_user`, `ask_chantier`, `is_present`) VALUES
(1, 25, NULL, 0),
(2, 1, 1, 1),
(2, 23, 1, 0),
(3, 22, NULL, 0),
(5, 1, NULL, 0);

--
-- Déclencheurs `utilistateur_chantier`
--
DELIMITER $$
CREATE TRIGGER `utilistateur_chantier_AFTER_UPDATE` AFTER UPDATE ON `utilistateur_chantier` FOR EACH ROW BEGIN

	DECLARE id INT; 
	select id into id From chantier where id=id ; 
	call inscription_chantier(id); 
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `utilistateur_living_place`
--

CREATE TABLE `utilistateur_living_place` (
  `id_place` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONS POUR LA TABLE `utilistateur_living_place`:
--   `id_place`
--       `living_place` -> `id`
--   `id_user`
--       `utilisateur` -> `id`
--

--
-- Déchargement des données de la table `utilistateur_living_place`
--

INSERT INTO `utilistateur_living_place` (`id_place`, `id_user`) VALUES
(1, 1),
(2, 22),
(2, 23),
(3, 24);

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
-- Doublure de structure pour la vue `voir_hotes_lieu`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `voir_hotes_lieu` (
`first_name` varchar(50)
,`last_name` varchar(50)
,`email` varchar(50)
,`type` varchar(50)
,`capacite` smallint(6)
,`adresse` varchar(50)
,`code_postal` int(11)
,`ville` varchar(50)
,`pays` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la vue `voir_chantiers_lieu_competence` exportée comme une table
--
DROP TABLE IF EXISTS `voir_chantiers_lieu_competence`;
CREATE TABLE`voir_chantiers_lieu_competence`(
    `date_debut` date NOT NULL,
    `date_fin` date NOT NULL,
    `type_chantier` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `ville` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `pays` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `type_activite` varchar(55) COLLATE utf8mb4_general_ci NOT NULL,
    `competences_demandees` mediumtext COLLATE utf8mb4_general_ci DEFAULT NULL,
    `niveau_demande` int(11) DEFAULT NULL
);

-- --------------------------------------------------------

--
-- Structure de la vue `voir_hotes_lieu` exportée comme une table
--
DROP TABLE IF EXISTS `voir_hotes_lieu`;
CREATE TABLE`voir_hotes_lieu`(
    `first_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `last_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `email` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
    `type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `capacite` smallint(6) DEFAULT NULL,
    `adresse` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `code_postal` int(11) DEFAULT NULL,
    `ville` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `pays` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
);

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
  ADD KEY `chantier_activite_ibfk_2` (`id_chantier`);

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
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateur_competence`
--
ALTER TABLE `utilisateur_competence`
  ADD PRIMARY KEY (`id_comp`,`id_user`),
  ADD KEY `utilisateur_competence_ibfk_2` (`id_user`);

--
-- Index pour la table `utilistateur_chantier`
--
ALTER TABLE `utilistateur_chantier`
  ADD PRIMARY KEY (`id_chantier`,`id_user`),
  ADD KEY `utilistateur_chantier_ibfk_2` (`id_user`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  ADD CONSTRAINT `chantier_activite_ibfk_1` FOREIGN KEY (`id_activite`) REFERENCES `activite` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `chantier_activite_ibfk_2` FOREIGN KEY (`id_chantier`) REFERENCES `chantier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `utilisateur_competence`
--
ALTER TABLE `utilisateur_competence`
  ADD CONSTRAINT `utilisateur_competence_ibfk_1` FOREIGN KEY (`id_comp`) REFERENCES `competence` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `utilisateur_competence_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `utilistateur_chantier`
--
ALTER TABLE `utilistateur_chantier`
  ADD CONSTRAINT `utilistateur_chantier_ibfk_1` FOREIGN KEY (`id_chantier`) REFERENCES `chantier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `utilistateur_chantier_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `utilistateur_living_place`
--
ALTER TABLE `utilistateur_living_place`
  ADD CONSTRAINT `utilistateur_living_place_ibfk_1` FOREIGN KEY (`id_place`) REFERENCES `living_place` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `utilistateur_living_place_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `utilisateur` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
