local function CheckIfAllCalms( cid )
	local closed_calm = {23001, 23002, 23003, 23004, 23005, 23006, 23007, 23008, 23009, 23010, 23011, 23012, 23013, 23014, 23015, 23016}
-- idki malz
	for key,value in pairs(closed_calm) do -- sprawdznie czy alles wziete
		if cid:getStorageValue( value ) ~= 1 then
			return false
		end
	end
	cid:setStorageValue(23017,2)
	return true
end

function onUse(cid, item, position, target, pos)
	
	if cid:getStorageValue(23017) < 1 then -- czy ktos zaczal klesta
		return false
	end
	
	
	if item.uid > 23000 and item.uid < 23017 then
		if cid:getStorageValue(item.uid) ~= 1 then
      if cid:getItemCount(ItemType(2403):getId()) > 0 then -- czy ma Knife
        if math.random() < 0.2 then -- a czasem moze sie polamac, tak bywa
          doCreatureSay(cid, '*trzask*', TALKTYPE_ORANGE_1)
          cid:removeItem(ItemType(2403):getId(), 1) -- i wtedy zabieramy ziomkowi jeden knife
        else
          doCreatureSay(cid, 'Wyjales perle', TALKTYPE_ORANGE_1) 
          doSendMagicEffect(position, 49)
          cid:setStorageValue(item.uid, 1) -- uaktualnienie id malzy
        end
      else -- jak ktos nie ma noza
        doCreatureSay(cid, 'W trakcie otwierania malza wyslizgnela ci sie z rak', TALKTYPE_ORANGE_1)
        doSendMagicEffect(position, CONST_ME_POFF)
      end
    else -- jak juz wyjete z tej malzy
      doCreatureSay(cid, 'W srodku nie bylo perly', TALKTYPE_ORANGE_1)
      doSendMagicEffect(position, CONST_ME_POFF)     
		end
    CheckIfAllCalms(cid)
	end
	return true
end
