local function hasCompletedQuest( cid )
	-- these are also defined in data/actions/scripts/quests/martwedrzewa.lua
	-- and are set when you receive a reward from any of the chests
	local generic_reward_storage_key = 30024
	local unique_storage_key = 30025
	-- end of the storage keys
	
	local p = Player( cid )
	
	if p:getStorageValue( generic_reward_storage_key ) == 1 or p:getStorageValue( unique_storage_key ) == 1 then
		return true
	else
		return false
	end
end

function onStepIn(cid, item, position, to)
	if item.actionid == 36000 then
		--doCreatureSay(cid, 'X', TALKTYPE_ORANGE_1)

		local success = {x = 894, y = 2028, z = 12}
		local failure = {x = 893, y = 2035, z = 10}
		local dest = { }

		if cid:getStorageValue(36900) == 3 and not hasCompletedQuest( cid ) then
			dest = success
		else
			dest = failure
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Nie jestes jeszcze gotowy, lub ukonczyles juz to zadanie!')
		end

		doTeleportThing(cid, dest)
		doSendMagicEffect(position, CONST_ME_TELEPORT)
		doSendMagicEffect(dest, CONST_ME_TELEPORT)
	end

	return true
end
