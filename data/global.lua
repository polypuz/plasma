dofile('data/lib/lib.lua')

STORAGEVALUE_PROMOTION = 30018

ropeSpots = {384, 418, 8278, 8592, 13189, 14435, 14436, 15635, 19518}

doors = {[1209] = 1211, [1210] = 1211, [1212] = 1214, [1213] = 1214, [1219] = 1220, [1221] = 1222, [1231] = 1233, [1232] = 1233, [1234] = 1236, [1235] = 1236, [1237] = 1238, [1239] = 1240, [1249] = 1251, [1250] = 1251, [1252] = 1254, [1253] = 1254, [1539] = 1540, [1541] = 1542, [3535] = 3537, [3536] = 3537, [3538] = 3539, [3544] = 3546, [3545] = 3546, [3547] = 3548, [4913] = 4915, [4914] = 4915, [4916] = 4918, [4917] = 4918, [5082] = 5083, [5084] = 5085, [5098] = 5100, [5099] = 5100, [5101] = 5102, [5107] = 5109, [5108] = 5109, [5110] = 5111, [5116] = 5118, [5117] = 5118, [5119] = 5120, [5125] = 5127, [5126] = 5127, [5128] = 5129, [5134] = 5136, [5135] = 5136, [5137] = 5139, [5138] = 5139, [5140] = 5142, [5141] = 5142, [5143] = 5145, [5144] = 5145, [5278] = 5280, [5279] = 5280, [5281] = 5283, [5282] = 5283, [5284] = 5285, [5286] = 5287, [5515] = 5516, [5517] = 5518, [5732] = 5734, [5733] = 5734, [5735] = 5737, [5736] = 5737, [6192] = 6194, [6193] = 6194, [6195] = 6197, [6196] = 6197, [6198] = 6199, [6200] = 6201, [6249] = 6251, [6250] = 6251, [6252] = 6254, [6253] = 6254, [6255] = 6256, [6257] = 6258, [6795] = 6796, [6797] = 6798, [6799] = 6800, [6801] = 6802, [6891] = 6893, [6892] = 6893, [6894] = 6895, [6900] = 6902, [6901] = 6902, [6903] = 6904, [7033] = 7035, [7034] = 7035, [7036] = 7037, [7042] = 7044, [7043] = 7044, [7045] = 7046, [7054] = 7055, [7056] = 7057, [8541] = 8543, [8542] = 8543, [8544] = 8546, [8545] = 8546, [8547] = 8548, [8549] = 8550, [9165] = 9167, [9166] = 9167, [9168] = 9170, [9169] = 9170, [9171] = 9172, [9173] = 9174, [9267] = 9269, [9268] = 9269, [9270] = 9272, [9271] = 9272, [9273] = 9274, [9275] = 9276, [10276] = 10277, [10274] = 10275, [10268] = 10270, [10269] = 10270, [10271] = 10273, [10272] = 10273, [10471] = 10472, [10480] = 10481, [10477] = 10479, [10478] = 10479, [10468] = 10470, [10469] = 10470, [10775] = 10777, [10776] = 10777, [12092] = 12094, [12093] = 12094, [12188] = 12190, [12189] = 12190, [19840] = 19842, [19841] = 19842, [19843] = 19844, [19980] = 19982, [19981] = 19982, [19983] = 19984, [20273] = 20275, [20274] = 20275, [20276] = 20277, [17235] = 17236, [18208] = 18209, [13022] = 13023, [10784] = 10786, [10785] = 10786, [12099] = 12101, [12100] = 12101, [12197] = 12199, [12198] = 12199, [19849] = 19851, [19850] = 19851, [19852] = 19853, [19989] = 19991, [19990] = 19991, [19992] = 19993, [20282] = 20284, [20283] = 20284, [20285] = 20286, [17237] = 17238, [13020] = 13021, [10780] = 10781, [12095] = 12096, [12195] = 12196, [19845] = 19846, [19985] = 19986, [20278] = 20279, [10789] = 10790, [12102] = 12103, [12204] = 12205, [19854] = 19855, [19994] = 19995, [20287] = 20288, [10782] = 10783, [12097] = 12098, [12193] = 12194, [19847] = 19848, [19987] = 19988, [20280] = 20281, [10791] = 10792, [12104] = 12105, [12202] = 12203, [19856] = 19857, [19996] = 19997, [20289] = 20290}
verticalOpenDoors = {1211, 1220, 1224, 1228, 1233, 1238, 1242, 1246, 1251, 1256, 1260, 1540, 3546, 3548, 3550, 3552, 4915, 5083, 5109, 5111, 5113, 5115, 5127, 5129, 5131, 5133, 5142, 5145, 5283, 5285, 5289, 5293, 5516, 5737, 5749, 6194, 6199, 6203, 6207, 6251, 6256, 6260, 6264, 6798, 6802, 6902, 6904, 6906, 6908, 7044, 7046, 7048, 7050, 7055, 8543, 8548, 8552, 8556, 9167, 9172, 9269, 9274, 9274, 9269, 9278, 9282, 10270, 10275, 10279, 10283, 10479, 10481, 10485, 10483, 10786, 12101, 12199, 19851, 19853, 19991, 19993, 20284, 20286, 17238, 13021, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290}
horizontalOpenDoors = {1214, 1222, 1226, 1230, 1236, 1240, 1244, 1248, 1254, 1258, 1262, 1542, 3537, 3539, 3541, 3543, 4918, 5085, 5100, 5102, 5104, 5106, 5118, 5120, 5122, 5124, 5136, 5139, 5280, 5287, 5291, 5295, 5518, 5734, 5746, 6197, 6201, 6205, 6209, 6254, 6258, 6262, 6266, 6796, 6800, 6893, 6895, 6897, 6899, 7035, 7037, 7039, 7041, 7057, 8546, 8550, 8554, 8558, 9170, 9174, 9272, 9276, 9280, 9284, 10273, 10277, 10281, 10285, 10470, 10472, 10476, 10474, 10777, 12094, 12190, 19842, 19844, 19982, 19984, 20275, 20277, 17236, 18209, 13023, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281}
openSpecialDoors = {1224, 1226, 1228, 1230, 1242, 1244, 1246, 1248, 1256, 1258, 1260, 1262, 3541, 3543, 3550, 3552, 5104, 5106, 5113, 5115, 5122, 5124, 5131, 5133, 5289, 5291, 5293, 5295, 6203, 6205, 6207, 6209, 6260, 6262, 6264, 6266, 6897, 6899, 6906, 6908, 7039, 7041, 7048, 7050, 8552, 8554, 8556, 8558, 9176, 9178, 9180, 9182, 9278, 9280, 9282, 9284, 10279, 10281, 10283, 10285, 10474, 10476, 10483, 10485, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290}
questDoors = {1223, 1225, 1241, 1243, 1255, 1257, 3542, 3551, 5105, 5114, 5123, 5132, 5288, 5290, 5745, 5748, 6202, 6204, 6259, 6261, 6898, 6907, 7040, 7049, 8551, 8553, 9175, 9177, 9277, 9279, 10278, 10280, 10475, 10484, 10782, 12097, 12193, 19847, 19987, 20280, 10791, 12104, 12202, 19856, 19996, 20289}
levelDoors = {1227, 1229, 1245, 1247, 1259, 1261, 3540, 3549, 5103, 5112, 5121, 5130, 5292, 5294, 6206, 6208, 6263, 6265, 6896, 6905, 7038, 7047, 8555, 8557, 9179, 9181, 9281, 9283, 10282, 10284, 10473, 10482, 10780, 10789, 10780, 12095, 12195, 19845, 19985, 20278, 10789, 12102, 12204, 19854, 19994, 20287}
keys = {2086, 2087, 2088, 2089, 2090, 2091, 2092, 10032}


PROPOSED_STATUS = 1
MARRIED_STATUS = 2
PROPACCEPT_STATUS = 3
LOOK_MARRIAGE_DESCR = TRUE
ITEM_WEDDING_RING = 2121
ITEM_ENGRAVED_WEDDING_RING = 10502

function getPlayerSpouse(id)
    local resultQuery = db.storeQuery("SELECT `marriage_spouse` FROM `players` WHERE `id` = " .. db.escapeString(id))
    if resultQuery ~= false then
        local ret = result.getDataInt(resultQuery, "marriage_spouse")
        result.free(resultQuery)
        return ret
    end
    return -1
end

function setPlayerSpouse(id, val)
    db.query("UPDATE `players` SET `marriage_spouse` = " .. val .. " WHERE `id` = " .. id)
end

function getPlayerMarriageStatus(id)
    local resultQuery = db.storeQuery("SELECT `marriage_status` FROM `players` WHERE `id` = " .. db.escapeString(id))
    if resultQuery ~= false then
        local ret = result.getDataInt(resultQuery, "marriage_status")
        result.free(resultQuery)
        return ret
    end
    return -1
end

function getPlayerTitleId( id )
  local resultQuery = db.storeQuery("SELECT `title` FROM `players` WHERE `id`=" .. db.escapeString( id ) )
  if resultQuery ~= false then
    local ret = result.getDataInt( resultQuery, "title")
    result.free( resultQuery )
    return ret
  end
  return -1
end

function getPlayerTitle( player_id )
  local titleId = getPlayerTitleId( player_id )
  if titleId then
    local resultQuery = db.storeQuery("SELECT `title` FROM `player_titles` WHERE `id`=" .. titleId )
    if resultQuery ~= false then
      local ret = result.getDataString( resultQuery, "title")
      result.free( resultQuery )
      return ret
    end
    return false
  end
  return false
end

function setPlayerMarriageStatus(id, val)
    db.query("UPDATE `players` SET `marriage_status` = " .. val .. " WHERE `id` = " .. id)
end

function Player:getMarriageDescription(thing)
    local descr = ""
    if getPlayerMarriageStatus(thing:getGuid()) == MARRIED_STATUS then
        playerSpouse = getPlayerSpouse(thing:getGuid())
        if self == thing then
            descr = descr .. " Jestes "
        elseif thing:getSex() == PLAYERSEX_FEMALE then
            descr = descr .. " Jest "
        else
            descr = descr .. " Jest "
        end
        descr = descr .. "w zwiazku z " .. getPlayerNameById(playerSpouse) .. '.'
    end
    return descr
end

-- The following 2 functions can be used for delayed shouted text

function say(param)
  selfSay(text)
  doCreatureSay(param.cid, param.text, 1)
end

function delayedSay(text, delay)
  local delay = delay or 0
  local cid = getNpcCid()
  addEvent(say, delay, {cid = cid, text = text})
end

function getDistanceBetween(firstPosition, secondPosition)
  local xDif = math.abs(firstPosition.x - secondPosition.x)
  local yDif = math.abs(firstPosition.y - secondPosition.y)
  local posDif = math.max(xDif, yDif)
  if firstPosition.z ~= secondPosition.z then
    posDif = posDif + 15
  end
  return posDif
end

function getFormattedWorldTime()
  local worldTime = getWorldTime()
  local hours = math.floor(worldTime / 60)

  local minutes = worldTime % 60
  if minutes < 10 then
    minutes = '0' .. minutes
  end
  return hours .. ':' .. minutes
end

string.split = function(str, sep)
  local res = {}
  for v in str:gmatch("([^" .. sep .. "]+)") do
    res[#res + 1] = v
  end
  return res
end

string.trim = function(str)
  return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

if nextUseStaminaTime == nil then
  nextUseStaminaTime = {}
end

-- TASKS SYSTEM --
TASKSYS = {
  -- Settings
  MAX_CONCURRENT_TASKS = 1,
  REWARD_ITEMS_CONTAINER_ID = 1988, -- Brown Backpack
  REWARD_ITEMS_INBOX_CONTAINER_ID = 2596, -- Parcel

  -- Do not use players' storage keys in range <50000, 54999> in other places!
  -- Do not define more than 1000 tasks (indexing starts from 0)
  STORAGE_KEY_COMMON_START = 50000,
  STORAGE_KEY_ACTIVE_START = 52000,
  STORAGE_KEY_STATE_START = 53000,
  STORAGE_KEY_PROGRESS_START = 54000,

  -- Common storage values
  STORAGE_KEY_TASKPOINTS = 50000,
  STORAGE_KEY_BOSSPOINTS = 50001,

  -- Map Constants
  ITEM_UID_TELEPORT_ENTRANCE = 52000,
  ITEM_UID_TELEPORT_EXIT = 53000,


  STATES = {
    -- States use power-of-two values, useful for bitmasks
    INACTIVE = 0,
    UNLOCKED = 1,
    ACTIVE = 2,
    DONE = 4,
    DONE_PROBLEMS = 8,

    -- Done - Problem bits
    DONE_PROBLEM_UNSPECIFIED = 16,
    DONE_PROBLEM_REWARD_ITEM = 32
  },

  TASKS = {}
}

-- user settings explained --
-- "tasksys_{ID}_state"
-- "tasksys_{ID}_progress"

-- TASKSYS.TASKS[0] = {
--   enabled = true,

--   type = "creatures", -- creatures / boss
--   raceName = "Elfs", -- Global name
--   creatures = {
--     "Elf", "Elf Scout", "Elf Arcanist" -- All creatures to kill (IDs maybe?)
--   },

--   -- Requirement definitions
--   requirements = {
--     {
--       type = "level", -- Player's level in specified range
--       min = 1,
--       max = 999
--     },
--     {
--       type = "vocation", -- Player's vocation must match
--       ids = { 1, 2, 3, 4, 5, 6, 7, 8 },
--     },
--     {
--       type = "taskCompleted", -- Other task has to be completed
--       taskID = 1 -- TaskID
--     },
--     {
--       type = "bossPoints", -- Accumulation of boss points
--       value = 10, -- Value
--       subtract = true -- Should boss points be subtracted?
--     },
--     {
--       type = "taskPoints", -- Accumulation of task points
--       value = 10,
--       subtract = false -- Should task points be subtracted?
--     },
--     {
--       type = "nolock", -- Task has to be unlocked
--       repeatable = false -- Lock will be reseted upon completion (when true)
--     },
--     {
--       type = "taskLocked", -- Other task has to be locked (use when locking normal task when boss task enabled)
--       taskID = 1 -- Task ID
--     }
--   },
--   killsRequired = 300, -- Kills count
--   repeatable = false, -- Is task repetable?

--   -- Taks rewards definition
--   rewards = {
--     {
--       type = "exp", -- Experience
--       value = 20000,
--       staged = false -- Should take exp stages into account
--     },
--     {
--       type = "skill", -- Skill percent (eg. 200 -> 200% -> 2 skills)
--       skill = "axe",
--       value = 100,
--     },
--     {
--       type = "item", -- Item (note that wrong definition will lead to error)
--       itemID = 123,
--       count = 2, -- Must be <1, 100> for stackables, "1" or undefined for non-stackables
--       -- Contained items (only for containers)
--       contains = {
--         {
--           itemID = 1988,
--           count = 1
--         },
--         {
--           itemID = 2596,
--           count = 2
--         }
--       }
--     },
--     {
--       type = "taskPoints", -- Global task points
--       value = 10
--     },
--     {
--       type = "bossPoints", -- Boss points
--       value = 10
--     },
--     {
--       type = "taskUnlock", -- Unlocks another task
--       taskID = 1
--     },
--     {
--       type = "playerSetting", -- Defines player setting (useful for quests maybe?)
--       key = 1234,
--       value = 1234
--     }
--   },

--   -- NPC hints
--   hints = {
--     "Potwor jest pod miastem",
--     "Strzez sie, jest mocny"
--   },

--   -- NPC congratulations (may contain additional info about other tasks)
--   -- May be empty (generic message used)
--   completionTexts = {
--     "Gratulacje! Teraz mozesz isc po {bossa}!"
--   },

--   -- (Boss only) teleport activator
--   teleport = {
--     -- Teleport entrance (position)
--     entrance = {
--       x = 1,
--       y = 1,
--       z = 1,
--       fallback = "N" -- (N)orth, (S)outh, (E)ast, (W)est
--     },
--     -- Teleport destination (Boss room)
--     exit = {
--       x = 2,
--       y = 2,
--       z = 1
--     },
--     maxPlayers = 1 -- How many players can join boss fight at once
--   }
-- }

TASKSYS.TASKS[0] = {
  enabled = true,

  type = "creatures",
  raceName = "Elfs",
  creatures = {
    "Elf", "Elf Scout", "Elf Arcanist"
  },
  requirements = {
    {
      type = "level",
      min = 1,
      max = 999
    },
    {
      type = "vocation",
      ids = { 1, 2, 3, 4, 5, 6, 7, 8 },
    }
  },
  killsRequired = 0,
  repeatable = false,
  rewards = {
    {
      type = "exp",
      value = 20000
    },
    {
      type = "item", -- Item (sent to depo?)
      itemID = 2152,
      count = 100
    },
    {
      type = "skill",
      skill = "axe",
      value = 100
    },
    {
      type = "taskPoints",
      value = 3
    },
    {
      type = "bossPoints",
      value = 2
    },
    {
      type = "taskUnlock",
      taskID = 10
    },
    {
      type = "playerSetting",
      key = 60000,
      value = 123
    }
  },

  hints = {
    "Zabij elfy!"
  }
}

-- END OF TASKS SYSTEM --
