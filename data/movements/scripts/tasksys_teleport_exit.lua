function onStepIn(creature, item, position, fromPosition)
    local taskID = item.uid - TASKSYS.ITEM_UID_TELEPORT_EXIT
    local task = TASKSYS.TASKS[taskID]

    local entranceItem = Item(TASKSYS.ITEM_UID_TELEPORT_ENTRANCE + taskID)

    -- Safeguards
    if task == nil then
        print('[TaskSystem:Teleport] No task definition (taskID: ' .. taskID .. ')')
        creature:teleportTo(fromPosition, true)
        return false
    end

    if task["teleportSettings"] == nil then
        print('[TaskSystem:Teleport] Task has no teleport settings (taskID: ' .. taskID .. ')')
        creature:teleportTo(fromPosition, true)
        return false
    end

    -- Main part
    if not creature:isPlayer() then
        return false
    end

    local playerID = creature:getId()
    local player = Player(playerID)

    -- No item's storage, have to use hackish way to store how many players have entered the teleport
    -- But... it JUST WORKS (tm)
    local playersInside = entranceItem:getAttribute(ITEM_ATTRIBUTE_TEXT)
    if playersInside == "" then
        playersInside = 0
    else
        playersInside = tonumber(playersInside)
    end

    -- Despawn monsters
    if playersInside == 1 then
        local taskInstance = Task(taskID)

        taskInstance:despawnMonsters()
    end

    if playersInside > 0 then
        entranceItem:setAttribute(ITEM_ATTRIBUTE_TEXT, playersInside - 1)
    end

    player:setStorageValue(TASKSYS.STORAGE_KEY_ENTERED_TELEPORT, 0)
    player:setStorageValue(TASKSYS.STORAGE_KEY_TELEPORT_TASKID, -1)

    return true
end
