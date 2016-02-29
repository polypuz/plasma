function onStepIn(cid, item, position, fromPosition)
	local _teleport_earth = { x=496, y=937, z=8}
	local _teleport_fire = { x=386, y=998, z=8}
	local _teleport_neutral= { x=497, y=998, z=8}
	local _teleport_ice = { x=388, y=930, z=8}
	-- teleport back: 873, 1051, 7
	local magic_voc = "Tylko profesje magiczne moga przejsc dalej."
	local druid = "Tylko druidzi z poziomem 30 lub wyzszym sa w stanie przejsc przez te wrota."
	local sorcerer = "Tylko czarodzieje z poziomem 30 lub wyzszym sa w stanie przejsc przez te wrota."
	local not_enough_gems = "Aby przejsc przez wrota musisz posiadac przynajmniej jeden niemagiczny kamien."
	 --if getPlayerVocation(cid) == 2 or getPlayerVocation(cid) == 6 and getPlayerLevel(cid) >= 30 and isPremium(cid) == TRUE then
	local effect = 10 -- teleportation effect
	local player_voc = getPlayerVocation( cid )
	--[[
		druid = 2, 6
		sorcerer = 1, 5
	]]
	if not ( player_voc == 2 or player_voc == 6 or player_voc == 1 or player_voc == 5 ) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, magic_voc)
		return false
	else
		if item.actionid == 19971 then --the energy (neutral) one SMALL AMETHYST, SORC
			if player_voc == 1 or player_voc == 5 then
				if getPlayerItemCount(cid,2150) ~= 0 then
                    doTeleportThing(cid, _teleport_neutral)
                    doPlayerTakeItem(cid,2150, getPlayerItemCount(cid, 2150))
                    doPlayerAddItem(cid,7762, getPlayerItemCount(cid, 2150), false)
					doSendMagicEffect(tele,effect)
                elseif getPlayerItemCount(cid,2150) == 0 then
                    --doMoveCreature(cid, newdir)
                    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, not_enough_gems)
					return false
                end
			else
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, sorcerer)
				return false
			end
		elseif item.actionid == 19972 then --the fire one SMALL RUBY, SORC			
			if player_voc == 1 or player_voc == 5 then
				if getPlayerItemCount(cid,2147) ~= 0 then
                    doTeleportThing(cid, _teleport_fire)
                    doPlayerTakeItem(cid, 2147, getPlayerItemCount(cid, 2147))
                    doPlayerAddItem(cid, 7760, getPlayerItemCount(cid, 2147), false)
					doSendMagicEffect(tele,effect)
                elseif getPlayerItemCount(cid,2147) == 0 then
                    --doMoveCreature(cid, newdir)
                    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, not_enough_gems)
					return false
                end
			else
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, sorcerer)
				return false
			end
		elseif item.actionid == 19973 then --earth SMALL EMERALD, DRUID		
			if player_voc == 2 or player_voc == 6 then
				if getPlayerItemCount(cid,2149) ~= 0 then
                    doTeleportThing(cid, _teleport_earth)
                    doPlayerTakeItem(cid,2149, getPlayerItemCount(cid, 2149))
                    doPlayerAddItem(cid,7761, getPlayerItemCount(cid, 2149), false )
					doSendMagicEffect(tele,effect)
                elseif getPlayerItemCount(cid,2149) == 0 then
                    --doMoveCreature(cid, newdir)
                    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, not_enough_gems)
					return false
                end
			else
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, druid)
				return false
			end
		elseif item.actionid == 19974 then --ice SMALL SAPPHIRE, DRUID
			if player_voc == 2 or player_voc == 6 then
				if getPlayerItemCount(cid,2146) ~= 0 then
                    doTeleportThing(cid, _teleport_ice)
                    doPlayerTakeItem(cid,2146, getPlayerItemCount(cid, 2146))
                    doPlayerAddItem(cid,7759, getPlayerItemCount(cid, 2146), false)
					doSendMagicEffect(tele,effect)
                elseif getPlayerItemCount(cid,2146) == 0 then
                    --doMoveCreature(cid, newdir)
                    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, not_enough_gems)
					return false
                end
			else
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, druid)
				return false
			end
		end
	end
	return true
end
