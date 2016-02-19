function onAdvance(cid, skill, oldLevel, newLevel)
	local player = Player(cid)
	local poziom=player:getLevel()
	local bank= player:getBankBalance()
	
        if skill == SKILL_LEVEL then
		player:addHealth(player:getMaxHealth())
		player:getPosition():sendMagicEffect(math.random(CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_BLUE))
		player:say("LEVEL UP!", TALKTYPE_ORANGE_1)
		player:save()
		
		
	
			if poziom == 15 and player:getStorageValue(3015) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 15 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+2000)
				player:setStorageValue(3015, 1)
				
			elseif poziom == 30 and player:getStorageValue(3030) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 30 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+4000)
				player:setStorageValue(3030, 1)
			
			elseif poziom == 50 and player:getStorageValue(3050) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 50 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+10000)
				player:setStorageValue(3050, 1)
			
			elseif poziom == 75 and player:getStorageValue(3075) < 1 then			
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 75 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+15000)
				player:setStorageValue(3075, 1)
			
			elseif poziom == 100 and player:getStorageValue(3100) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 100 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+30000)
				player:setStorageValue(3100, 1)
				
			end
			
		
	end
	return true
end