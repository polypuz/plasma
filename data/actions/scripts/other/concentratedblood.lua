function onUse(cid, item, frompos, item2, topos)
	if doRemoveItem(item.uid,6558) then
		if math.random(100) > 50 then
			doPlayerSendTextMessage(cid,22,"Wstrzasnales flakonikiem... i uzyskales Strong Health Potion.")
			doPlayerAddItem(cid,7588,1)
		else
			doPlayerSendTextMessage(cid,22,"Wstrzasnales flakonikiem... i uzyskales Strong Mana Potion.")
			doPlayerAddItem(cid,7589,1)			
		end
	end
end