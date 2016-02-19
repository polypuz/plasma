local condition = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(condition, CONDITION_PARAM_TICKS, 10 * 60 * 1000) -- 10 minutes
setConditionParam(condition, CONDITION_PARAM_SKILL_DISTANCE, 5)
setConditionParam(condition, CONDITION_PARAM_SKILL_SHIELD, -10)

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player( cid )
	if(doAddCondition(cid, condition)) then
		doSendMagicEffect(fromPosition, CONST_ME_MAGIC_RED)
		player:say(cid, "Czujesz, ze nie bedziesz mial problemow z trafieniem w oko. Hehe.", TALKTYPE_MONSTER_SAY)
		doRemoveItem(item.uid)
	end

	return true
end