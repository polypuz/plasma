--[[local playerPosition = {
	{x = 247, y = 659, z = 13},
	{x = 247, y = 660, z = 13},
	{x = 247, y = 661, z = 13},
	{x = 247, y = 662, z = 13}
}
local newPosition = {
	{x = 189, y = 650, z = 13},
	{x = 189, y = 651, z = 13},
	{x = 189, y = 652, z = 13},
	{x = 189, y = 653, z = 13}
}
]]
local playerPosition = {
	{ x = 1092, y = 374, z = 11 },
	{ x = 1093, y = 374, z = 11 },
	{ x = 1094, y = 374, z = 11 },
	{ x = 1095, y = 374, z = 11 }
}

local newPosition = {
	{ x = 1110, y = 375, z = 11 },
	{ x = 1111, y = 375, z = 11 },
	{ x = 1112, y = 375, z = 11 },
	{ x = 1113, y = 375, z = 11 }
}
local anniAvailableAt = 0;

local leverCd = 60 * 60 * 3 -- 3 hours 
--local leverCd = 40


function transformLever( uid )
	local from = {x=1110, y=373, z=11}
	local to = {x=1115, y=377, z=11}

	local monsters = {}
	
	for x = from.x, to.x do
		for y = from.y, to.y do
			for z = from.z, to.z do
				local v = getTopCreature({x=x, y=y, z=z})
				if v.type == 1 then
					return
				elseif v.type == 2 then
					table.insert(monsters, v.uid)
				end
			end
		end
	end	

	for i = 1, #monsters do
		doRemoveCreature(monsters[i])
	end
	
	local item = Item( uid )
		
	item:transform(1945)
	anniAvailableAt = 0;
	
	
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local players = {}
		for _, position in ipairs(playerPosition) do
			local topPlayer = Tile(position):getTopCreature()
			if topPlayer == nil or not topPlayer:isPlayer() or topPlayer:getLevel() < 100 or topPlayer:getStorageValue(30015) ~= -1 then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
				return false
			end
			players[#players + 1] = topPlayer
		end

		for i, targetPlayer in ipairs(players) do
			Position(playerPosition[i]):sendMagicEffect(CONST_ME_POFF)
			targetPlayer:teleportTo(newPosition[i], false)
			targetPlayer:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
			doSummonCreature("Demon", {x= 1110, y= 373, z= 11}, false, false )
			doSummonCreature("Demon", {x= 1112, y= 373, z= 11}, false, false)
			
			doSummonCreature("Demon", {x= 1111, y= 377, z= 11}, false, false )
			doSummonCreature("Demon", {x= 1113, y= 377, z= 11}, false, false)
			
			-- doSummonCreature("Demon", {x= 1114, y= 375, z= 11}, false, false)
			doSummonCreature("Demon", {x= 1115, y= 375, z= 11}, false, false )
		end
		item:transform(1946)
		
		addEvent(transformLever, leverCd * 1000, item.uid)
		anniAvailableAt = os.date("%c", os.time() + ( leverCd ) )
	elseif item.itemid == 1946 then
		--player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Komora anihilacyjna jest w trakcie konserwacji. Dostepna bedzie " .. anniAvailableAt )
	end
	return true
end
