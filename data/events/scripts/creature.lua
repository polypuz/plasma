function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return true
end

function Creature:onTargetCombat(target)
    if not self then
        return true
    end

    if self:isPlayer() and target:isMonster() then
        local master = target:getMaster()
		local protection_level = getConfigInfo('protectionLevel')
		if master then
			if self == master then
				return true
			else
				if master:isPlayer() then
					local party, targetParty = self:getParty(), master:getParty()
					local guild, targetGuild = self:getGuild(), master:getGuild()
					
					if (( party and targetParty ) and party == targetParty) then
						return true
					elseif guild and targetGuild and guild:getId() == targetGuild:getId() then
						return true
					elseif master:getLevel() < protection_level or self:getLevel() < protection_level then
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
					else
						if self:getSkull() <= SKULL_WHITE and master:getSkull() == SKULL_NONE then
							self:setSkull( SKULL_WHITE )
							self:setSkullTime( getConfigInfo('pzLocked') )
						end
					end
				end
			end
		end
	end		
    return true	
end
