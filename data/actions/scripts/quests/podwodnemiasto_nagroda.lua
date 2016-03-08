local function rewardPlayer( cid, uniqueid)
	
	local p = Player( cid )
	
	if uniqueid == 23084 then
		if p:getStorageValue(23084) ~= 1 then
			-- reward
			if p:addItem(9971, 30) then
				doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles 30 sztabek zlota.")
				p:setStorageValue(23084, 1)
			end
		else
			-- failure         
			doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
		end
	end
end