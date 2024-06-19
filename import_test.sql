CREATE DATABASE lab_2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE lab_2;

CREATE TABLE `Sector` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `coordinates` tinytext,
  `light_intensity` double,
  `foreign_objects` int,
  `star_object_count` int,
  `unidentified_object_count` int,
  `identified_object__count` int,
  `date_update` datetime,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `Objects` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `type` tinytext,
  `accuracy` float,
  `quantity` int,
  `time` time,
  `date` date,
  `date_update` datetime,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `NaturalObjects` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `type` tinytext,
  `galaxy` tinytext,
  `accuracy` float,
  `light_flux` double,
  `associated_objects` int,
  `date_update` datetime,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `Location` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `earth_position` tinytext,
  `sun_position` tinytext,
  `moon_position` tinytext,
  `date_update` datetime,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `Observation` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `sector_id` int,
  `object_id` int,
  `natural_object_id` int,
  `location_id` int,
  `date_update` datetime,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `Observation` ADD FOREIGN KEY (`sector_id`) REFERENCES `Sector` (`id`);

ALTER TABLE `Observation` ADD FOREIGN KEY (`object_id`) REFERENCES `Objects` (`id`);

ALTER TABLE `Observation` ADD FOREIGN KEY (`natural_object_id`) REFERENCES `NaturalObjects` (`id`);

ALTER TABLE `Observation` ADD FOREIGN KEY (`location_id`) REFERENCES `Location` (`id`);

INSERT INTO `Sector` (`coordinates`, `light_intensity`, `foreign_objects`, `star_object_count`, `unidentified_object_count`, `identified_object__count`, `notes`)
VALUES 
    ('10.123, 20.456', 0.8, 2, 5, 1, 6, 'Sector near Orion Nebula'),
    ('30.789, 40.012', 0.6, 3, 7, 2, 8, 'Sector near Andromeda Galaxy'),
    ('50.234, 60.789', 0.7, 1, 4, 0, 5, 'Sector near Pleiades Cluster');

INSERT INTO `Objects` (`type`, `accuracy`, `quantity`, `time`, `date`, `notes`)
VALUES 
    ('Satellite', 0.95, 1, '12:00:00', '2024-06-01', 'Weather monitoring satellite'),
    ('Space Station', 0.98, 1, '14:30:00', '2024-06-02', 'International Space Station'),
    ('Debris', 0.70, 5, '16:45:00', '2024-06-03', 'Debris from old satellite');

INSERT INTO `NaturalObjects` (`type`, `galaxy`, `accuracy`, `light_flux`, `associated_objects`, `notes`)
VALUES 
    ('Star', 'Milky Way', 0.99, 1.2e+30, 3, 'Nearby star in the Milky Way'),
    ('Planet', 'Milky Way', 0.95, 3.3e+24, 1, 'Planet in the Milky Way galaxy'),
    ('Galaxy', 'Andromeda', 0.90, 5.0e+35, 0, 'Andromeda Galaxy'),
    ('Asteroid', 'Solar System', 0.85, 4.5e+18, 0, 'Asteroid in the asteroid belt'),
    ('Comet', 'Solar System', 0.80, 1.0e+15, 0, 'Comet passing near Earth'),
    ('Nebula', 'Milky Way', 0.88, 2.5e+28, 2, 'Nebula observed in the Milky Way');

INSERT INTO `Location` (`earth_position`, `sun_position`, `moon_position`, `notes`)
VALUES 
    ('10.123, 20.456', '30.789, 40.012', '15.678, 25.123', 'Observation made from Earth to Sun direction'),
    ('30.789, 40.012', '50.234, 60.789', '35.678, 45.123', 'Observation made from Earth'),
    ('50.234, 60.789', '10.123, 20.456', '55.678, 65.123', 'Observation made from Earth to Moon direction');

INSERT INTO `Observation` (`sector_id`, `object_id`, `natural_object_id`, `location_id`, `notes`, `date_update`)
VALUES 
    (1, 1, NULL, 1, 'Weather monitoring satellite observed in sector 1', NOW()),
    (2, 2, NULL, 2, 'International Space Station observed in sector 2', NOW()),
    (3, 3, NULL, 3, 'Debris from old satellite detected in sector 3', NOW()),
    (1, NULL, 1, 1, 'Bright star observed in sector 1', NOW()),
    (2, NULL, 2, 2, 'Planet observed in sector 2', NOW()),
    (3, NULL, 3, 3, 'Asteroids detected in sector 3', NOW()),
    (3, NULL, 4, 3, 'Galaxy Andromeda observed in sector 3', NOW()),
    (2, NULL, 5, 2, 'Comet observed in sector 2', NOW()),
    (3, NULL, 6, 3, 'Nebula detected in sector 3', NOW());

delimiter //

CREATE PROCEDURE observation_and_natural_objects()
BEGIN
    SELECT * FROM `Observation` NATURAL JOIN `NaturalObjects`;
END//

CREATE TRIGGER update_date_trigger
BEFORE UPDATE ON `Observation`
FOR EACH ROW
BEGIN
    SET NEW.date_update = NOW();
END//

delimiter ;
