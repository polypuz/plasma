function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storageKey = 20331 --this is our storage key for the quest
	
	if getPlayerStorageValue(player, storageKey) == -1 then
		doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, "Znalazles skarb pochowanego tu faraona, zwanego Klejnotem Nilu.")
		doPlayerAddItem(player, 2160, 20)
		setPlayerStorageValue( player, 20331, 1)
	else
		doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
	end
	
	return true
end
