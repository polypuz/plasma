function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rand = math.random(1000)
	-- 64% - nothing
    -- 25% - Rough Clay Statue (11340)
    -- 9.5% - Clay Statue (11341)
    -- 1.5%% - Pretty Clay Statue (11342)

    if rand > 640 and rand <= 890 then
		player:addItem(11340, 1)
    elseif rand > 890 and rand <= 985 then
		player:addItem(11341, 1)
    elseif rand > 985 then
		player:addItem(11342, 1)
    end
	item:remove(1)
    return true
end