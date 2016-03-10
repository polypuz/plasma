local tasks = PLAYER_TASKS

function onKill(cid, target)
	local currentTask = cid:getStorageValue(currentTask)
	local task = tasks[currentTask]
	local monster = false
	for k, x in pairs(task.creatures) do
		if target:getName():lower() == x:lower() then
			monster = false
		end
	end
	if target:isPlayer() or not monster or target:getMaster() or currentTask == 0 or currentTask == nil then
		return true
	end
	local questKills = cid:getStorageValue(task.questKills) + 1
	if questKills < task.killsRequired then
		if ( questKills == (0) or questKills == (-1) ) then
			questKills = 1
		end

    	cid:setStorageValue(task.questKills, questKills)
    	cid:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Pozostalo Ci '..(task.killsRequired - (questKills)) .. ' ' .. table.concat(task.creatures, ', ') .. ' do zabicia.')
  	elseif questKills == task.killsRequired then
    	cid:sendTextMessage(MESSAGE_INFO_DESCR, 'Gratulacje, udalo Ci sie zabic ' .. (questKills) .. ' ' .. table.concat(task.creatures, ', ') .. ' i ukonczyc zadanie.')
    	cid:setStorageValue(task.questKills, questKills + 1)
  	end
  	return true
end




