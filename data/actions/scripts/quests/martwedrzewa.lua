function onUse(cid, item, position, target, pos)
	if cid:getStorageValue(36900) ~= 1 and cid:getStorageValue(36900) ~= 2 then
		print("Gracz " .. Player(cid):getName() .. " nie wzial questa.")
		return false
	end
	
	local p_maxhealth = getCreatureMaxHealth( cid )
	
	if item.uid > 36000 and item.uid < 36006 then
		print("Gracz " .. Player(cid):getName() .. " atakuje drzewo")
		if cid:getStorageValue(item.uid) ~= 1 then
			print("Gracz " .. Player(cid):getName() .. " dokonal ataku ")
			if math.random() > 0.1 then
				--doTargetCombatHealth(0, cid, 1, -200, -750,  1)
				doTargetCombatHealth(0, cid, 1, p_maxhealth * 0.1 * -1, math.random() * p_maxhealth * -1, 1)
				doSendMagicEffect(position, CONST_ME_BLOCKHIT)
			else
				doCreatureSay(cid, 'Achhh...', TALKTYPE_ORANGE_1)
				doSendMagicEffect(position, 49)
				cid:setStorageValue(item.uid, 1)
			end
		else
			print("Gracz " .. Player(cid):getName() .. " bije drzewo ktore juz zniszczyl.")
			doSendMagicEffect(position, CONST_ME_POFF)
		end
	elseif item.uid == 36006 then -- boss
		print("Gracz " .. Player(cid):getName() .. " atakuje bossa.")
		if cid:getStorageValue(36900) == 2 then
			if cid:getStorageValue(36006) ~= 1 then
				if math.random() > 0.1 then
					doTargetCombatHealth(0, cid, 1, -800, -1400, 1)
					doSendMagicEffect(position, CONST_ME_BLOCKHIT)
				else
					doCreatureSay(cid, 'Achhh...', TALKTYPE_ORANGE_1)
					doSendMagicEffect(position, 49)
					cid:setStorageValue(36006, 1)
				end
			else
				doSendMagicEffect(position, CONST_ME_POFF)
			end
		end
	else
		print("Gracz " .. Player(cid):getName() .. " klika na czyms, co nie jest tym obiektem.")
	end
	
	
	print("Gracz " .. Player(cid):getName() .. " - po prostu zwracam wartosc.")
	print("item.uid" .. item.uid)
	print("36900 storage:" .. cid:getStorageValue( 36900))
	print("36906 storage:" .. cid:getStorageValue( 36906))
	return true
end