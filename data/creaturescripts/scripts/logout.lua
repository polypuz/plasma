function onLogout(player)
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] ~= nil then
		nextUseStaminaTime[playerId] = nil
	end

    -- Task system

    if player:getStorageValue(TASKSYS.STORAGE_KEY_ENTERED_TELEPORT) == 1 then
        local taskID = player:getStorageValue(TASKSYS.STORAGE_KEY_TELEPORT_TASKID)

        player:teleportTo(player:getTown():getTemplePosition())
        player:setStorageValue(TASKSYS.STORAGE_KEY_ENTERED_TELEPORT, 0)
        player:setStorageValue(TASKSYS.STORAGE_KEY_TELEPORT_TASKID, -1)

        -- Despawn monsters
        local taskInstance = Task(taskID)
        local entranceItem = Item(TASKSYS.ITEM_UID_TELEPORT_ENTRANCE + taskID)

        local playersInside = entranceItem:getAttribute(ITEM_ATTRIBUTE_TEXT)
        if playersInside == "" then
            playersInside = 0
        else
            playersInside = tonumber(playersInside)
        end

        if playersInside == 1 then
            taskInstance:despawnMonsters()
        end

        if playersInside > 0 then
            entranceItem:setAttribute(ITEM_ATTRIBUTE_TEXT, playersInside - 1)
        end
    end


	return true
end
