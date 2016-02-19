--[[ 
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	if isInArray(questDoors, itemId) then
		if player:getStorageValue(item.actionid) ~= -1 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "The door seems to be sealed against unwanted intruders.")
		end
		return true
	elseif isInArray(levelDoors, itemId) then
		if item.actionid > 0 and player:getLevel() >= item.actionid - 1000 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Only the worthy may pass.")
		end
		return true
	elseif isInArray(keys, itemId) then
		if target.actionid > 0 then
			if item.actionid == target.actionid and doors[target.itemid] then
				target:transform(doors[target.itemid])
				return true
			end
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "The key does not match.")
			return true
		end
		return false
	end

	if isInArray(horizontalOpenDoors, itemId) or isInArray(verticalOpenDoors, itemId) then
		local doorCreature = Tile(toPosition):getTopCreature()
		if doorCreature ~= nil then
			toPosition.x = toPosition.x + 1
			local query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			if query ~= RETURNVALUE_NOERROR then
				toPosition.x = toPosition.x - 1
				toPosition.y = toPosition.y + 1
				query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			end

			if query ~= RETURNVALUE_NOERROR then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, query)
				return true
			end

			doorCreature:teleportTo(toPosition, true)
		end

		if not isInArray(openSpecialDoors, itemId) then
			item:transform(itemId - 1)
		end
		return true
	end

	if doors[itemId] then
		if item.actionid == 0 then
			item:transform(doors[itemId])
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "It is locked.")
		end
		return true
	end
	return false
end
]]

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	local position = player:getPosition()
	
	
	
	if isInArray(questDoors, itemId) then
		if player:getStorageValue(item.actionid) ~= -1 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Drzwi sa zablokowane przed nieproszonymi goscmi.")
		end
		return true
	elseif isInArray(levelDoors, itemId) then
		if item.actionid > 0 and player:getLevel() >= item.actionid - 1000 then
			if (fromPosition.x == position.x) or (fromPosition.y == position.y) then
				if (position.x < fromPosition.x) then
					fromPosition.x= fromPosition.x +1
					player:teleportTo(fromPosition)
				elseif (position.x > fromPosition.x) then
					fromPosition.x= fromPosition.x -1
					player:teleportTo(fromPosition)
				elseif (position.y > fromPosition.y) then					
					fromPosition.y= fromPosition.y -1
					player:teleportTo(fromPosition)
				elseif (position.y < fromPosition.y) then
					fromPosition.y= fromPosition.y +1
					player:teleportTo(fromPosition)
				end
			else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Ustaw sie przed drzwiami.")
			end
			return true
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Masz za maly poziom.")
		end
		return true
	elseif isInArray(keys, itemId) then
		if target.actionid > 0 then
			if item.actionid == target.actionid and doors[target.itemid] then
				target:transform(doors[target.itemid])
				return true
			end
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "Posiadany klucz nie pasuje do zamka.")
			return true
		end
		return false
	end

	if isInArray(horizontalOpenDoors, itemId) or isInArray(verticalOpenDoors, itemId) then
		local doorCreature = Tile(toPosition):getTopCreature()
		if doorCreature ~= nil then
			toPosition.x = toPosition.x + 1
			local query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			if query ~= RETURNVALUE_NOERROR then
				toPosition.x = toPosition.x - 1
				toPosition.y = toPosition.y + 1
				query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			end

			if query ~= RETURNVALUE_NOERROR then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, query)
				return true
			end

			doorCreature:teleportTo(toPosition, true)
		end

		if not isInArray(openSpecialDoors, itemId) then
			item:transform(itemId - 1)
		end
		return true
	end

	if doors[itemId] then
		if item.actionid == 0 then
			item:transform(doors[itemId])
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Drzwi sa zablokowane.")
		end
		return true
	end
	return false
end
