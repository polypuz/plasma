function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid <= 1000 or item.uid > 22700 then
		print("Chest has no uid matching, giving nothing.")
		return false
	end

	local itemType = ItemType(item.itemid)
	local itemWeight = itemType:getWeight()
	local playerCap = player:getFreeCapacity()
	if player:getStorageValue(item.uid) == -1 then
		if playerCap >= itemWeight then
			print("Chest has uid " .. tostring( item.uid ) .. ". Giving an item.")
			player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found a ' .. itemType:getName() .. '.')
			player:addItem(item.uid, 1)
			player:setStorageValue(item.uid, 1)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found a ' .. itemType:getName() .. ' weighing ' .. itemWeight .. ' oz it\'s too heavy.')
		end
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
	end
	return true
end
