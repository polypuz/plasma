function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 2782 then
		target:transform(2781)
		target:decay()
		return true
	end
	if target.itemid == 19433 then
		target:transform(19431)
		target:decay()
		return true
	end
	if target.itemid == 1499 then
		target:remove(1)
        return true
    end
	return destroyItem(player, target, toPosition)
end
