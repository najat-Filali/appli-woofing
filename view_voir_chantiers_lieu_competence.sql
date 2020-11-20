CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `simplon`@`localhost` 
    SQL SECURITY DEFINER
VIEW `db_woofing`.`voir_chantiers_lieu_competence` AS
    SELECT 
        `c`.`date_debut` AS `date_debut`,
        `c`.`date_fin` AS `date_fin`,
        `c`.`type_chantier` AS `type_chantier`,
        `lp`.`ville` AS `ville`,
        `lp`.`pays` AS `pays`,
        `a`.`nom` AS `type_activite`,
        GROUP_CONCAT(`co`.`nom`
            SEPARATOR ' - ') AS `competences_demandees`,
        `co`.`niveau` AS `niveau_demande`
    FROM
        (((`db_woofing`.`chantier` `c`
        JOIN `db_woofing`.`living_place` `lp` ON (`c`.`id_1` = `lp`.`id`))
        JOIN `db_woofing`.`activite` `a` ON (`lp`.`id` = `a`.`id`))
        JOIN `db_woofing`.`competence` `co` ON (`co`.`id` = `a`.`id`))
    GROUP BY `c`.`type_chantier`