function onSay(player, words, param)
	local hasAccess = player:getGroup():getAccess()
	local players = Game.getPlayers()
	local playerCount = Game.getPlayerCount()

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

						local voc = ""
						if targetPlayer:getVocation():getId() == 1 then voc = " S"
						elseif targetPlayer:getVocation():getId() == 2 then voc = " D"
						elseif targetPlayer:getVocation():getId() == 3 then voc = " P"
						elseif targetPlayer:getVocation():getId() == 4 then voc = " K"
						elseif targetPlayer:getVocation():getId() == 5 then voc = " MS"
						elseif targetPlayer:getVocation():getId() == 6 then voc = " ED"
						elseif targetPlayer:getVocation():getId() == 7 then voc = " RP"
						elseif targetPlayer:getVocation():getId() == 8 then voc = " EK"
							
						msg = msg .. targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. voc .. "]"
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
