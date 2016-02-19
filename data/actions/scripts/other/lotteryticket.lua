function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if math.random(50) == 1 then
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		player:say("Gratulacje! Wygrales nagrode!", TALKTYPE_MONSTER_SAY)
		item:transform(5958)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:say("Niestety nic nie wygrales.", TALKTYPE_MONSTER_SAY)
		item:remove(1)
	end
	return true
end