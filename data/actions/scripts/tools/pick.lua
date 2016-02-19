function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (target.uid <= 65535 or target.actionid > 0) and (target.itemid == 354 or target.itemid == 355) then
		target:transform(392)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	 -- shiny stone (11227)
    if target.itemid == 11227 then
		local rand = math.random(1000)
		-- 45% -> platinum coin 
		-- 49% -> small diamond 
		-- 5.5% -> gold coin
		-- 0.5% -> crystal coin
		if rand <= 450 then
			-- platinum coin
			player:addItem(2152, 1)
		elseif rand > 450 and rand <= 940 then
			-- small diamond (2145)
			player:addItem(2145, 1)
		elseif rand > 940 and rand <= 990 then
			-- gold coin (2148)
			player:addItem(2148, 1)
		elseif rand > 990 then
			-- crystal  coin (2160)
			player:addItem(2160, 1)
		end
		target:remove(1)
		return true
	end
	return false
end
