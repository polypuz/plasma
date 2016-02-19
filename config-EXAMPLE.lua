-- Combat settings
-- NOTE: valid values for worldType are: "pvp", "no-pvp" and "pvp-enforced"
worldType = "pvp"
hotkeyAimbotEnabled = true
protectionLevel = 50
killsToRedSkull = 4
killsToBlackSkull = 5
pzLocked = 60000
removeChargesFromRunes = true
timeToDecreaseFrags = 24 * 60 * 60 * 1000
whiteSkullTime = 15 * 60 * 1000
stairJumpExhaustion = 1500
experienceByKillingPlayers = false
expFromPlayersLevelRange = 75

-- Connection Config
-- NOTE: maxPlayers set to 0 means no limit
ip = "adres_do_zbindowania" (nie-lokalny)
bindOnlyGlobalAddress = false
loginProtocolPort = 7171
gameProtocolPort = 7172
statusProtocolPort = 7171
maxPlayers = 0
motd = "MirkOTS wita mirkow i mirabelki!"
onePlayerOnlinePerAccount = true
allowClones = false
serverName = "MirkOTS"
statusTimeout = 4000
replaceKickOnLogin = true
maxPacketsPerSecond = 100

-- Deaths
-- NOTE: Leave deathLosePercent as -1 if you want to use the default
-- death penalty formula. For the old formula, set it to 10. For
-- no skill/experience loss, set it to 0.
deathLosePercent = -1

-- Houses
-- NOTE: set housePriceEachSQM to -1 to disable the ingame buy house functionality
housePriceEachSQM = -1
houseRentPeriod = "weekly"

-- Item Usage
timeBetweenActions = 200
timeBetweenExActions = 875

-- Map
-- NOTE: set mapName WITHOUT .otbm at the end
mapName = "mapname"
mapAuthor = "mapname"

-- Market
marketOfferDuration = 30 * 24 * 60 * 60
premiumToCreateMarketOffer = true
checkExpiredMarketOffersEachMinutes = 60
maxMarketOffersAtATimePerPlayer = 100

-- MySQL
mysqlHost = "127.0.0.1"
mysqlUser = "db_username"
mysqlPass = "db_password"
mysqlDatabase = "db_name"
mysqlPort = 3306
mysqlSock = ""

-- Misc.
allowChangeOutfit = true
freePremium = true
kickIdlePlayerAfterMinutes = 60
maxMessageBuffer = 15
emoteSpells = true
classicEquipmentSlots = true

-- Rates
-- NOTE: rateExp is not used if you have enabled stages in data/XML/stages.xml
rateExp = 10
rateSkill = 10
rateLoot = 2
rateMagic = 5
rateSpawn = 1

-- Monsters
deSpawnRange = 12
deSpawnRadius = 75

-- Stamina
staminaSystem = true

-- Scripts
warnUnsafeScripts = true
convertUnsafeScripts = true

-- Startup
-- NOTE: defaultPriority only works on Windows and sets process
-- priority, valid values are: "normal", "above-normal", "high"
defaultPriority = "high"
startupDatabaseOptimization = true

-- Status server information
ownerName = "marahin"
ownerEmail = "me@marahin.pl"
url = "http://mirkots.pl"
location = "Poland"
