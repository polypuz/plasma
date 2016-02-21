function onStepIn(cid, item, position, to)
	if item.actionid == 36000 then
		--doCreatureSay(cid, 'X', TALKTYPE_ORANGE_1)

		local success = {x = 1003, y = 824, z = 7}
		local failure = {x = 1017, y = 826, z = 7}
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