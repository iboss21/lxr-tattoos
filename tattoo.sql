CREATE TABLE `tattoo` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_general_ci',
	`character_id` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_general_ci',
	`tattoo` VARCHAR(5550) NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uc_identifier_character` (`identifier`, `character_id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1029
;
