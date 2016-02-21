function onSay(player, words, param)
	local hasAccess = player:getGroup():getAccess()
	local players = Game.getPlayers()
	local playerCount = Game.getPlayerCount()

	local vocNames = {" S", " D", " P", " K", " MS", " ED", " RP", " EK"}
	local playerGuild = player:getGuild()

	local i = 0
	if playerGuild then
		local playerGuildId = playerGuild:getId()
		local msg = "Twoja gildia: "

		for k, targetPlayer in ipairs(players) do
			if hasAccess or not targetPlayer:isInGhostMode() then
				if targetPlayer:getGuild() then
					if targetPlayer:getGuild():getId() == playerGuildId then
						if i > 0 then
							msg = msg .. ", "
						end

						if targetPlayer:getVocation():getId() > 0 and targetPlayer:getVocation():getId() < 9 then
							msg = msg .. targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. vocNames[targetPlayer:getVocation():getId()] .. "]"
						else
							msg = msg .. targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. "]"
						end

						i = i + 1
					end
				end
			end

			if i == 10 then
				if k == playerCount then
					msg = msg .. "."
				else
					msg = msg .. ","
				end
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
				msg = ""
				i = 0
			end
		end

		if i > 0 then
			msg = msg .. "."
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
		end
	end
	return false
end
