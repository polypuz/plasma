-- Define this object in global.lua

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
  STORAGE_KEY_ENTERED_TELEPORT = 50010,

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

TASKSYS.TASKS[0] = {
  enabled = true,

  type = "creatures", -- creatures / boss
  raceName = "Elfs", -- Global name
  creatures = {
    "Elf", "Elf Scout", "Elf Arcanist" -- All creatures to kill (IDs maybe?)
  },

  -- Requirement definitions
  requirements = {
    {
      type = "level", -- Player's level in specified range
      min = 1,
      max = 999
    },
    {
      type = "vocation", -- Player's vocation must match
      ids = { 1, 2, 3, 4, 5, 6, 7, 8 },
    },
    {
      type = "taskCompleted", -- Other task has to be completed
      taskID = 1 -- TaskID
    },
    {
      type = "bossPoints", -- Accumulation of boss points
      value = 10, -- Value
      subtract = true -- Should boss points be subtracted?
    },
    {
      type = "taskPoints", -- Accumulation of task points
      value = 10,
      subtract = false -- Should task points be subtracted?
    },
    {
      type = "nolock", -- Task has to be unlocked
      repeatable = false -- Lock will be reseted upon completion (when true)
    },
    {
      type = "taskLocked", -- Other task has to be locked (use when locking normal task when boss task enabled)
      taskID = 1 -- Task ID
    }
  },
  killsRequired = 300, -- Kills count
  repeatable = false, -- Is task repeatable?

  -- Special settings for tasks with teleport (fighting pit, boss pit, etc.)
  teleportSettings = {
    maxPlayers = 2, -- How many players can fight the boss at once?
    monsters = {
      {
        name = "Demodras",
        pos = {
          x = 1032,
          y = 1030,
          z = 6
        }
      }
    }
  },

  -- Taks rewards definition
  rewards = {
    {
      type = "exp", -- Experience
      value = 20000,
      staged = false -- Should take exp stages into account
    },
    {
      type = "skill", -- Skill percent (eg. 200 -> 200% -> 2 skills)
      skill = "axe",
      value = 100,
    },
    {
      type = "item", -- Item (note that wrong definition will lead to error)
      itemID = 123,
      count = 2, -- Must be <1, 100> for stackables, "1" or undefined for non-stackables
      -- Contained items (only for containers)
      contains = {
        {
          itemID = 1988,
          count = 1
        },
        {
          itemID = 2596,
          count = 2
        }
      }
    },
    {
      type = "taskPoints", -- Global task points
      value = 10
    },
    {
      type = "bossPoints", -- Boss points
      value = 10
    },
    {
      type = "taskUnlock", -- Unlocks another task
      taskID = 1
    },
    {
      type = "playerSetting", -- Defines player setting (useful for quests maybe?)
      key = 1234,
      value = 1234
    }
  },

  -- NPC hints
  hints = {
    "Potwor jest pod miastem",
    "Strzez sie, jest mocny"
  },

  -- NPC congratulations (may contain additional info about other tasks)
  -- May be empty (generic message used)
  completionTexts = {
    "Gratulacje! Teraz mozesz isc po {bossa}!"
  }
}
