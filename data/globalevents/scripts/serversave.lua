local shutdownAtServerSave = false
local cleanMapAtServerSave = false

local function serverSave()
--[[
	if shutdownAtServerSave then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	else
		Game.setGameState(GAME_STATE_CLOSED)

		if cleanMapAtServerSave then
			cleanMap()
		end

		Game.setGameState(GAME_STATE_NORMAL)
	end
	]]
	broadcastMessage("Zapisywanie stanu gry...", MESSAGE_EVENT_ADVANCE)
	saveServer()
end

local function secondServerSaveWarning()
	broadcastMessage("Za minute nastapi zapis stanu gry.", MESSAGE_STATUS_WARNING)
	addEvent(serverSave, 60000)
end

local function firstServerSaveWarning()
	broadcastMessage("Za trzy minuty nastapi zapis stanu gry.", MESSAGE_STATUS_WARNING)
	addEvent(secondServerSaveWarning, 120000)
end

function onTime(interval)
	broadcastMessage("Za 5 minut nastapi zapis stanu gry. ", MESSAGE_STATUS_WARNING)
	-- Game.setGameState(GAME_STATE_STARTUP)
	addEvent(firstServerSaveWarning, 120000)
	return not shutdownAtServerSave
end
