local config = {
    [5908] = {
        -- Minotaurs
        [2830] = {value = 6750, newItem = 5878}, -- minotaur
        [2871] = {value = 5170, newItem = 5878}, -- archer
        [2866] = {value = 6670, newItem = 5878}, -- mage
        [2876] = {value = 7200, newItem = 5878}, -- guard
        [3090] = {value = 6750, newItem = 5878}, -- some minotar boss? (looks like normal minotaur)

        -- Low Class Lizards
        [4259] = {value = 3550, newItem = 5876}, -- sentinel
        [4262] = {value = 7040, newItem = 5876}, -- snake
        [4256] = {value = 4200, newItem = 5876}, -- templar

        -- High Class Lizards
        [11288] = {value = 25000, newItem = 5876, after = 11286}, -- chosen
        [11276] = {value = 9760, newItem = 5876, after = 11274}, -- legionare
        [11280] = {value = 7590, newItem = 5876, after = 11278}, -- priest
        [11272] = {value = 10000, newItem = 5876, after = 11270}, -- high class
        [11284] = {value = 20000, newItem = 5876, after = 11282}, -- zaogun

        -- Dragons
        [3104] = {value = 4640, newItem = 5877},
        [2844] = {value = 4640, newItem = 5877},

        -- Dragon Lords
        [2881] = {value = 3450, newItem = 5948},

        -- Behemoths
        [2931] = {value = 6000, newItem = 5893},

        -- Bone Beasts
        [3031] = {value = 5010, newItem = 5925},

        -- The Mutated Pumpkin
        [8961] = { { value = 5000, newItem = 7487 }, { value = 10000, newItem = 7737 }, { value = 20000, 6492 }, { value = 30000, newItem = 8860 }, { value = 45000, newItem = 2683 }, { value = 60000, newItem = 2096 }, { value = 90000, newItem = 9005, amount = 50 } },
    },
    [5942] = {
        -- Demon
        [2916] = {value = 25000, newItem = 5906},

        -- Vampires
        [2956] = {value = 4480, newItem = 5905}, -- vampire
        [9654] = {value = 5430, newItem = 5905, after = 9658}, -- bride
        [8938] = {value = 25000, newItem = 5905}, --lord
        [21275] = {value = 2040, newItem= 5905} -- viscount
    }
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local skin = config[item.itemid][target.itemid]
    if target.itemid == 11343 then -- marble sclupting
        local rand = math.random(10000)
        target:getPosition():sendMagicEffect(tonumber(10))
        if rand <= 3757 then
            if rand <= 830 then
                target:transform(11344)
                target:setDescription("Ta mizerna praca zostala wykonana przez ".. player:getName() ..".")
            elseif rand > 830 and rand <= 12501 then
                target:transform(11345)
                target:setDescription("Ta mala statuetka zostala wykonana przez ".. player:getName() .."... i wymaga poprawek.")
            else
                target:transform(11346)
                target:setDescription("Ta statuetka Tibiasuli zostala mistrzowsko wyrzezbiona przez ".. player:getName() ..".")
            end
        else
            player:say('Proba uksztaltowania tego marmurowego bloczku zakonczyla sie fiaskiem.', TALKTYPE_MONSTER_SAY)
            target:remove()
        end
    end
   
    if isInArray({7441, 7442, 7444, 7445}, target.itemid) then -- ice cube
        local rand = math.random(100000)
        target:getPosition():sendMagicEffect(tonumber(10))   
        if target.itemid == 7445 and rand <= 7000 then
            player:addAchievement('Ice Sculptor')
            target:transform(7446)
        elseif target.itemid == 7444 and rand <= 10000 then
            target:transform(7445)
        elseif target.itemid == 7442 and rand <= 20000 then
            target:transform(7444)
        elseif target.itemid == 7441 and rand <= 31000 then
            target:transform(7442)
        else
            target:remove()
            player:say('Proba rzezbienia zakonczyla sie porazka. Nawet Tobie jest wstyd.', TALKTYPE_MONSTER_SAY)
        end
    end       
   
    -- Wrath of the emperor quest
    if item.itemid == 5908 and target.itemid == 12295 then
        target:transform(12287)
        player:say("Udaje Ci sie wystrugac calkiem dobra miske.", TALKTYPE_MONSTER_SAY)
    -- An Interest In Botany Quest
    elseif item.itemid == 5908 and target.itemid == 11691 and player:getItemCount(12655) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 1 then
        player:say("The plant feels cold but dry and very soft. You streak the plant gently with your knife and put a fragment in the almanach.", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 2)
    elseif item.itemid == 5908 and target.itemid == 11653 and player:getItemCount(12655) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 2 then
        player:say("You cut a leaf from a branch and put it in the almanach. It smells strangely sweet and awfully bitter at the same time.", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 3)
    end

    if not skin then
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end
   
    local random, effect, transform = math.random(1, 10000), CONST_ME_MAGIC_GREEN, true
    if type(skin[1]) == 'table' then
        local added = false
        for _, _skin in ipairs(skin) do
            if random <= _skin.value then
                player:addItem(_skin.newItem, _skin.amount or 1)
                added = true
            break
            end
        end

        if not added and target.itemid == 8961 then
            effect = CONST_ME_POFF
            transform = false
        end
    elseif random <= skin.value then
        player:addItem(skin.newItem, skin.amount or 1)
    else
        effect = CONST_ME_POFF
    end

    toPosition:sendMagicEffect(effect)
    if transform then
        target:transform(skin.after or target.itemid + 1)
    end

    return true
end
