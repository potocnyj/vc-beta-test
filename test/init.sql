CREATE DATABASE IF NOT EXISTS `telemetry`;
USE telemetry;

CREATE TABLE `counters` (
  `id` int(10) unsigned NOT NULL AUTO INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `points` (
  `counter` int(10) unsigned NOT NULL,
  `ts` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`counter`,`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;