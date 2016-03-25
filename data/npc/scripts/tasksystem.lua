-- Monster Tasks by mdziekon
-- TODO: Massive code cleanup (most of these functions could be placed in Player class-space)
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)  npcHandler:onCreatureAppear(cid)  end
function onCreatureDisappear(cid)  npcHandler:onCreatureDisappear(cid)  end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()  npcHandler:onThink()  end

local function greetCallback(cid)
  return true
end

local function tableSize(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function isRequirementFulfilled(requirement, player, taskID)
  local type = requirement.type

  if type == "level" then
    local playerLevel = player:getLevel()

    if playerLevel < requirement.min then
      return false
    end

    if playerLevel > requirement.max then
      return false
    end
  elseif type == "vocation" then
    local vocationID = player:getVocation():getId()

    if isInArray(requirement.ids, vocationID) == false then
      return false
    end
  elseif type == "taskCompleted" then
    return getPlayerTaskProgress(player, requirement.taskID) == TASKSYS.STATES.DONE
  elseif type == "bossPoints" then
    return getPlayerStorageValue(player, TASKSYS.STORAGE_KEY_BOSSPOINTS, 0) >= requirement.value
  elseif type == "taskPoints" then
    return getPlayerStorageValue(player, TASKSYS.STORAGE_KEY_TASKPOINTS, 0) >= requirement.value
  elseif type == "nolock" then
    return getPlayerTaskState(player, taskID) == TASKSYS.STATES.UNLOCKED
  elseif type == "taskLocked" then
    return getPlayerTaskState(player, taskID) == TASKSYS.STATES.INACTIVE
  end

  return true
end

local function isTaskUnlocked(taskID, player)
  local task = TASKSYS.TASKS[taskID]

  if task.enabled ~= true then
    return false
  end

  for i, requirement in pairs(task.requirements) do
    if isRequirementFulfilled(requirement, player, taskID) == false then
      return false
    end
  end

  return true
end

local function getPlayerTaskState(player, taskID)
  local value = player:getStorageValue(TASKSYS.STORAGE_KEY_STATE_START + taskID)

  if value == -1 then
    return TASKSYS.STATES.INACTIVE
  end

  return value
end

local function getPlayerTaskProgress(player, taskID)
  local value = player:getStorageValue(TASKSYS.STORAGE_KEY_PROGRESS_START + taskID)

  if value == -1 then
    return 0
  end

  return value
end

local function setPlayerTaskActiveState(player, taskID, isActive)
  local i = 0

  while i < TASKSYS.MAX_CONCURRENT_TASKS do
    local slot = player:getStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i)

    if slot == -1 then
      player:setStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i, taskID)
      return true
    end

    i = i + 1
  end

  return false
end

local function unsetPlayerTaskActiveState(player, taskID)
  local i = 0

  while i < TASKSYS.MAX_CONCURRENT_TASKS do
    local slot = player:getStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i)

    if slot == taskID then
      player:setStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i, -1)
      return true
    end

    i = i + 1
  end

  return false
end

local function updatePlayerTaskActiveState(player, taskID, newState)
  local i = 0

  while i < TASKSYS.MAX_CONCURRENT_TASKS do
    local slot = player:getStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i)

    if slot == taskID then
      player:setStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i, newState)
      return true
    end

    i = i + 1
  end

  return false
end

local function setPlayerTaskState(player, taskID, value)
  player:setStorageValue(TASKSYS.STORAGE_KEY_STATE_START + taskID, value)
end

local function setPlayerTaskProgress(player, taskID, value)
  player:setStorageValue(TASKSYS.STORAGE_KEY_PROGRESS_START + taskID, value)
end

local function getPlayerActiveTaskIDs(player)
  -- Get player active task IDs

  return {}
end

local function getSkillID(skillName)
  if skillName == "club" then
    return SKILL_CLUB
  elseif skillName == "sword" then
    return SKILL_SWORD
  elseif skillName == "axe" then
    return SKILL_AXE
  elseif skillName:sub(1, 4) == "dist" then
    return SKILL_DISTANCE
  elseif skillName:sub(1, 6) == "shield" then
    return SKILL_SHIELD
  elseif skillName:sub(1, 4) == "fish" then
    return SKILL_FISHING
  else
    return SKILL_FIST
  end
end

local function createRewardItem(rewardItem)
  local itemUID = doCreateItemEx(rewardItem.itemID, 1)

  local itemInstance = Item(itemUID)

  if itemInstance:getType():isStackable() == false and (rewardItem.count ~= nil and rewardItem.count > 1) then
    print('[TaskSystem:NPC] Wrong rewardItem definition - unstackable item with count > 1 (itemID: ' .. rewardItem.itemID .. ')')
    return false
  end

  if itemInstance:isContainer() == false and type(rewardItem.contains) == "table" then
    print('[TaskSystem:NPC] Wrong rewardItem definition - tried to insert other items into non-container item (itemID: ' .. rewardItem.itemID .. ')')
    return false
  end

  if itemInstance:isContainer() and type(rewardItem.contains) == "table" then
    -- Fill container with content
    if rewardItem.count ~= nil and rewardItem.count > 1 then
      print('[TaskSystem:NPC] Wrong rewardItem definition - Filled containers cannot have "count"')
      return false
    end

    for idx, containedReward in pairs(rewardItem.contains) do
      local containedItem = createRewardItem(containedReward)

      if containedItem == false then
        print('[TaskSystem:NPC] Contained item error (container itemID: ' .. rewardItem.itemID .. ')')
        return false
      end

      itemInstance:addItemEx(Item(containedItem))
    end
  else
    itemUID = doCreateItemEx(rewardItem.itemID, rewardItem.count)
  end

  return itemUID
end

local function sumCapacity(items)
  local totalCap = 0

  for idx, itemUID in pairs(items) do
    totalCap = totalCap + Item(itemUID):getWeight()
  end

  return totalCap
end

local REWARD_PLAYER_RESULTS = {
  RESULT_OK = 0,
  RESULT_ITEMS_INBOX_CAP = 1,
  RESULT_ITEMS_INBOX_SPACE = 2,
  RESULT_ITEMS_ERROR = 4
}

local function rewardPlayer(player, taskID)
  local rewards = TASKSYS.TASKS[taskID].rewards
  local result = REWARD_PLAYER_RESULTS.RESULT_OK

  local itemRewards = {}
  local itemRewardsProblem = false

  -- Iterate over all rewards
  for idx, reward in pairs(rewards) do
    if reward.type == "exp" then
      if reward.staged then
        player:addStagedExperience(reward.value)
      else
        player:addExperience(reward.value)
      end
    elseif reward.type == "skill" then
      player:addSkillPercent(getSkillID(reward.skill), reward.value)
    elseif reward.type == "item" then
      local item = createRewardItem(reward)

      if item == false then
        print('[TaskSystem:NPC] Problem with task definition (taskID: ' .. taskID .. ')')
        itemRewardsProblem = true
      else
        table.insert(itemRewards, item)
      end
    elseif reward.type == "taskPoints" then
      local currentPoints = player:getStorageValue(TASKSYS.STORAGE_KEY_TASKPOINTS)

      if currentPoints == -1 then
        currentPoints = 0
      end

      player:setStorageValue(TASKSYS.STORAGE_KEY_TASKPOINTS, currentPoints + reward.value)
    elseif reward.type == "bossPoints" then
      local currentPoints = player:getStorageValue(TASKSYS.STORAGE_KEY_BOSSPOINTS)

      if currentPoints == -1 then
        currentPoints = 0
      end

      player:setStorageValue(TASKSYS.STORAGE_KEY_BOSSPOINTS, currentPoints + reward.value)
    elseif reward.type == "taskUnlock" then
      local currentState = getPlayerTaskState(player, reward.taskID)

      if not currentState == TASKSYS.STATES.INACTIVE then
        print('[TaskSystem:NPC] Trying to unlock non-inactive task (taskID: ' .. taskID .. ', unlocking: ' .. reward.taskID .. ')')
      else
        setPlayerTaskState(player, reward.taskID, TASKSYS.STATES.UNLOCKED)
      end
    elseif reward.type == "playerSetting" then
      player:setStorageValue(reward.key, reward.value)
    end
  end

  -- Handle item rewards (add them to player's BP or their's Inbox)
  if #itemRewards > 0 and itemRewardsProblem == false then
    local sendToInbox = false

    if player:getFreeCapacity() < sumCapacity(itemRewards) then
      result = REWARD_PLAYER_RESULTS.RESULT_ITEMS_INBOX_CAP

      sendToInbox = true
    else
      local requiredSlots = #itemRewards
      local bpSlots = player:getSlotItem(CONST_SLOT_BACKPACK):getEmptySlots(false)

      if bpSlots < requiredSlots then
        result = REWARD_PLAYER_RESULTS.RESULT_ITEMS_INBOX_SPACE

        sendToInbox = true
      end
    end

    if sendToInbox == false then
      for idx, itemUID in pairs(itemRewards) do
        player:addItemEx(Item(itemUID), false, CONST_SLOT_BACKPACK)
      end
    else
      local inbox = player:getInbox()
      local inboxContainer = inbox:addItem(TASKSYS.REWARD_ITEMS_INBOX_CONTAINER_ID, 1, false, 1)

      if not inboxContainer then
        print('[TaskSystem:NPC] Could not create inbox container in the Inbox (taskID: ' .. taskID .. ')')
        itemRewardsProblem = true
      else
        local requiredSlots = #itemRewards
        local inboxContainerSlots = inboxContainer:getEmptySlots(false)

        if inboxContainerSlots < requiredSlots then
          print('[TaskSystem:NPC] Inbox container is too small for all rewards (taskID: ' .. taskID .. ')')
          itemRewardsProblem = true
        else
          for idx, itemUID in pairs(itemRewards) do
            inboxContainer:addItemEx(Item(itemUID), INDEX_WHEREEVER, FLAG_NOLIMIT)
          end
        end
      end
    end
  end

  if itemRewardsProblem == true then
    result = REWARD_PLAYER_RESULTS.RESULT_ITEMS_ERROR
  end

  return result
end


local function creatureSayCallback(cid, type, msg)
  local player = Player(cid)
  local currentTask = player:getStorageValue(currentTask)

  if not npcHandler:isFocused(cid) then
    return false
  end

  -- Pokaz aktywne zadania
  if msgcontains(msg, "aktywne zadania") or msgcontains(msg, "aktywne") then
    local activeTasksCount = tableSize(getPlayerActiveTaskIDs(player))

    if activeTasksCount == 0 then
      npcHandler:say("Nie masz aktywnych zadan", cid)
    else
      npcHandler:say("Liczba aktywnych zadan: " .. activeTasksCount, cid)
    end

    return false
  end

  -- Pokaz dostepne zadania
  if msgcontains(msg, "dostepne zadania") or msgcontains(msg, "dostepne") then
    local activeTasksCount = tableSize(getPlayerActiveTaskIDs(player))

    if activeTasksCount == TASKSYS.MAX_CONCURRENT_TASKS then
      npcHandler:say("Nie mozesz aktywowac wiecej zadan", cid)

      return false
    end

    local taskNames = ""

    for taskID, task in pairs(TASKSYS.TASKS) do
      if isTaskUnlocked(taskID, player) then
        taskNames = taskNames .. ", " .. " {" .. task.raceName .. "}"
      end
    end

    npcHandler:say("Dostepne zadania: " .. taskNames, cid)

    return false
  end

  -- Pokaz informacje o zadaniach
  if msgcontains(msg, "zadania") or msgcontains(msg, "zadanie") then
    local activeTasksCount = tableSize(getPlayerActiveTaskIDs(player))

    -- Gdy nie aktywowano jeszcze taskow
    if activeTasksCount == 0 then
      creatureSayCallback(cid, type, "dostepne zadania")
      return false
    end

    -- Gdy aktywowano jakis task
    if activeTasksCount == TASKSYS.MAX_CONCURRENT_TASKS then
      creatureSayCallback(cid, type, "aktywne zadania")
      return false
    end

    npcHandler:say("Chcesz sprawdzic {aktywne zadania} czy {dostepne zadania}?", cid)
    return false
  end

  -- Obsluga tematow rozmowy (o zadaniach)
  if npcHandler.topic[cid] == 1 then
    -- Rozpoczecie zadania
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      local taskID = npcHandler.variables[cid].taskID

      npcHandler:say("Zalatwione! Wroc do mnie gdy skonczysz zadanie.", cid)

      setPlayerTaskState(player, taskID, TASKSYS.STATES.ACTIVE)
      setPlayerTaskProgress(player, taskID, 0)

      setPlayerTaskActiveState(player, taskID, TASKSYS.STATES.ACTIVE)

      npcHandler.topic[cid] = 0
      npcHandler.variables[cid].taskID = nil

      return false
    end

    if msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("Szkoda...", cid)

      npcHandler.topic[cid] = 0
      npcHandler.variables[cid].taskID = nil

      return false
    end
  elseif npcHandler.topic[cid] == 2 then
    -- Konczenie zadania

    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      local taskID = npcHandler.variables[cid].taskID
      local task = TASKSYS.TASKS[taskID]

      local playerProgress = getPlayerTaskProgress(player, taskID)

      if playerProgress == task.killsRequired then
        local response = "Gratulacje! Zakonczyles zadanie."

        -- Dodaj nagrody
        local result = rewardPlayer(player, taskID)

        if result == REWARD_PLAYER_RESULTS.RESULT_ITEMS_INBOX_CAP then
          response =
            response ..
            " Nagrody ktore chcialem Ci wreczyc wazyly zbyt duzo, wiec wyslalem je do twojej skrzynki."
        elseif result == REWARD_PLAYER_RESULTS.RESULT_ITEMS_INBOX_SPACE then
          response =
            response ..
            " Nagrody ktore chcialem Ci wreczyc nie zmiescilyby sie do twojego plecaka, wiec wyslalem je do twojej skrzynki."
        elseif result == REWARD_PLAYER_RESULTS.RESULT_ITEMS_ERROR then
          response =
            response ..
            " Nie moglem wreczyc Ci nagrod, skontaktuj sie z administracja i wroc aby {kontynuowac} zadanie."
        end

        npcHandler:say(response, cid)

        -- Przestaw zadanie
        if result == REWARD_PLAYER_RESULTS.RESULT_ITEMS_ERROR then
          local state = bit.bor(TASKSYS.STATES.DONE_PROBLEMS, TASKSYS.STATES.DONE_PROBLEM_REWARD_ITEM)

          updatePlayerTaskActiveState(player, taskID, state)
          setPlayerTaskState(player, taskID, state)
        else
          unsetPlayerTaskActiveState(player, taskID)
          setPlayerTaskState(player, taskID, TASKSYS.STATES.DONE)
        end
      else
        npcHandler:say("Nie zabiles jeszcze wszystkich potworow...", cid)
      end

      npcHandler.topic[cid] = 0
      npcHandler.variables[cid].taskID = nil

      return false
    end

    if msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("Wroc do mnie kiedy skonczysz...", cid)

      npcHandler.topic[cid] = 0
      npcHandler.variables[cid].taskID = nil

      return false
    end
  end

  -- Wymieniona nazwa zadania
  for taskID, task in pairs(TASKSYS.TASKS) do
    if msgcontains(msg, task.raceName) then
      if not isTaskUnlocked(taskID, player) then
        return false
      end

      local playerTaskState = getPlayerTaskState(player, taskID)

      if playerTaskState == TASKSYS.STATES.INACTIVE or playerTaskState == TASKSYS.STATES.UNLOCKED then
        -- Wymien warunki zakonczenia i zapytaj czy bierze

        local monsters = ""
        for creatureIdx, creatureName in pairs(task.creatures) do
          monsters = monsters .. ", " .. " {" .. creatureName .. "}"
        end

        npcHandler:say("Zadanie wymaga od ciebie bys zabil: " .. monsters .. ". Musisz zabic ich {" .. task.killsRequired .. "}. Czy podejmujesz sie zadania?", cid)

        npcHandler.topic[cid] = 1
        npcHandler.variables[cid].taskID = taskID

        return false
      elseif playerTaskState == TASKSYS.STATES.ACTIVE then
        -- Zapytaj czy skonczyl zadanie
        npcHandler:say("Czy skonczyles juz to zadanie?", cid)

        npcHandler.topic[cid] = 2
        npcHandler.variables[cid].taskID = taskID

        return false
      elseif playerTaskState == TASKSYS.STATES.DONE then
        -- Sprawdz czy mozna powtorzyc zadanie
        npcHandler:say("Wykonales juz to zadanie", cid)
        return false
      else
        -- Niepoprawny status
        npcHandler:say("Ehm, cos poszlo nie tak. Skontaktuj sie z administracja...", cid)
        return false
      end
    end
  end


  -- Commented code made by kajakpt

  -- if not npcHandler:isFocused(cid) then
  --   return false
  -- elseif msgcontains(msg, "zadania") or msgcontains(msg, "zadanie") then
  --   local text = ""

  --   for k, x in pairs(tasks) do
  --     if player:getLevel() >= x.minLevel and player:getLevel() <= x.maxLevel and isInArray(x.vocation, player:getVocation():getId()) then
  --       text = text .. ", "
  --       text = text .. "".. x.killsRequired .." {".. x.raceName .."}"
  --     end
  --   end

  --   if currentTask == -1 then -- gracz nie wziął jeszcze zadania
  --     npcHandler:say("Mam dla ciebie nastepujace zadania: " .. text, cid)
  --     npcHandler.topic[cid] = 1
  --   elseif currentTask == 1 then
  --     for k, x in pairs(tasks) do
  --       if player:getStorageValue(x.questStarted) == 1 then
  --         npcHandler:say("Czy zabiles juz ".. x.killsRequired .." ".. table.concat(x.creatures, ', ') .."?", cid)
  --         npcHandler.topic[cid] = 20
  --       end
  --     end
  --   end
  -- elseif npcHandler.topic[cid] == 1 then -- wziecie zadania
  --   for k, x in pairs(tasks) do
  --     if msgcontains(msg, x.raceName) then
  --       npcHandler:say("Jestes pewny, ze chcesz zabic " .. x.killsRequired .." ".. table.concat(x.creatures, ', ') .."?", cid)
  --       npcHandler.topic[cid] = x.questStarted
  --     end
  --   end
  -- elseif msgcontains(msg, "tak") and npcHandler.topic[cid] > 1000 then -- potwierdzenie wziecia nowego zadania
  --   for k, x in pairs(tasks) do
  --     if x.questStarted == npcHandler.topic[cid] then
  --       npcHandler:say("Powodzenia. Wroc kiedy zabijesz wszystkie potwory.", cid)
  --       player:setStorageValue(currentTask, k)
  --     end
  --   end
  -- elseif msgcontains(msg, "tak") and npcHandler.topic[cid] == 20 then -- ukonczenie taska
  --   local x = tasks[currentTask]

  --   if player:getStorageValue(x.questKills) >= x.killsRequired then
  --     text = ''
  --     for k, r in pairs(x.rewards) do
  --       if r.enable == true then
  --         if r.type == 'exp' then
  --           doPlayerAddExp(cid, r.values)
  --           text = text .. r.values .. ' doswiadczenia, '
  --         elseif r.type == 'money' then
  --           if r.values > 100 then
  --             player:addItem(ITEM_CRYSTAL_COIN, math.floor(r.values) / 100)
  --             player:addItem(ITEM_PLATINUM_COIN, r.values % 100)
  --           else
  --             player:addItem(ITEM_PLATINUM_COIN, r.values / 100)
  --           end
  --           text = text .. r.values .. ' zlotych monet, '
  --         elseif r.type == 'points' then -- dodajemy graczowi 1 punkt
  --           player:setStorageValue(x.questFinished, player:getStorageValue(x.questFinished) + 1)
  --           text = text .. ' 1 punkt tasku ' .. x.raceName .. ', '
  --         elseif r.type == 'item' then -- dodajemy itemy
  --           for item in r.values do
  --             player:addItem(item[0], item[1])
  --           end
  --           text = text .. ' itemy, '
  --         elseif r.type == 'boss' then
  --           player:setStorageValue(r.bossKilled, 0)
  --           text = text .. ' i mozliwosc zabicia bossa. '
  --         end
  --       end
  --     end

  --     npcHandler:say("Dziekuje, ze zabiles te straszne potwory. W nagrode otrzymujesz  ".. text, cid)
  --     npcHandler:say(x.text, cid)
  --   else
  --     npcHandler:say("Nie zabiles jeszcze wszystkich potworow Musisz jeszcze zabic ".. x.killsRequired - (player:getStorageValue(x.mstorage) + 1).." ".. table.concat(c.creatures, ', ') ..". Wroc kiedy skonczysz!", cid)
  --   end
  -- end

  return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
