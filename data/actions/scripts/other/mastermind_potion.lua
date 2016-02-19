local condition = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(condition, CONDITION_PARAM_TICKS, 10 * 60 * 1000) -- 10 minutes
setConditionParam(condition, CONDITION_PARAM_STAT_MAGICLEVEL, 3)
setConditionParam(condition, CONDITION_PARAM_SKILL_SHIELD, -10)

function onUse(cid, item, fromPosition, itemEx, toPosition)
--[[
	if(not isSorcerer(cid) and not isDruid(cid)) then
		doCreatureSay(cid, "Only sorcerers and druids may drink this fluid.", TALKTYPE_ORANGE_1, cid)
		return true
	end
	]]
	local player = Player( cid )
	if( player:getVocation() ~= 5) then
		player:say( cid, "Tylko czarodzieje i druidzi moga wypic ten eliksir.", TALKTYPE_MONSTER_SAY)
	end
		
	if(doAddCondition(cid, condition)) then
		doSendMagicEffect(fromPosition, CONST_ME_MAGIC_RED)
		doRemoveItem(item.uid)
		--doCreatureSay(cid, "You feel smarter.", TALKTYPE_ORANGE_1, cid)
		player:say(cid, "Czujesz sie madrzejszy.", TALKTYPE_MONSTER_SAY )
	end

	return true
end