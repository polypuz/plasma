function onStepIn(cid, item, position, to)
	if item.actionid == 23083 then
		local success = {x = 1322, y = 853, z = 14}
		local failure = {x = 1169, y = 877, z = 14}
		local dest = { }

		if cid:getStorageValue(23083) < 2 then
			dest = success
		else
			dest = failure
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Nie masz juz czego tam szukac')
		end

		doTeleportThing(cid, dest)
		doSendMagicEffect(position, CONST_ME_TELEPORT)
		doSendMagicEffect(dest, CONST_ME_TELEPORT)
	end

	return true
end