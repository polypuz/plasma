local function serverClean()
--[[
	if shutdownAtServerClean then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	else
		Game.setGameState(GAME_STATE_CLOSED)

		if cleanMapAtServerClean then
			cleanMap()
		end

		Game.setGameState(GAME_STATE_NORMAL)
	end
	]]
	broadcastMessage("Czyszczenie mapy...", MESSAGE_EVENT_ADVANCE)
	local itemsCount = cleanMap()
	print("DBG: podczas czyszczenia mapy zniknelo " .. tostring(itemsCount) .. " przedmiotow.\n")
end

local function secondServerCleanWarning()
	broadcastMessage("Za minute nastapi CZYSZCZENIE mapy.", MESSAGE_STATUS_WARNING)
	addEvent(ServerClean, 60000)
end

local function firstServerCleanWarning()
	broadcastMessage("Za trzy minuty nastapi CZYSZCZENIE mapy.", MESSAGE_STATUS_WARNING)
	addEvent(secondServerCleanWarning, 120000)
end

function onTime(interval)
	broadcastMessage("Za 5 minut nastapi CZYSZCZENIE mapy. ", MESSAGE_STATUS_WARNING)
	-- Game.setGameState(GAME_STATE_STARTUP)
	addEvent(firstServerCleanWarning, 120000)
  return true
end
