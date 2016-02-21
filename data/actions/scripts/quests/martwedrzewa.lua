local function checkIfFoughtTrees( cid )
	local dead_trees_tbl = [36901, 36902, 36903, 36904, 36905]

	for key,value in pairs(dead_trees_tbl) do --actualcode
		if cid:getStorageValue( value ) ~= 1 then
			return false
		end
	end
	
	return true
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
	end
	
	return true
end