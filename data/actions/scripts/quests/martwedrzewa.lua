local function checkIfFoughtTrees( cid )
	local dead_trees_tbl = {36901, 36902, 36903, 36904, 36905}

	for key,value in pairs(dead_trees_tbl) do --actualcode
		if cid:getStorageValue( value ) ~= 1 then
			return false
		end
	end
	
	return true
end

local function rewardPlayer( cid, uniqueid)
	local unique_reward_ids = { 30021, 30022, 30023 }
	local unique_storage_key = 30025
	
	local generic_reward_id = 30024
	local generic_reward_storage_key = 30024
	
	local p = Player( cid )
	
	if uniqueid == 30024 then
		if p:getStorageValue( generic_reward_storage_key ) ~= 1 then
			-- reward
			if p:addItem(5882, 10) then
				doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles 10 lusek czerwonego smoka.")
				p:setStorageValue( generic_reward_storage_key, 1)
			end
		else
			-- failure         
			doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
		end
	elseif isInArray( unique_reward_ids, uniqueid ) then
		if p:getStorageValue( unique_storage_key ) ~= 1 then
			-- reward
			local item = nil
			local info = ""
			
			if uniqueid == 30021 then
				item = 12642
				info = "Royal Draken Mail"
			elseif uniqueid == 30022 then
				item = 12643
				info = "Royal Scale Robe"
			elseif uniqueid == 30023 then
				item = 12645
				info = "Elite Draken Helmet"
			else
				item = nil
				info = "# COS POSZLO NIE TAK. ZGLOS SIE DO ADMINISTRACJI."
			end
			
			if p:addItem(item, 1) then
				doPlayerSendTextMessage( cid, MESSAGE_INFO_DESCR, "Znalazles " .. info .. ".")
				p:setStorageValue( unique_storage_key, 1)
			end
		else
			-- failure
			doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
		end
	end
end

function onUse(cid, item, position, target, pos)

	if cid:getStorageValue(36900) ~= 1 and cid:getStorageValue(36900) ~= 2 then
		return false
	end
	
	local p_maxhealth = getCreatureMaxHealth( cid )
	
	if item.uid > 36000 and item.uid < 36006 then
		if cid:getStorageValue(item.uid) ~= 1 then
			if math.random() > 0.1 then
				--doTargetCombatHealth(0, cid, 1, -200, -750,  1)
				doTargetCombatHealth(0, cid, 1, p_maxhealth * 0.1 * -1, math.random(0.11, 0.55) * p_maxhealth * -1, 1)
				doSendMagicEffect(position, CONST_ME_BLOCKHIT)
			else
				doCreatureSay(cid, '*trzask*', TALKTYPE_ORANGE_1)
				doSendMagicEffect(position, 49)
				cid:setStorageValue(item.uid, 1)
			end
		else
			doSendMagicEffect(position, CONST_ME_POFF)
		end
	elseif item.uid == 36006 then -- boss
		if cid:getStorageValue(36900) == 2 or checkIfFoughtTrees( cid ) then
			if cid:getStorageValue(36006) ~= 1 then
				if math.random() > 0.1 then
					--doTargetCombatHealth(0, cid, 1, -800, -1400, 1)
					doTargetCombatHealth(0, cid, 1, p_maxhealth * 0.35 * -1, math.random(0.11, 0.95) * p_maxhealth * -1, 1)

					doSendMagicEffect(position, CONST_ME_BLOCKHIT)
				else
					doCreatureSay(cid, '*trzask*', TALKTYPE_ORANGE_1)
					doSendMagicEffect(position, 49)
					cid:setStorageValue(36006, 1)
				end
			else
				doSendMagicEffect(position, CONST_ME_POFF)
			end
		end
	else
		if item.uid > 30020 and item.uid < 30025
			rewardPlayer( cid, item.uid )
		else
		end
	end
	
	return true
end