
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

-- --------------------------------------------------------

--
-- Structure de la table `activite`
--

CREATE TABLE `activite` (
  `id` int(11) NOT NULL,
  `nom` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `activite_competence`
--

CREATE TABLE `activite_competence` (
  `id_activite` int(11) NOT NULL,
  `id_competence` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Structure de la table `chantier_activite`
--

CREATE TABLE `chantier_activite` (
  `id_activite` int(11) NOT NULL,
  `id_chantier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `competence`
--

CREATE TABLE `competence` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `niveau` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur_competence`
--

CREATE TABLE `utilisateur_competence` (
  `id_comp` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- Structure de la vue `voir_chantiers_lieu_competence`
--
DROP TABLE IF EXISTS `voir_chantiers_lieu_competence`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplon`@`localhost` SQL SECURITY DEFINER VIEW `voir_chantiers_lieu_competence`  AS  select `c`.`date_debut` AS `date_debut`,`c`.`date_fin` AS `date_fin`,`c`.`type_chantier` AS `type_chantier`,`lp`.`ville` AS `ville`,`lp`.`pays` AS `pays`,`a`.`nom` AS `type_activite`,group_concat(`co`.`nom` separator ' - ') AS `competences_demandees`,`co`.`niveau` AS `niveau_demande` from (((`chantier` `c` join `living_place` `lp` on(`c`.`id_place` = `lp`.`id`)) join `activite` `a` on(`lp`.`id` = `a`.`id`)) join `competence` `co` on(`co`.`id` = `a`.`id`)) group by `c`.`type_chantier` ;

-- --------------------------------------------------------

--
-- Structure de la vue `voir_hotes_lieu`
--
DROP TABLE IF EXISTS `voir_hotes_lieu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplon`@`localhost` SQL SECURITY DEFINER VIEW `voir_hotes_lieu`  AS  select `u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`email` AS `email`,`lp`.`type` AS `type`,`lp`.`capacite` AS `capacite`,`lp`.`adresse` AS `adresse`,`lp`.`code_postal` AS `code_postal`,`lp`.`ville` AS `ville`,`lp`.`pays` AS `pays` from ((`utilisateur` `u` left join `utilistateur_living_place` `ulp` on(`ulp`.`id_user` = `u`.`id`)) left join `living_place` `lp` on(`lp`.`id` = `ulp`.`id_place`)) where `u`.`is_host` = 1 ;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `chantier`
--
ALTER TABLE `chantier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `competence`
--
ALTER TABLE `competence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `living_place`
--
ALTER TABLE `living_place`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
