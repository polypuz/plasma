-- Monster Tasks by mdziekon
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

local function isRequirementFulfilled(requirement, player)
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
    -- Check if task has been completed
  elseif type == "bossPoints" then
    -- Check if player has enough boss points
  elseif type == "taskPoints" then
    -- Check if player has enough task points
  elseif type == "lock" then
    -- Check if this task has been unlocked
  elseif type == "taskLocked" then
    -- Check if other task is locked (it's requirements are not fulfilled)
  end

  return true
end

local function isTaskUnlocked(taskID, player)
  local task = TASKSYS.TASKS[taskID]

  if task.enabled ~= true then
    return false
  end

  for i, requirement in pairs(task.requirements) do
    if isRequirementFulfilled(requirement, player) == false then
      return false
    end
  end

  return true
end

local function getPlayerActiveTaskIDs(player)
  -- Get player active task IDs

  return {}
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
