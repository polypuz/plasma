--
-- Dumping data for table `raids`
--

INSERT INTO `raids` (`raidId`, `name`, `timeinterval`, `lastExecuted`, `timeMargin`, `repeatable`, `active`) VALUES
(1, 'Testraid', 1, '2016-10-06 17:40:30', 2, 0, 1),
(2, 'Testraid2', 5, '2016-10-06 17:56:00', 2, 1, 1);


--
-- Dumping data for table `raids_announce`
--

INSERT INTO `raids_announce` (`announceId`, `raidId`, `message`, `delay`, `type`) VALUES
(1, 1, 'Rats are attacking neart Trekolt Temple!', 1000, 'warning'),
(2, 1, 'Rats attack continues!', 25000, 'warning'),
(3, 2, 'Second Raid Test', 1000, 'warning');


--
-- Dumping data for table `raids_spawn`
--

INSERT INTO `raids_spawn` (`spawnId`, `raidId`, `spawnTypeId`, `monsterName`, `delay`, `radius`, `x`, `y`, `z`, `tox`, `toy`, `toz`, `minamount`, `maxamount`, `amount`) VALUES
(1, 1, 1, 'Cave Rat', 15000, NULL, 1014, 1014, 7, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 1, 1, 'Cave Rat', 25000, NULL, 1013, 1013, 7, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 1, 2, 'Rat', 2000, 5, 1010, 1010, 7, NULL, NULL, NULL, NULL, NULL, 3),
(4, 1, 3, 'Rat', 30000, NULL, 969, 980, 7, 1020, 1025, 7, 10, 20, NULL);
