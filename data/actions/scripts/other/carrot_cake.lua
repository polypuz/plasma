local condition = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(condition, CONDITION_PARAM_TICKS, 60 * 60 * 1000) -- 60 minutes
setConditionParam(condition, CONDITION_PARAM_SKILL_DISTANCE, 10)

function onUse(cid, item, fromPosition, itemEx, toPosition)
        local player = Player( cid )
        if(doAddCondition(cid, condition)) then
                doSendMagicEffect(fromPosition, CONST_ME_MAGIC_GREEN)
                player:say("Mniamusne.", TALKTYPE_MONSTER_SAY)
                doRemoveItem(item.uid)
        end
        return true
end