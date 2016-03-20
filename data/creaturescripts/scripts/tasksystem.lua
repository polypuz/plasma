local function getPlayerTaskProgress(player, taskID)
  local value = player:getStorageValue(TASKSYS.STORAGE_KEY_PROGRESS_START + taskID)

  if value == -1 then
    return 0
  end

  return value
end

local function setPlayerTaskProgress(player, taskID, value)
  player:setStorageValue(TASKSYS.STORAGE_KEY_PROGRESS_START + taskID, value)
end

function onKill(player, target)
    -- Players do not count
    if target:isPlayer() then
        return true
    end

    -- Summons do not count
    if target:getMaster() then
        return true
    end

    -- Get active tasks
    local activeTasks = {}

    local i = 0

    while i < TASKSYS.MAX_CONCURRENT_TASKS do
        local slot = player:getStorageValue(TASKSYS.STORAGE_KEY_ACTIVE_START + i)

        if slot ~= -1 then
            table.insert(activeTasks, slot)
        end

        i = i + 1
    end


    -- For each active task, check if monster matches requirements
    for idx, taskID in pairs(activeTasks) do
        local task = TASKSYS.TASKS[taskID]
        local monsterName = target:getName():lower()
        local monsterMatches = false

        for cIdx, creatureName in pairs(task.creatures) do
            if creatureName:lower() == monsterName then
                monsterMatches = true
                break
            end
        end

        if monsterMatches then
            local taskProgress = getPlayerTaskProgress(player, taskID)
            local taskKillsRequired = task.killsRequired

            if taskProgress == -1 then
                taskProgress = 0
            end

            taskProgress = taskProgress + 1

            if (taskProgress <= taskKillsRequired) then
                setPlayerTaskProgress(player, taskID, taskProgress)

                if (taskProgress == taskKillsRequired) then
                    local msg = "Wlasnie udalo Ci sie zabic " ..
                        taskKillsRequired ..
                        ". potwora z zadania " ..
                        task.raceName ..
                        ". Wroc do NPC_NAME po nagrode."

                    player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
                end
            end
        end
    end

    return true
end
