function onUse(cid, item, position, target, pos) -- typowy, zeby podejsc i kliknac to wszystko
	if cid:getStorageValue(23060) < 1 then
		return false
	end
	if item.uid == 23061 then
		if cid:getStorageValue(item.uid) ~= 1 then
            cid:setStorageValue(23060,2)
            cid:setStorageValue(23061,1)
            doCreatureSay(cid, 'To chyba juz cale zloto', TALKTYPE_ORANGE_1)
        else
            doCreatureSay(cid, 'Nie zostalo juz nic cennego', TALKTYPE_ORANGE_1)
        end
	end
	return true
end
