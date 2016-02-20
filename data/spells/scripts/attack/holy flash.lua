function onCastSpell(creature, variant)
	local combat = nil

	combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLHOLY)

	local condition = nil
	condition = Condition(CONDITION_DAZZLED)
	condition:setParameter(CONDITION_PARAM_DELAYED, true)

    local repeats = (creature:getMagicLevel() / 2) + 7
    condition:addDamage(repeats, 5000, -20)
	combat:setCondition(condition)
	return combat:execute(creature, variant)
end
