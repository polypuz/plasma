function onStepIn(creature, item, position, fromPosition)
    local taskID = item.uid - TASKSYS.ITEM_UID_TELEPORT_ENTRANCE
    local task = TASKSYS.TASKS[taskID]

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

    local state = player:getStorageValue(TASKSYS.STORAGE_KEY_STATE_START + taskID)

    if state ~= TASKSYS.STATES.ACTIVE then
        doPlayerSendTextMessage(playerID, MESSAGE_INFO_DESCR, "You shall not pass!")
        creature:teleportTo(fromPosition, true)
        return true
    end

    -- No item's storage, have to use hackish way to store how many players have entered the teleport
    -- But... it JUST WORKS (tm)
    local playersInside = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
    if playersInside == "" then
        playersInside = 0
    else
        playersInside = tonumber(playersInside)
    end

    if playersInside >= task.teleportSettings.maxPlayers then
        doPlayerSendTextMessage(playerID, MESSAGE_INFO_DESCR, "You shall not pass!")
        creature:teleportTo(fromPosition, true)
        return true
    end

    -- Spawn monster
    if playersInside == 0 and task.teleportSettings.monsters ~= nil then
        local monsters = task.teleportSettings.monsters

        if TASKSYS.TASKS_TEMP_STORAGE[taskID] == nil then
            TASKSYS.TASKS_TEMP_STORAGE[taskID] = TASKSYS.TASKS_TEMP_STORAGE_TEMPLATE()
        end

        local tempStorage = TASKSYS.TASKS_TEMP_STORAGE[taskID]

        for idx, monster in pairs(monsters) do
            local monsterInstance = Game.createMonster(
                monster.name,
                Position(monster.pos.x, monster.pos.y, monster.pos.z),
                false,
                true
            )

            table.insert(tempStorage.monsterUIDs, monsterInstance:getId())
        end
    end

    item:setAttribute(ITEM_ATTRIBUTE_TEXT, playersInside + 1)

    return true
end
