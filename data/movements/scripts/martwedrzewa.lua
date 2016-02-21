function onStepIn(cid, item, position, to)
	if item.actionid == 36000 then
		--doCreatureSay(cid, 'X', TALKTYPE_ORANGE_1)

		local success = {x = 894, y = 2028, z = 12}
		local failure = {x = 893, y = 2035, z = 10}
		local dest = { }

		if cid:getStorageValue(36900) == 2 then
			dest = success
		else
			dest = failure
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Nie jestes jeszcze gotowy!')
		end

		doTeleportThing(cid, dest)
		doSendMagicEffect(position, CONST_ME_TELEPORT)
		doSendMagicEffect(dest, CONST_ME_TELEPORT)
	end

	return true
end